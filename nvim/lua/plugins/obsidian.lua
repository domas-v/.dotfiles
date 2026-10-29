local notes = require("config.notes")

local function pick_notes(folder, title, exclude)
    return Snacks.picker.files({
        title = title,
        cwd = vim.fs.joinpath(tostring(Obsidian.dir), folder),
        ft = "md",
        exclude = exclude,
    })
end

local function new_note()
    vim.ui.input({ prompt = "New note: " }, function(title)
        if not title or vim.trim(title) == "" then
            return
        end
        title = vim.trim(title)
        local slug = title:lower():gsub("[^%w%s-]", ""):gsub("%s+", "-")
        local path = vim.fs.joinpath(notes.vault, "notes", slug .. ".md")
        vim.cmd.edit(vim.fn.fnameescape(path))
        if vim.fn.filereadable(path) == 0 then
            vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# " .. title, "", "" })
            vim.api.nvim_win_set_cursor(0, { 3, 0 })
        end
    end)
end

local function capture()
    vim.ui.input({ prompt = "Capture: " }, function(text)
        if not text or vim.trim(text) == "" then
            return
        end
        local buf = vim.fn.bufadd(notes.inbox)
        vim.fn.bufload(buf)
        local last = vim.api.nvim_buf_line_count(buf)
        while last > 0 and vim.trim(vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1]) == "" do
            last = last - 1
        end
        vim.api.nvim_buf_set_lines(buf, last, -1, false, { "- [ ] " .. vim.trim(text) })
        vim.api.nvim_buf_call(buf, function() vim.cmd("silent write") end)
        vim.notify("Captured to inbox", vim.log.levels.INFO, { title = "Notes" })
    end)
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
                end,
            },
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
            { "<leader>od",   "<cmd>Agenda<cr>",                                                          desc = "Open agenda" },
            { "<leader>ob",   "<cmd>Obsidian backlinks<cr>",                                              desc = "Show note backlinks" },
            { "<leader>op",   function() return pick_notes("projects", "Projects", { "archive/**" }) end, desc = "Pick a project" },
            { "<leader>oa",   function() return pick_notes("areas", "Areas") end,                         desc = "Pick an area" },
            { "<leader>on",   function() return pick_notes("notes", "Notes") end,                         desc = "Pick a note" },
            { "<leader>nn",   new_note,                                                                   desc = "New note" },
            { "<leader>nc",   capture,                                                                    desc = "Capture to inbox" },
            { "<leader><cr>", "<cmd>Obsidian toggle_checkbox<cr>",                                        desc = "Toggle task checkbox" },
        },
    },
}
