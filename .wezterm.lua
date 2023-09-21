local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- colorscheme
-- switch theme based on system appearance
-- local function get_appearance()
--     if wezterm.gui then
--         return wezterm.gui.get_appearance()
--     end
--     return 'Dark'
-- end
-- local function scheme_for_appearance(appearance)
--     if appearance:find 'Dark' then
--         -- config.colors = { background = 'black' }
--         return "kanagawabones"
--     else
--         -- config.colors = { background = '#F2ECBC' }
--         return "Catppuccin Latte"
--     end
-- end
config.color_scheme = "kanagawabones" -- scheme_for_appearance(get_appearance())

-- font
config.font = wezterm.font { family = "JetBrains Mono", }
config.font_size = 13.0

-- window appearance
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.status_update_interval = 1000
wezterm.on("update-status", function(window, pane)
    local stat = window:active_workspace()
    local stat_color = "#f7768e"

    if window:active_key_table() then
        stat = window:active_key_table()
        stat_color = "#7dcfff"
    end
    if window:leader_is_active() then
        stat = "LDR"
        stat_color = "#bb9af7"
    end

    -- Current working directory
    local basename = function(s)
        -- Nothing a little regex can't fix
        return string.gsub(s, "(.*[/\\])(.*)", "%2")
    end
    -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l). Not a big deal, but check in case
    local cwd = pane:get_current_working_dir()
    cwd = cwd and basename(cwd) or ""
    -- Current command
    local cmd = pane:get_foreground_process_name()
    cmd = cmd and basename(cmd) or ""

      -- Left status (left of the tab line)
      window:set_left_status(wezterm.format({
          { Foreground = { Color = stat_color } },
          { Text = "  " },
          { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
          { Text = " |" },
      }))
       -- Right status
       window:set_right_status(wezterm.format({
           -- Wezterm has a built-in nerd fonts
           -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
           { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
           { Text = " | " },
           { Foreground = { Color = "#e0af68" } },
           { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
           "ResetAttributes",
           { Text = "  " },
       }))
end)

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
        key = 'e',
        mods = 'CMD',
        action = act.QuickSelectArgs {
            label = 'open url',
            patterns = { 'https?://\\S+' },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.open_with(url)
            end) }
    },

    -- workspaces
    {
        key = 'u',
        mods = 'CMD|SHIFT',
        action = act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        }
    },
    {
        key = 'u',
        mods = 'CMD|CTRL',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:perform_action(
                    act.SwitchToWorkspace {
                        name = line,
                    },
                    pane
                    )
                end
            end),
        },
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
