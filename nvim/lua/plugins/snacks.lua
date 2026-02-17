local normalize_list = function(t)
    local normalized = {}
    for _, v in pairs(t) do
        if v ~= nil then
            table.insert(normalized, v)
        end
    end
    return normalized
end

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    init = function() _G.Snacks = require("snacks") end,
    config = function()
        local MAC_SCREEN_SIZE = 190

        local function side_explorer_width()
            if vim.o.columns <= MAC_SCREEN_SIZE then
                return 0.15
            end
            return 30
        end

        local function yank_path(picker, item)
            vim.fn.setreg("+", item.file)
            vim.notify("Copied path: " .. item.file)
        end

        local harpoon = require("harpoon")
        local function harpoon_add(picker, item)
            local relative_path = vim.fn.fnamemodify(item.file, ":~:.")
            harpoon:list():add({
                value = relative_path,
                context = {
                    row = item.pos and item.pos[1] or 1,
                    col = item.pos and item.pos[2] or 0,
                }
            })
            vim.schedule(function()
                vim.cmd("redrawtabline")
            end)
            vim.notify("Added to harpoon " .. relative_path)
        end

        local function harpoon_delete(picker, item)
            local to_remove = item or picker:selected()
            harpoon:list():remove({ value = to_remove.text })
            harpoon:list().items = normalize_list(harpoon:list().items)
            vim.schedule(function()
                vim.cmd("redrawtabline")
            end)
            picker:find({ refresh = true })
        end

        _G.Snacks.setup({
            -- plugins
            bigfile = { enabled = true },
            image = { enabled = true, math = { enabled = false } },
            indent = { enabled = true, animate = { enabled = false } },
            quickfile = { enabled = true },
            gitbrowse = { enabled = true },
            bufdelete = { enabled = true },
            explorer = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
                layout = {
                    cycle = true,
                    preset = "vertical"
                },
                matcher = {
                    fuzzy = true,
                    smartcase = true,
                    ignorecase = true,
                    sort_empty = false,
                    filename_bonus = true,
                    file_pos = true,
                    cwd_bonus = true,
                    frecency = true,
                    history_bonus = true,
                },
                sources = {
                    explorer = { layout = { width = side_explorer_width } },
                    commands = { layout = { preview = false } },
                    keymaps = { layout = { preview = false } },
                    help = { layout = { preview = false } },
                    grep = { layout = { preset = "ivy" } },
                    grep_word = { layout = { preset = "ivy" } },
                    lsp_symbols = { layout = { preset = "ivy" } },
                    lsp_workspace_symbols = { layout = { preset = "ivy" } },
                },
                actions = {
                    yank_path = yank_path,
                    harpoon_add = harpoon_add,
                    harpoon_delete = harpoon_delete
                },
                win = {
                    input = {
                        keys = {
                            ["<C-y>"] = { "yank_path", mode = { "n", "i" } },
                            ["y"] = { "yank_path", mode = { "n" } },
                            [","] = { "harpoon_add", mode = { "n" } },
                            ["<"] = { "harpoon_delete", mode = { "n" } },
                        },
                    },
                    list = {
                        keys = {
                            ["<C-y>"] = { "yank_path", mode = { "n", "i" } },
                            ["y"] = { "yank_path", mode = { "n" } },
                            [","] = { "harpoon_add", mode = { "n" } },
                            ["<"] = { "harpoon_delete", mode = { "n" } },
                        }
                    }
                },
            },
        })

        if harpoon then
            vim.keymap.set("n", "<leader>;", function()
                Snacks.picker({
                    finder = function()
                        local file_paths = {}
                        local list = normalize_list(harpoon:list().items)
                        for _, item in ipairs(list) do
                            table.insert(file_paths, { text = item.value, file = item.value })
                        end
                        return file_paths
                    end,
                    win = {
                        input = {
                            keys = {
                                ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
                                ["<C-x>"] = { "harpoon_delete", mode = { "n", "i" } },
                                ["<"] = { "harpoon_delete", mode = { "n", } },
                            },
                        },
                        list = {
                            keys = {
                                ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
                                ["<"] = { "harpoon_delete", mode = { "n", } },
                            },
                        },
                    },
                    actions = {
                        harpoon_delete = function(picker, item)
                            local to_remove = item or picker:selected()
                            harpoon:list():remove({ value = to_remove.text })
                            harpoon:list().items = normalize_list(harpoon:list().items)
                            vim.schedule(function()
                                vim.cmd("redrawtabline")
                            end)
                            picker:find({ refresh = true })
                        end,
                    },
                })
            end)
        end
    end,
    keys = {
        { "<C-x>",     function() Snacks.bufdelete() end },
        { "<leader>?", function() Snacks.picker() end },

        -- buffers
        { "<leader>b", function() Snacks.picker.buffers() end },
        {
            "<leader>e",
            function()
                Snacks.picker.explorer({ focus = "list", layout = { preset = "vertical" }, auto_close = true, })
            end
        },
        { "<leader><TAB>", function() Snacks.picker.explorer() end },
        { "<leader>/",     function() Snacks.picker.lines() end },
        { "<leader>M",     function() Snacks.picker.marks() end },

        -- search
        { "<leader>f",     function() Snacks.picker.smart({ focus = "input" }) end },
        { "<leader>r",     function() Snacks.picker.grep() end },
        { "<leader>R",     function() Snacks.picker.grep_word() end,                                           mode = { "n", "v" } },

        -- lsp
        { "gd",            function() Snacks.picker.lsp_definitions({ layout = { preset = "ivy" } }) end,      mode = "n" },
        { "grr",           function() Snacks.picker.lsp_references({ layout = { preset = "ivy" } }) end,       mode = "n" },
        { "<leader>s",     function() Snacks.picker.lsp_symbols({ layout = { preset = "ivy" } }) end },
        { "<leader>S",     function() Snacks.picker.lsp_workspace_symbols({ layout = { preset = "ivy" } }) end },
        { "<leader>D",     function() Snacks.picker.diagnostics_buffer({ layout = { preset = "ivy" } }) end },

        -- git
        { "<leader>go",    function() Snacks.gitbrowse() end },
    }
}
