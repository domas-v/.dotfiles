local function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local wezterm = require("wezterm")
local utf8 = require("utf8")
local module = {}


local function is_dark()
    if wezterm.gui then
        return wezterm.gui.get_appearance():find("Dark")
    end
    return true
end

module.is_dark = is_dark

function module.get_title(tab)
    local title = tab.tab_title
    if title and #title > 0 then
        return title
    end

    local pane = tab.active_pane
    local file_path = ""
    if pane.current_working_dir ~= nil then
        file_path = pane.current_working_dir.file_path
        if file_path == wezterm.home_dir .. "/.dotfiles" then
            file_path = wezterm.nerdfonts.seti_config
        elseif file_path == wezterm.home_dir then
            file_path = wezterm.nerdfonts.linux_apple
        else
            file_path = file_path:match("[^/]+$")
        end

        file_path = file_path .. " "
    end

    local process = basename(pane.foreground_process_name)
    if process == "zsh" then
        process = wezterm.nerdfonts.seti_shell
    elseif process == "nvim" then
        process = wezterm.nerdfonts.linux_neovim .. " "
    end

    return process .. ": " .. file_path
end

function module.get_index(tab)
    return " " .. tab.tab_index + 1 .. ": "
end

module.tab_bar_colors = {
    background = '#1b1032',
    active_tab = {
        bg_color = '#2b2042',
        fg_color = '#c0c0c0',
        intensity = 'Bold',
    },
    inactive_tab = {
        bg_color = '#1b1032',
        fg_color = '#808080',
    },
    inactive_tab_hover = {
        bg_color = '#3b3052',
        fg_color = '#909090',
    },
    new_tab = {
        bg_color = '#1b1032',
        fg_color = '#808080',
        intensity = 'Bold'
    },
    new_tab_hover = {
        bg_color = '#3b3052',
        fg_color = '#909090',
        intensity = 'Bold'
    }
}

local function segments_for_right_status(window)
    local result = {}

    if window:active_workspace() then
        table.insert(result, window:active_workspace())
    end
    if window:active_pane() and window:active_pane():get_domain_name() then
        table.insert(result, window:active_pane():get_domain_name())
    end

    table.insert(result, wezterm.hostname())

    return result
end

function module.get_right_status(window, color_scheme)
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    local segments = segments_for_right_status(window)

    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    local gradient_to, gradient_from = bg, nil
    if is_dark() then
        gradient_from = gradient_to:lighten(0.2)
    else
        gradient_from = gradient_to:darken(0.2)
    end

    local gradient = wezterm.color.gradient(
        {
            orientation = 'Horizontal',
            colors = { gradient_from, gradient_to },
        },
        #segments
    )

    local elements = {}
    for i, seg in ipairs(segments) do
        local is_first = i == 1

        if is_first then
            table.insert(elements, { Background = { Color = 'none' } })
        end
        table.insert(elements, { Foreground = { Color = gradient[i] } })
        table.insert(elements, { Text = SOLID_LEFT_ARROW })

        table.insert(elements, { Foreground = { Color = fg } })
        table.insert(elements, { Background = { Color = gradient[i] } })
        table.insert(elements, { Text = ' ' .. seg .. ' ' })
    end

    return elements
end

return module
