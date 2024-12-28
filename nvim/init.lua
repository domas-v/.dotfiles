require("settings")
require("keybindings")
require("config.lazy")

local function get_system_theme_mac()
    -- Returns `Dark` if it's dark, otherwise doesn't return anything
    local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null')
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result:match("Dark")
    end
end

if get_system_theme_mac() then
    vim.o.background = "dark"
    vim.cmd("colorscheme kanagawa-wave")
else
    vim.o.background = "light"
    vim.cmd("colorscheme kanagawa-lotus")
end

-- htto filetype is not detected somehow. this is a fix
vim.filetype.add({
    extension = {
        http = "http",
    }
})
