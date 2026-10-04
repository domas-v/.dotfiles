local notes = require("config.notes")

local function pick_notes(folder, title, exclude)
    return Snacks.picker.files({
        title = title,
        cwd = vim.fs.joinpath(tostring(Obsidian.dir), folder),
        ft = "md",
        exclude = exclude,
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
                    path = notes.vault,
                },
            },
            picker = {
                name = "snacks.picker",
            },
            templates = {
                folder = notes.templates,
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
        },
        keys = {
            {
                "<leader>oi",
                function()
                    vim.cmd.edit(notes.inbox)
                end,
                desc = "Open notes inbox",
            },
            {
                "<leader>oI",
                function()
                    vim.cmd.edit(notes.index)
                end,
                desc = "Open notes index",
            },
            -- agenda & calendar
            { "<leader>od",   "<cmd>Agenda<cr>",                                                          desc = "Open today's agenda" },
            { "<leader>oc",   "<cmd>Calendar<cr>",                                                        desc = "Open agenda calendar" },
            { "<leader>ou",   "<cmd>Unscheduled<cr>",                                                     desc = "Open unscheduled tasks" },

            -- notes
            { "<leader>ob",   "<cmd>Obsidian backlinks<cr>",                                              desc = "Show note backlinks" },
            { "<leader>op",   function() return pick_notes("projects", "Projects", { "archive/**" }) end, desc = "Pick a project" },
            { "<leader>oa",   function() return pick_notes("areas", "Areas") end,                         desc = "Pick an area" },
            { "<leader>os",   "<cmd>NotesScheduleTask<cr>",                                               desc = "Schedule task under cursor" },
            { "<leader>oS",   "<cmd>NotesSortTasks<cr>",                                                  desc = "Sort tasks in the current list" },
            { "<leader>om",   "<cmd>NotesMoveTaskToday<cr>",                                              desc = "Move task to today's note" },
            { "<leader>oM",   "<cmd>NotesMoveTaskTomorrow<cr>",                                           desc = "Move task to tomorrow's note" },
            { "<leader>ox",   "<cmd>NotesCompleteTask<cr>",                                               desc = "Toggle task completion and date" },
            { "<leader><cr>", "<cmd>NotesCompleteTask<cr>",                                               desc = "Toggle task checkbox" },
        },
    },
}
