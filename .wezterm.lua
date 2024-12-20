local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- colorscheme
-- switch theme based on system appearance
local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return "GitHub Dark"
    else
        return "Github"
    end
end
config.color_scheme = scheme_for_appearance(get_appearance())

-- font
config.font = wezterm.font("JetBrains Mono", {weight = "DemiBold"} )
config.font_size = 13.0

-- window appearance
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- tab bar
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.status_update_interval = 1000
config.show_tab_index_in_tab_bar = false

---------- keybindings ----------
local act = wezterm.action
config.leader = { key = 'a', mods = 'CMD' }

config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },
}

config.keys = {
    -- utils
    { key = 'q', mods = 'CTRL',       action = act.DisableDefaultAssignment },
    { key = 'Q', mods = 'CTRL',       action = act.DisableDefaultAssignment },
    { key = ';', mods = 'CMD',        action = act.ActivateCommandPalette },
    { key = 'n', mods = 'CMD|SHIFT',  action = act.SpawnWindow },

    -- scrolling
    { key = 'u', mods = 'CMD|SHIFT',   action = act.ScrollByPage(-0.5) },
    { key = 'd', mods = 'CMD|SHIFT',   action = act.ScrollByPage(0.5) },

    -- text navigation
    { key = 'c', mods = "CMD|SHIFT",  action = act.ActivateCopyMode },
    { key = "f", mods = "CTRL|SHIFT", action = act { SendString = "\x1bf" } },
    { key = "b", mods = "CTRL|SHIFT", action = act { SendString = "\x1bb" } },
    { key = 'e', mods = 'CMD|SHIFT',
        action = act.QuickSelectArgs {
            label = 'open url',
            patterns = { 'https?://\\S+' },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.open_with(url)
            end) }
    },

    -- tab navigation
    { key = 'a',     mods = 'CMD|SHIFT', action = act.ShowTabNavigator },
    { key = 't',     mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { cwd = "~", } },
    { key = 'w',     mods = 'CMD|SHIFT', action = act.CloseCurrentTab { confirm = true } },
    { key = 'n',     mods = 'CMD',       action = act.ActivateTabRelative(1) },
    { key = 'p',     mods = 'CMD',       action = act.ActivateTabRelative(-1) },
    { key = '[',     mods = 'CMD',       action = act.MoveTabRelative(-1) },
    { key = ']',     mods = 'CMD',       action = act.MoveTabRelative(1) },

    -- splits
    { key = 'f',     mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
    { key = 'w',     mods = 'CMD',       action = act.CloseCurrentPane { confirm = false } },
    { key = 'Enter', mods = 'CMD|SHIFT', action = act.SplitHorizontal { cwd = "~" } },
    { key = 'Enter', mods = 'CMD',       action = act.SplitHorizontal },
    { key = 'v',     mods = 'CMD|SHIFT',
        action = act.SplitPane {
            direction = 'Right',
            size = { Percent = 50 }, }
    },
    { key = 's'    , mods = 'CMD|SHIFT',
        action = act.SplitPane {
            direction = 'Down',
            size = { Percent = 30 }, }
    },

    -- pane navigation
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
