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

-- colors
-- one of: ["kanagawa", "catppuccin"]
vim.cmd.colorscheme("kanagawa")
vim.cmd [[highlight LeapBackdrop guifg=#777777]]
