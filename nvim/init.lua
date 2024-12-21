require("settings")
require("remap")
require("config.lazy")

-- vim.cmd("colorscheme github_light") -- dark
vim.cmd("colorscheme github_dark_dimmed") -- dark

-- htto filetype is not detected somehow. this is a fix
vim.filetype.add({
    extension = {
        http = "http",
    }
})
