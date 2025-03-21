require("settings")
require("keybindings")
require("config.lazy")

vim.cmd("colorscheme catppuccin")

-- htto filetype is not detected somehow. this is a fix
vim.filetype.add({ extension = { http = "http" } })
