local wezterm = require "wezterm"
local config = wezterm.config_builder()
local helpers = require("helpers")

-- colors
if not helpers.is_dark() then
    config.color_scheme = "catppuccin-latte"
else
    config.color_scheme = "catppuccin-frappe"
end

-- fonts
config.font = wezterm.font({ family = "JetBrainsMono Nerd Font" })
-- config.font = wezterm.font({ family = "MonaspiceKr Nerd Font" })
config.font_size = 12.5

-- window settings
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE|TITLE"

-- tab bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 300
config.colors = { tab_bar = helpers.tab_bar_colors }

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, conf, hover, max_width)
        return { { Text = " " .. helpers.get_title(tab) .. " " } }
    end
)
wezterm.on('update-status', function(window)
    local color_scheme = window:effective_config().resolved_palette
    window:set_right_status(wezterm.format(helpers.get_right_status(window, color_scheme)))
end)

-- keybindings
local act = wezterm.action
config.keys = {
    -- general
    { key = ';',     mods = 'CMD',      action = act.ActivateCommandPalette, },
    { key = ':',     mods = 'CMD',      action = act.ShowLauncher },
    { key = 'P',     mods = 'CMD',      action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
    { key = "X",     mods = 'CMD',      action = act.ActivateCopyMode, },
    { key = "'",     mods = 'CMD',      action = act.QuickSelect },

    { key = '=',     mods = 'CMD',      action = act.IncreaseFontSize },
    { key = '-',     mods = 'CMD',      action = act.DecreaseFontSize },
    { key = '+',     mods = 'CMD',      action = act.ResetFontSize },
    { key = '=',     mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = '-',     mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = ' ',     mods = 'CTRL',     action = act.DisableDefaultAssignment },

    -- splits
    { key = 'Enter', mods = 'CMD',      action = act.SplitHorizontal },
    { key = 'w',     mods = 'CMD',      action = act.CloseCurrentPane { confirm = true }, },
    { key = 'v',     mods = 'CMD|CTRL', action = act.SplitHorizontal },
    { key = 's',     mods = 'CMD|CTRL', action = act.SplitVertical },
    { key = 'B',     mods = 'CMD',      action = act.SplitPane { direction = 'Down', size = { Percent = 30 } } },
    { key = 'h',     mods = 'CMD',      action = act.ActivatePaneDirection 'Left' },
    { key = 'j',     mods = 'CMD',      action = act.ActivatePaneDirection 'Down' },
    { key = 'k',     mods = 'CMD',      action = act.ActivatePaneDirection 'Up' },
    { key = 'l',     mods = 'CMD',      action = act.ActivatePaneDirection 'Right' },
    { key = 'F',     mods = 'CMD',      action = act.TogglePaneZoomState },

    -- tabs
    { key = 't',     mods = 'CMD|CTRL', action = act.ShowTabNavigator },
    { key = 'T',     mods = 'CMD',      action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir } },
    { key = 'C',     mods = 'CMD',      action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir .. "/.dotfiles", args = { "nvim" } } },
    { key = 'n',     mods = 'CMD',      action = act.ActivateTabRelative(1) },
    { key = 'p',     mods = 'CMD',      action = act.ActivateTabRelative(-1) },
    { key = '[',     mods = 'CMD',      action = act.MoveTabRelative(-1) },
    { key = ']',     mods = 'CMD',      action = act.MoveTabRelative(1) },
}

return config
