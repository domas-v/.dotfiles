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

        _G.Snacks.setup({
            -- plugins
            bigfile = { enabled = true },
            image = { enabled = true, },
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
                }
            },
        })

        local harpoon = require("harpoon")
        if harpoon then
            vim.keymap.set("n", "<leader>,", function()
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
                            },
                        },
                        list = {
                            keys = {
                                ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
                                ["<C-x>"] = { "harpoon_delete", mode = { "n", "i" } },
                            },
                        },
                    },
                    actions = {
                        harpoon_delete = function(picker, item)
                            local to_remove = item or picker:selected()
                            harpoon:list():remove({ value = to_remove.text })
                            harpoon:list().items = normalize_list(harpoon:list().items)
                            picker:find({ refresh = true })
                        end,
                    },
                })
            end)
        end
    end,
    keys = {
        { "<C-x>",     function() Snacks.bufdelete() end },
        { "<leader>x", function() Snacks.bufdelete() end },
        { "<leader>?", function() Snacks.picker() end },

        -- buffers
        { "<leader><", function() Snacks.picker.buffers() end },
        {
            "<leader>e",
            function()
                Snacks.picker.explorer({ focus = "list", layout = { preset = "vertical" }, auto_close = true, })
            end
        },
        { "<leader><TAB>", function() Snacks.picker.explorer() end },
        { "<leader>/",     function() Snacks.picker.lines() end },
        { "<leader>m",     function() Snacks.picker.marks() end },

        -- search
        { "<leader>f",     function() Snacks.picker.files({ focus = "input" }) end },
        { "<leader>r",     function() Snacks.picker.grep() end },
        { "<leader>R",     function() Snacks.picker.grep_word() end,               mode = { "n", "v" } },

        -- lsp
        { "<leader>s",     function() Snacks.picker.lsp_symbols() end },
        { "<leader>S",     function() Snacks.picker.lsp_workspace_symbols() end },
        { "<leader>d,",    function() Snacks.picker.diagnostics_buffer() end },

        -- git
        { "<leader>gb",    function() Snacks.picker.git_branches() end },
        { "<leader>gl",    function() Snacks.picker.git_log() end },
        { "<leader>gf",    function() Snacks.picker.git_log_file() end },
        { "<leader>gz",    function() Snacks.picker.git_stash() end },
        { "<leader>go",    function() Snacks.gitbrowse() end },
    }
}
