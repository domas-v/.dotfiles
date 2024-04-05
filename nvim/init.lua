require("settings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--hranch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("remap")

require("lazy").setup("plugins", {
    change_detection = {
        notify = false,
    },
})


vim.cmd("colorscheme kanagawa")


-- Function to save cursor position in buffer mark
-- local function save_cursor_position()
--     vim.api.nvim_command('normal! m`')
-- end

-- Function to restore cursor position from buffer mark
-- local function restore_cursor_position()
--     if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
--         vim.api.nvim_command('normal! g`"')
--     end
-- end

-- Set autocmd for CursorHold and CursorHoldI events to save cursor position
-- vim.cmd([[
--     augroup RestoreCursorPosition
--         autocmd!
--         autocmd CursorHold,CursorHoldI * lua save_cursor_position()
--     augroup END
-- ]])

-- Set autocmd for BufReadPost event to restore cursor position
-- vim.cmd([[
--     augroup RestoreCursorPosition
--         autocmd!
--         autocmd BufReadPost * lua restore_cursor_position()
--     augroup END
-- ]])


-- TODO: 
-- lua neovim development/autocomplete
