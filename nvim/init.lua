require("settings")
require("remap")
require("config.lazy")

vim.cmd("colorscheme kanagawa-dragon")

-- htto filetype is not detected somehow. this is a fix
vim.filetype.add({
    extension = {
        http = "http",
    }
})
