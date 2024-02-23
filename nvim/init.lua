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


vim.cmd("colorscheme kanagawa-dragon")

vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr-o:hor20"

