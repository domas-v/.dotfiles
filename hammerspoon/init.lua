require("hs.ipc")  -- lets the `hs` command-line tool talk to Hammerspoon

-- Focus the frontmost window on another monitor and move the mouse there.
local function focusScreen(screen)
  -- orderedWindows() is front-to-back, so the first match is the topmost
  -- window on that screen. Skip popups, panels and other non-standard windows.
  local win = hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return w:screen() == screen and w:isStandard() and w:isVisible()
  end)
  -- focus() makes this window the app's main window before activating the
  -- app, so only this window comes forward. Activating the app first would
  -- also raise whichever of its windows was main before, even on another
  -- monitor.
  if win then win:focus() end
  hs.mouse.absolutePosition(screen:frame().center)
end

-- opt-[ / ] : focus the previous / next monitor
hs.hotkey.bind({"alt"}, "[", function()
  focusScreen(hs.mouse.getCurrentScreen():previous())
end)

hs.hotkey.bind({"alt"}, "]", function()
  focusScreen(hs.mouse.getCurrentScreen():next())
end)
