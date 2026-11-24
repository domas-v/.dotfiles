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
            -- render-markdown.nvim handles rendering; obsidian's UI double-conceals
            ui = {
                enable = false,
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
            callbacks = {
                -- obsidian maps <C-x> to date decrement; keep the global bufdelete
                enter_note = function(note)
                    pcall(vim.keymap.del, "n", "<C-x>", { buffer = note.bufnr })
                    -- smart action: toggle checkboxes via notes_tasks so ✅ done dates are kept in sync
                    vim.keymap.set("n", "<CR>", function()
                        local keys = require("obsidian.actions").smart_action()
                        if keys:find("toggle_checkbox", 1, true) then
                            return "<cmd>TaskToggle<cr>"
                        end
                        return keys
                    end, { expr = true, buffer = note.bufnr, desc = "Obsidian Smart Action" })
                end,
            },
        },
        keys = {
            {
                "<leader>ni",
                function()
                    vim.cmd.edit(notes.inbox)
                end,
                desc = "Open notes inbox",
            },
            { "<leader>nd",   "<cmd>Agenda<cr>",                                                          desc = "Open agenda" },
            { "<leader>nb",   "<cmd>Obsidian backlinks<cr>",                                              desc = "Show note backlinks" },
            { "<leader>np",   function() return pick_notes("projects", "Projects", { "archive/**" }) end, desc = "Pick a project" },
            { "<leader>na",   function() return pick_notes("areas", "Areas") end,                         desc = "Pick an area" },
            { "<leader>nn",   function() return pick_notes("notes", "Notes") end,                         desc = "Pick a note" },
            { "<leader>ns",   function() require("notes_tasks").schedule() end, mode = { "n", "x" },       desc = "Schedule task (⏳)" },
            { "<leader><cr>", function() require("notes_tasks").toggle() end, mode = { "n", "x" },       desc = "Toggle task (✅ date)" },
        },
    },
}
