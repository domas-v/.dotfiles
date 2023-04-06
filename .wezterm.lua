local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end


-- functionality
config.enable_scroll_bar = true

-- appearance
config.color_scheme = "kanagawabones"
config.font = wezterm.font{
    family = "JetBrains Mono"
}
config.font_size = 13.0

-- keybindings
local act = wezterm.action
config.leader = { key = 'a', mods = 'CMD' }
config.keys = {
    -- utils
    { key = ':', mods = 'CMD', action = act.ActivateCommandPalette},
    { key = 'N', mods = 'CMD', action = act.SpawnWindow },
    -- tab navigation
    { key = 'T', mods = 'CMD', action = act.SpawnCommandInNewTab { cwd = "~", } },
    { key = 'n', mods = 'CMD', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'CMD', action = act.ActivateTabRelative(-1) },
    { key = '[', mods = 'CMD', action = act.MoveTabRelative(-1) },
    { key = ']', mods = 'CMD', action = act.MoveTabRelative(1) },
    { key = 'W', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },
    -- pane navigation
    { key = 'Enter', mods = 'CMD', action = act.SplitHorizontal },
    { key = 'Enter', mods = 'CMD|SHIFT', action = act.SplitHorizontal { cwd = "~" } },
    { key = 'Enter', mods = 'CMD|CTRL', action = act.SplitVertical },
    { key = 'v', mods = 'CMD|CTRL', action = act.SplitHorizontal },
    { key = 's', mods = 'CMD|CTRL', action = act.SplitVertical },
    { key = 'h', mods = 'CMD', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'CMD', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'CMD', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'CMD', action = act.ActivatePaneDirection 'Right' },
    { key = 'h', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 12 } },
    { key = 'j', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 12 } },
    { key = 'k', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 12 } },
    { key = 'l', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 12 } },
    { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = false } },
    { key = 'm', mods = 'CMD', action = act.TogglePaneZoomState },
}

return config
