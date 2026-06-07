return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        main = "nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
                config = function()
                    require("nvim-treesitter-textobjects").setup({
                        select = { lookahead = true },
                    })

                    vim.keymap.set({ "x", "o" }, "af", function()
                        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
                    end, { desc = "Select outer function" })

                    vim.keymap.set({ "x", "o" }, "if", function()
                        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                    end, { desc = "Select inner function" })
                end,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            local ensureInstalled = {
                "json", "python", "javascript", "query",
                "typescript", "tsx", "php", "yaml", "html",
                "css", "markdown", "markdown_inline", "bash",
                "lua", "vim", "vimdoc", "c", "dockerfile",
                "gitignore", "astro",
            }
            local alreadyInstalled = require("nvim-treesitter.config").get_installed()
            local toInstall = vim.iter(ensureInstalled)
                :filter(function(p)
                    return not vim.tbl_contains(alreadyInstalled, p)
                end)
                :totable()
            if #toInstall > 0 then
                require("nvim-treesitter").install(toInstall)
            end
        end,
    },
}
