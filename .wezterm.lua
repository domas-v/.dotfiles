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
        -- config.colors = { background = 'black' }
        return "kanagawabones"
    else
        -- config.colors = { background = '#F2ECBC' }
        return "Catppuccin Latte"
    end
end

config.color_scheme = scheme_for_appearance(get_appearance())

config.font = wezterm.font { family = "JetBrains Mono", }
config.font_size = 13.0
config.window_decorations = "RESIZE"  -- remove title bar

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.window_frame = {
  font = wezterm.font { family = 'JetBrains Mono', weight = 'Bold' },

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 11.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = '#1F1F2A',

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = '#333333',
}

config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#000000',
  },
}

-- keybindings
local act = wezterm.action
config.leader = { key = 'a', mods = 'CMD' }
config.keys = {
    -- utils
    { key = 'q', mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = 'Q', mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = ':', mods = 'CMD',      action = act.ActivateCommandPalette },
    { key = 'x', mods = 'CMD',      action = act.ActivateCopyMode },
    { key = 'n', mods = 'CMD|SHIFT',      action = act.SpawnWindow },

    -- scrolling
    { key = 'u', mods = 'CMD|CTRL', action = act.ScrollByPage(-0.5) },
    { key = 'd', mods = 'CMD|CTRL', action = act.ScrollByPage(0.5) },

    -- text navigation
    { key = "f", mods = "CTRL|SHIFT",     action = wezterm.action { SendString = "\x1bf" } },
    { key = "b", mods = "CTRL|SHIFT",     action = wezterm.action { SendString = "\x1bb" } },
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
    { key = 'a',     mods = 'CMD|SHIFT',       action = act.ShowTabNavigator },
    { key = 't',     mods = 'CMD|SHIFT',       action = act.SpawnCommandInNewTab { cwd = "~", } },
    { key = 'w',     mods = 'CMD|SHIFT',       action = act.CloseCurrentTab { confirm = true } },
    { key = 'n',     mods = 'CMD',       action = act.ActivateTabRelative(1) },
    { key = 'p',     mods = 'CMD',       action = act.ActivateTabRelative(-1) },
    { key = '[',     mods = 'CMD',       action = act.MoveTabRelative(-1) },
    { key = ']',     mods = 'CMD',       action = act.MoveTabRelative(1) },

    -- pane navigation
    { key = 's',     mods = 'CMD|SHIFT',       action = act.PaneSelect },
    { key = 'm',     mods = 'CMD|SHIFT',       action = act.TogglePaneZoomState },
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
            size = { Percent = 30 }, }
    },

    { key = 'h',     mods = 'CMD',       action = act.ActivatePaneDirection 'Left' },
    { key = 'j',     mods = 'CMD',       action = act.ActivatePaneDirection 'Down' },
    { key = 'k',     mods = 'CMD',       action = act.ActivatePaneDirection 'Up' },
    { key = 'l',     mods = 'CMD',       action = act.ActivatePaneDirection 'Right' },
    { key = 'h',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'j',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'k',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'l',     mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'h',     mods = 'CMD|SHIFT', action = act.RotatePanes 'Clockwise' },
    { key = 'l',     mods = 'CMD|SHIFT', action = act.RotatePanes 'CounterClockwise', },
}

return config
