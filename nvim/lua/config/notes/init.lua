local priority = require("config.notes.priority")
local day = require("config.notes.views.day")
local week = require("config.notes.views.week")
local done = require("config.notes.views.done")

-- Set up priority highlight groups
priority.setup_highlights()

-- Day view variants
local function open_day_all() day.open({ title = "Today" }) end
local function open_day_work() day.open({ title = "Work", filter = "@work" }) end
local function open_day_personal() day.open({ title = "Personal", filter = "!@work" }) end

-- Wire up cross-view openers so each view can switch to the others
local openers = {
    day = open_day_all,
    work = open_day_work,
    personal = open_day_personal,
    week = function() week.open() end,
    done = function() done.open() end,
}
day.openers = openers
week.openers = openers
done.openers = openers

-- Global keymaps
vim.keymap.set("n", "<leader>A", open_day_all, { desc = "Day view (all)" })
vim.keymap.set("n", "<leader>nw", open_day_work, { desc = "Day view (work)" })
vim.keymap.set("n", "<leader>np", open_day_personal, { desc = "Day view (personal)" })
vim.keymap.set("n", "<leader>nW", function() week.open() end, { desc = "Week view" })
vim.keymap.set("n", "<leader>nx", function() done.open() end, { desc = "Done tasks" })

-- User commands
vim.api.nvim_create_user_command("Day", open_day_all, {})
vim.api.nvim_create_user_command("Work", open_day_work, {})
vim.api.nvim_create_user_command("Personal", open_day_personal, {})
vim.api.nvim_create_user_command("Week", function() week.open() end, {})
vim.api.nvim_create_user_command("Done", function() done.open() end, {})
