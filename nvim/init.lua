require("settings")
require("remap")
require("config.lazy")

vim.cmd("colorscheme kanagawa-wave") -- dark
-- vim.cmd("colorscheme kanagawa-lotus") -- light

-- htto filetype is not detected somehow. this is a fix
vim.filetype.add({
    extension = {
        http = "http",
    }
})
