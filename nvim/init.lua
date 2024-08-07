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


vim.cmd("colorscheme github_dark_dimmed")
-- vim.cmd("colorscheme github_light")
