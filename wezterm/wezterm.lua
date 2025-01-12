local wezterm = require "wezterm"
local helpers = require("helpers")

local config = wezterm.config_builder()

-- colors
if not helpers.is_dark() then
    config.color_scheme = "catppuccin-latte"
else
    config.color_scheme = "catppuccin-mocha"
end

-- fonts
config.font_size = 13

-- window settings
config.window_background_opacity = 1.0
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
    { key = '0',     mods = 'CMD',      action = act.ResetFontSize },
    { key = '=',     mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = '-',     mods = 'CTRL',     action = act.DisableDefaultAssignment },
    { key = ' ',     mods = 'CTRL',     action = act.DisableDefaultAssignment },

    -- scrollback
    { key = 'u',     mods = 'CMD',      action = act.ScrollByLine(-1) },
    { key = 'd',     mods = 'CMD',      action = act.ScrollByLine(1) },
    { key = 'U',     mods = 'CMD',      action = act.ScrollByPage(-0.5) },
    { key = 'D',     mods = 'CMD',      action = act.ScrollByPage(0.5) },

    -- panes
    { key = 'w',     mods = 'CMD',      action = act.CloseCurrentPane { confirm = true }, },
    { key = 'f',     mods = 'CMD|CTRL', action = act.TogglePaneZoomState },
    { key = 'Enter', mods = 'CMD',      action = act.SplitHorizontal },
    { key = 'v',     mods = 'CMD|CTRL', action = act.SplitHorizontal },
    { key = 's',     mods = 'CMD|CTRL', action = act.SplitVertical },
    { key = '`',     mods = 'CMD',      action = act.SplitPane { direction = 'Down', size = { Percent = 30 } } }, -- TODO: make it so that it either creates or focuses the terminal below

    { key = 'w',     mods = 'CMD|CTRL', action = act.PaneSelect { mode = "SwapWithActive", alphabet = "qwertasd" } },
    { key = 'h',     mods = 'CMD',      action = act.ActivatePaneDirection 'Left' },
    { key = 'j',     mods = 'CMD',      action = act.ActivatePaneDirection 'Down' },
    { key = 'k',     mods = 'CMD',      action = act.ActivatePaneDirection 'Up' },
    { key = 'l',     mods = 'CMD',      action = act.ActivatePaneDirection 'Right' },

    { key = 'h',     mods = 'CMD|CTRL', action = act.AdjustPaneSize { "Left", 9 } },
    { key = 'j',     mods = 'CMD|CTRL', action = act.AdjustPaneSize { 'Down', 7 } },
    { key = 'k',     mods = 'CMD|CTRL', action = act.AdjustPaneSize { 'Up', 7 } },
    { key = 'l',     mods = 'CMD|CTRL', action = act.AdjustPaneSize { 'Right', 9 } },

    -- tabs
    {
        key = 't',
        mods = 'CMD|CTRL',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(
                function(window, pane, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end)
        }
    },
    { key = 'T', mods = 'CMD', action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir } },
    { key = 'n', mods = 'CMD', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'CMD', action = act.ActivateTabRelative(-1) },
    { key = '[', mods = 'CMD', action = act.MoveTabRelative(-1) },
    { key = ']', mods = 'CMD', action = act.MoveTabRelative(1) },

    -- TODO: sessions
}

return config
