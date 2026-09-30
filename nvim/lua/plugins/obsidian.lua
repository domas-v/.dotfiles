local function pick_notes(folder, title)
    return Snacks.picker.files({
        title = title,
        cwd = vim.fs.joinpath(tostring(Obsidian.dir), folder),
        ft = "md",
    })
end

return {
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        ft = "markdown",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            legacy_commands = false,
            workspaces = {
                {
                    name = "in obs",
                    path = "/Users/domas-v/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs",
                },
            },
            picker = {
                name = "snacks.picker",
            },
            templates = {
                folder = "/Users/domas-v/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs/templates",
            },
            daily_notes = {
                folder = "daily",
                date_format = "YYYY-MM-DD",
                template = "daily-note-nvim.md",
                workdays_only = false,
            },
            checkbox = {
                order = { " ", "x" },
            },
            note_id_func = function(title)
                return title
            end,
            -- link = {
            --     format = "absolute",
            --     style = function(opts)
            --         local name = vim.fs.basename(tostring(opts.path or ""))
            --             :gsub("%.md$", "")
            --         opts.label = name
            --         return require("obsidian.builtin").wiki_link(opts)
            --     end,
            -- },

        },
        keys = {
            {
                "<leader>oi",
                function()
                    vim.cmd.edit(vim.fn.expand(
                        "/Users/domas-v/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs/inbox.md"))
                end,
                desc = "Open notes inbox",
            },
            {
                "<leader>oI",
                function()
                    vim.cmd.edit(vim.fn.expand(
                        "/Users/domas-v/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs/index.md"))
                end,
                desc = "Open notes index",
            },
            { "<leader>od",   "<cmd>Agenda<cr>",                desc = "Open today's agenda" },
            { "<leader>ob",   "<cmd>Obsidian backlinks<cr>",    desc = "Show note backlinks" },

            { "<leader>op",   function() return pick_notes("projects", "Projects") end, desc = "Pick a project" },
            { "<leader>oa",   function() return pick_notes("areas", "Areas") end,       desc = "Pick an area" },
            { "<leader>oc",   "<cmd>Calendar<cr>",              desc = "Open agenda calendar" },
            { "<leader>os",   "<cmd>NotesScheduleTask<cr>",     desc = "Schedule task under cursor" },
            { "<leader>om",   "<cmd>NotesMoveTaskToday<cr>",    desc = "Move task to today's note" },
            { "<leader>oM",   "<cmd>NotesMoveTaskTomorrow<cr>", desc = "Move task to tomorrow's note" },
            { "<leader>ox",   "<cmd>NotesCompleteTask<cr>",     desc = "Toggle task completion and date" },
            { "<leader><cr>", "<cmd>NotesCompleteTask<cr>",     desc = "Toggle task checkbox" },
        },
        config = function(_, opts)
            require("obsidian").setup(opts)
            -- Set the visual for this state after setup: the plugin emits a
            -- misleading legacy warning whenever ui.checkboxes is supplied.
            Obsidian.opts.ui.checkboxes["/"] = { char = "◐", hl_group = "DiagnosticInfo" }
            require("notes_tasks").setup({
                vault = "/Users/domas-v/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs",
                daily_folder = "daily",
                template =
                "/Users/domas-v/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs/templates/daily-note-nvim.md",

            })
        end,
    },
}
