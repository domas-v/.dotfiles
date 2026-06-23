return {
    {
        "chrisgrieser/nvim-origami",
        enabled = false,
        event = "VeryLazy",
        opts = {}, -- required even when using default config

        -- recommended: disable vim's auto-folding
        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },
    -- use Neovim nightly branch
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            -- vim.o.foldcolumn = "0"
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            vim.opt.fillchars = {
                foldopen = "⌄",
                foldclose = "›",
                fold = " ",
                foldsep = " ",
                foldinner = " ", -- ← hides the nesting-level digits
                diff = "╱",
                eob = " ",
            }
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "lsp", "indent" }
                end,
            })

            vim.opt.viewoptions = { "folds", "cursor" }
            local fold_group = vim.api.nvim_create_augroup("PersistFolds", { clear = true })
            vim.api.nvim_create_autocmd("BufWinLeave", {
                group = fold_group,
                pattern = "?*",
                desc = "Save folds/cursor",
                callback = function(args)
                    if vim.bo[args.buf].buftype == "" then
                        vim.cmd.mkview({ mods = { emsg_silent = true } })
                    end
                end,
            })
            vim.api.nvim_create_autocmd("BufWinEnter", {
                group = fold_group,
                pattern = "?*",
                desc = "Restore folds/cursor",
                command = "silent! loadview",
            })

            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
            vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
            vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
            vim.keymap.set('n', 'zk', function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    vim.fn.CocActionAsync('definitionHover')
                    vim.lsp.buf.hover()
                end
            end)
        end,
    },
    -- {
    --     "kevinhwang91/nvim-ufo",
    --     dependencies = { "kevinhwang91/promise-async" },
    --     config = function()
    --         vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    --         vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    --         require('ufo').setup({
    --             provider_selector = function(_, _, _)
    --                 return { 'treesitter', 'indent' }
    --             end,
    --             enable_get_fold_virt_text = true,
    --             open_fold_hl_timeout = 150,
    --             preview = {
    --                 win_config = {
    --                     border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    --                     winhighlight = "Normal:Folded",
    --                     winblend = 0,
    --                 },
    --                 mappings = {
    --                     jumpTop = "[",
    --                     jumpBot = "]",
    --                 },
    --             },
    --         })
    --     end
    -- }
}
