-- scratchpads/guard.lua
-- Ensures guarded special workspaces never hold more than one window.
-- Any intruder is automatically evicted to an empty regular workspace.
--
-- Works in tandem with init.lua — guard.setup() receives getter functions
-- so it always knows which window is the legitimate slot occupant.

local M = {}

-- workspace name -> { [address] = true }
local tracked = {}

-- workspace name -> get_slot function (returns current slot address or nil)
local guarded = {}

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local function ws_name(w)
    if not w then return "" end
    local ws = w.workspace
    if not ws then return "" end
    return tostring(ws.name or "")
end

local function get_addr(w)
    if not w then return nil end
    return w.address
end

local function count(tbl)
    local n = 0
    for _ in pairs(tbl) do n = n + 1 end
    return n
end

-- ---------------------------------------------------------------------------
-- Core logic
-- ---------------------------------------------------------------------------

local function enforce(ws)
    if not tracked[ws] or count(tracked[ws]) <= 1 then return end

    -- Ask init.lua who the legitimate occupant is
    local keep = guarded[ws]()

    -- Fall back to first tracked window if slot is somehow empty
    if not keep then
        for a in pairs(tracked[ws]) do keep = a; break end
    end

    for a in pairs(tracked[ws]) do
        if a ~= keep then
            hl.notification.create({
                text    = "[SpecialGuard] evicting intruder from " .. ws,
                timeout = 3000,
                icon    = "warning",
            })
            hl.dispatch(hl.dsp.window.move({
                window    = "address:" .. tostring(a),
                workspace = "emptynm",
            }))
            tracked[ws][a] = nil
        end
    end
end

local function track(w)
    if not w then return end
    local ws = ws_name(w)
    local a  = get_addr(w)
    if not guarded[ws] or not a then return end
    tracked[ws][a] = true
    enforce(ws)
end

local function untrack(w)
    if not w then return end
    local a = get_addr(w)
    if not a then return end
    -- Search all workspaces since closing windows may report stale workspace info
    for _, addrs in pairs(tracked) do
        if addrs[a] then
            addrs[a] = nil
            return
        end
    end
end

local function on_move_to_workspace(w)
    if not w then return end
    local a      = get_addr(w)
    local new_ws = ws_name(w)
    if not a then return end

    -- Remove from any guarded workspace it is leaving
    for guarded_ws, addrs in pairs(tracked) do
        if guarded_ws ~= new_ws and addrs[a] then
            addrs[a] = nil
        end
    end

    -- Track it if it arrived in a guarded workspace
    if guarded[new_ws] then
        tracked[new_ws][a] = true
        enforce(new_ws)
    end
end

-- ---------------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------------

--- Setup the guard for a table of special workspaces.
--- Must be called AFTER make_scratchpad so getter functions exist.
---
--- @param specials table  e.g. { ["special:magic"] = get_magic_slot, ... }
function M.setup(specials)
    for name, get_slot in pairs(specials) do
        guarded[name] = get_slot  -- store getter, not a boolean
        tracked[name] = {}
    end

    hl.on("window.open",              track)                -- new window spawned
    hl.on("window.move_to_workspace", on_move_to_workspace) -- handles both arrival and departure
    hl.on("window.close",             untrack)              -- window closed cleanly
    hl.on("window.destroy",           untrack)              -- window killed / crashed
end

return M
