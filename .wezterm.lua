local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end


-- functionality
config.enable_scroll_bar = true

-- appearance
local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return "tokyonight_night"
    else
        return "tokyonight_day"
    end
end

config.color_scheme = scheme_for_appearance(get_appearance())

config.font = wezterm.font { family = "JetBrains Mono", }
config.font_size = 12.0

-- keybindings
local act = wezterm.action
config.leader = { key = 'a', mods = 'CMD' }
config.keys = {
    -- utils
    { key = 'q', mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = 'Q', mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = ':', mods = 'CMD',      action = act.ActivateCommandPalette },
    { key = 'X', mods = 'CMD',      action = act.ActivateCopyMode },
    { key = 'N', mods = 'CMD',      action = act.SpawnWindow },

    -- scrolling
    { key = 'u', mods = 'CMD|CTRL', action = act.ScrollByPage(-0.5) },
    { key = 'd', mods = 'CMD|CTRL', action = act.ScrollByPage(0.5) },

    -- text navigation
    { key = "F", mods = "CTRL",     action = wezterm.action { SendString = "\x1bf" } },
    { key = "B", mods = "CTRL",     action = wezterm.action { SendString = "\x1bb" } },
    {
        key = 'E',
        mods = 'CMD',
        action = act.QuickSelectArgs {
            label = 'open url',
            patterns = { 'https?://\\S+' },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.open_with(url)
            end) }
    },

    -- tab navigation
    { key = 'A',     mods = 'CMD',       action = act.ShowTabNavigator },
    { key = 'T',     mods = 'CMD',       action = act.SpawnCommandInNewTab { cwd = "~", } },
    { key = 'W',     mods = 'CMD',       action = act.CloseCurrentTab { confirm = true } },
    { key = 'n',     mods = 'CMD',       action = act.ActivateTabRelative(1) },
    { key = 'p',     mods = 'CMD',       action = act.ActivateTabRelative(-1) },
    { key = '[',     mods = 'CMD',       action = act.MoveTabRelative(-1) },
    { key = ']',     mods = 'CMD',       action = act.MoveTabRelative(1) },

    -- pane navigation
    { key = 'S',     mods = 'CMD',       action = act.PaneSelect },
    { key = 'm',     mods = 'CMD',       action = act.TogglePaneZoomState },
    { key = 'w',     mods = 'CMD',       action = act.CloseCurrentPane { confirm = false } },
    { key = 'Enter', mods = 'CMD',       action = act.SplitHorizontal },
    { key = 'Enter', mods = 'CMD|SHIFT', action = act.SplitHorizontal { cwd = "~" } },
    {
        key = 'v',
        mods = 'CMD|CTRL',
        action = act.SplitPane {
            direction = 'Right',
            size = { Percent = 50 }, }
    },

    { key = 'Enter', mods = 'CMD|CTRL',  action = act.SplitVertical },
    {
        key = 's',
        mods = 'CMD|CTRL',
        action = act.SplitPane {
            direction = 'Down',
            size = { Percent = 40 }, }
    },

    { key = 'h',     mods = 'CMD',       action = act.ActivatePaneDirection 'Left' },
    { key = 'j',     mods = 'CMD',       action = act.ActivatePaneDirection 'Down' },
    { key = 'k',     mods = 'CMD',       action = act.ActivatePaneDirection 'Up' },
    { key = 'l',     mods = 'CMD',       action = act.ActivatePaneDirection 'Right' },
    { key = 'h',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Left', 10 } },
    { key = 'j',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Down', 10 } },
    { key = 'k',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Up', 10 } },
    { key = 'l',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Right', 10 } },
    { key = 'h',     mods = 'CMD|SHIFT', action = act.RotatePanes 'Clockwise' },
    { key = 'l',     mods = 'CMD|SHIFT', action = act.RotatePanes 'CounterClockwise', },
}

return config
