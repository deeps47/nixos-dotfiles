-- scratchpads/init.lua
-- Slot-based special workspace scratchpad manager.
--
-- Super + B          → toggle special:magic (spawn fresh magic-term if slot empty)
-- Super + Shift + B  → pull focused window into special:magic (swap out occupant if any)
-- Super + Shift + N  → same for special:notes / obsidian
--
-- Moving a window out via Super+Shift+[0-9] silently empties the slot,
-- un-floats the window so it tiles normally, and the next Super+B
-- will spawn a fresh magic-term.

local guard = require("/scripts/scratchpads/guard")

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local function apply_float_rules(w)
    local mon = hl.get_active_monitor()
    if not mon then return end

    local w_px = math.floor(mon.width * 0.5)
    local h_px = math.floor(mon.height * 0.5)
    local x_px = math.floor(mon.x + (mon.width - w_px) / 2)
    local y_px = math.floor(mon.y + (mon.height - h_px) / 2)

    hl.dispatch(hl.dsp.window.float({
        action = "set",
        window = "address:" .. w.address,
    }))
    hl.dispatch(hl.dsp.window.resize({
        window = "address:" .. w.address,
        x      = w_px,
        y      = h_px,
    }))
    hl.dispatch(hl.dsp.window.move({
        window = "address:" .. w.address,
        x      = x_px,
        y      = y_px,
    }))
end

-- ---------------------------------------------------------------------------
-- Scratchpad factory
-- ---------------------------------------------------------------------------

local function make_scratchpad(opts)
    -- opts:
    --   key       string   e.g. "B"
    --   cmd       string   e.g. "kitty --class magic-term"
    --   class     string   e.g. "magic-term"  (used only for spawning)
    --   workspace string   e.g. "magic"  (becomes special:magic)

    local special      = "special:" .. opts.workspace
    local slot_address = nil

    -- Expose slot address to guard so it knows what NOT to evict
    local function get_slot() return slot_address end

    -- ---------------------------------------------------------------------------
    -- Window rule — only fires on initial open (initial_class), not after moves
    -- ---------------------------------------------------------------------------

    hl.window_rule({
        name      = opts.class .. "-scratchpad",
        match     = { initial_class = "^(" .. opts.class .. ")$" },
        float     = true,
        center    = true,
        size      = "monitor_w*0.5 monitor_h*0.5",
        workspace = special,
    })

    -- ---------------------------------------------------------------------------
    -- Slot tracking
    -- ---------------------------------------------------------------------------

    local function is_slot_occupant(w)
        return w and w.address == slot_address
    end

    -- New window opened and landed in our special workspace → claim slot
    hl.on("window.open", function(w)
        if w.workspace.name == special then
            slot_address = w.address
        end
    end)

    -- Window moved into our special workspace → claim slot
    -- Window moved OUT of our special workspace → empty slot and un-float
    hl.on("window.move_to_workspace", function(w)
        if w.workspace.name == special then
            -- Arrived → claim slot
            slot_address = w.address
        elseif is_slot_occupant(w) then
            -- Left → empty slot and restore tiling
            slot_address = nil
            hl.dispatch(hl.dsp.window.float({
                action = "unset",
                window = "address:" .. w.address,
            }))
        end
    end)

    -- Window closed or killed → empty slot
    hl.on("window.close", function(w)
        if is_slot_occupant(w) then slot_address = nil end
    end)

    hl.on("window.destroy", function(w)
        if is_slot_occupant(w) then slot_address = nil end
    end)

    -- ---------------------------------------------------------------------------
    -- Super + key  →  toggle
    -- ---------------------------------------------------------------------------

    hl.bind(mainMod .. " + " .. opts.key, function()
        if slot_address == nil then
            -- Slot empty → spawn default app, window_rule will send it to special
            hl.dispatch(hl.dsp.exec_cmd(opts.cmd))
        else
            -- Slot occupied → toggle show/hide
            hl.dispatch(hl.dsp.workspace.toggle_special(opts.workspace))
        end
    end)

    -- ---------------------------------------------------------------------------
    -- Super + Shift + key  →  pull focused window into slot (swap if occupied)
    -- ---------------------------------------------------------------------------

    hl.bind(mainMod .. " + SHIFT + " .. opts.key, function()
        local focused = hl.get_active_window()
        if not focused then return end

        -- Already the slot occupant → nothing to do
        if is_slot_occupant(focused) then return end

        -- Something is in the slot → send it to emptynm silently
        if slot_address ~= nil then
            hl.dispatch(hl.dsp.window.float({
                action = "unset",
                window = "address:" .. slot_address,
            }))
            hl.dispatch(hl.dsp.window.move({
                window    = "address:" .. slot_address,
                workspace = "emptynm",
            }))
            slot_address = nil
        end

        -- Pull focused window into special workspace
        hl.dispatch(hl.dsp.window.move({
            window    = "address:" .. focused.address,
            workspace = special,
        }))

        -- Apply float/center/size manually since window_rule only fires on open
        apply_float_rules(focused)

        -- slot_address will be claimed by the window.move_to_workspace handler
    end)

    return get_slot
end

-- ---------------------------------------------------------------------------
-- Setup — guard.setup must come after make_scratchpad so getters exist
-- ---------------------------------------------------------------------------

local get_magic_slot = make_scratchpad({
    key       = "B",
    cmd       = "kitty --class magic-term",
    class     = "magic-term",
    workspace = "magic",
})

local get_notes_slot = make_scratchpad({
    key       = "N",
    cmd       = "obsidian",
    class     = "obsidian",
    workspace = "notes",
})

guard.setup({
    ["special:magic"] = get_magic_slot,
    ["special:notes"] = get_notes_slot,
})
