local cfg = require("config.notes_config")
local format = os.date("%Y-%m-%d")

----- KEYMAPS -----

local function search_notes()
    Snacks.picker.grep({ cwd = cfg.daily_notes_path })
end
vim.keymap.set("n", "<leader>ns", search_notes, { desc = "Search notes" })
vim.api.nvim_create_user_command("SearchNotes", search_notes, {})

-- today
local function daily_note()
    local path = cfg.daily_notes_path .. format .. ".md"
    vim.cmd("edit " .. path)
    vim.cmd("normal! gg")
end
vim.api.nvim_create_user_command("DailyNote", daily_note, {})
vim.keymap.set("n", "<leader>nn", daily_note, { desc = "Daily note" })

local function quick_capture()
    local path = cfg.daily_notes_path .. format .. ".md"
    vim.cmd("edit " .. path)
    if vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "" then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# " .. format, "" })
    end
    vim.cmd("$")
    vim.api.nvim_put({ "- [ ] " }, "l", true, true)
    vim.cmd("startinsert!")
end
vim.keymap.set("n", "<leader>nc", quick_capture, { desc = "Quick capture" })
vim.api.nvim_create_user_command("QuickCapture", quick_capture, {})