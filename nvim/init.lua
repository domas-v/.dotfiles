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

-- initial colorscheme check
local current_theme = vim.fn.system('defaults read -g AppleInterfaceStyle')
current_theme = string.gsub(current_theme, "\n", "")
if (current_theme == "Dark") then
    vim.cmd('colorscheme kanagawa')
else
    vim.cmd('colorscheme kanagawa-lotus')
end
