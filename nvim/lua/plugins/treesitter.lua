return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = function() require("nvim-treesitter").update() end,
        config = function()
            require("nvim-treesitter").install({
                "bash", "c", "diff", "html", "json", "lua", "luadoc",
                "markdown", "markdown_inline", "python", "query",
                "regex", "toml", "vim", "vimdoc", "yaml",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local bufnr = args.buf
                    if not pcall(vim.treesitter.start, bufnr) then return end

                    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldenable = false
                end,
            })

            vim.keymap.set({ "n", "x" }, "<CR>", function()
                vim.treesitter.select("parent", vim.v.count1)
            end, { desc = "Select parent Treesitter node" })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
            })

            local select = require("nvim-treesitter-textobjects.select").select_textobject
            local move   = require("nvim-treesitter-textobjects.move")

            ---------- FUNCTIONS ---------- 
            vim.keymap.set({ "x", "o" }, "af", function() select("@function.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "if", function() select("@function.inner", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]f",
                function() move.goto_next_start("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[f",
                function() move.goto_previous_start("@function.outer", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]F",
                function() move.goto_next_end("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[F",
                function() move.goto_previous_end("@function.outer", "textobjects") end)

            ---------- CLASSES ---------- 
            vim.keymap.set({ "x", "o" }, "ac", function() select("@class.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ic", function() select("@class.inner", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]c",
                function() move.goto_next_start("@class.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[c",
                function() move.goto_previous_start("@class.outer", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]C",
                function() move.goto_next_end("@class.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[C",
                function() move.goto_previous_end("@class.outer", "textobjects") end)

            ---------- CALLS ---------- 
            vim.keymap.set({ "x", "o" }, "ax", function() select("@call.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ix", function() select("@call.inner", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]x", function() move.goto_next_start("@call.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[x", function() move.goto_previous_start("@call.outer", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]X", function() move.goto_next_end("@call.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[X", function() move.goto_previous_end("@call.outer", "textobjects") end)

            ---------- PARAMETERS ---------- 
            vim.keymap.set({ "x", "o" }, "aa", function() select("@parameter.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ia", function() select("@parameter.inner", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end)

            ---------- OTHER MOVEMENTS ---------- 
            vim.keymap.set({ "x", "o" }, "al", function() select("@loop.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "il", function() select("@loop.inner", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ai", function() select("@conditional.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ii", function() select("@conditional.inner", "textobjects") end)


        end,
    },
}
