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

-- Inbox capture from anywhere --------------------------------------------
-- ctrl-opt-q opens a prompt; Enter files the text as a TODO in inbox.org.
-- With Emacs running it goes through the "I" capture template
-- (~/.emacs.d/config/dom-org.el), which also saves the file for beorg.
-- Without Emacs, the entry is appended to the file directly.

local emacsclient = "/opt/homebrew/bin/emacsclient"
local inboxFile = os.getenv("HOME") ..
  "/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/inbox.org"

local function elispString(s)
  return '"' .. (s:gsub('\\', '\\\\'):gsub('"', '\\"')) .. '"'
end

local function appendToInbox(text)
  local f = io.open(inboxFile, "a")
  if not f then
    hs.alert.show("⚠️ Inbox capture failed: can't open inbox.org")
    return false
  end
  f:write(string.format("* TODO %s\n:PROPERTIES:\n:CREATED:  %s\n:END:\n\n",
    text, os.date("[%Y-%m-%d %a %H:%M]")))
  f:close()
  return true
end

local function captureToInbox(text)
  local elisp = string.format(
    '(progn (org-capture-string %s "I")' ..
    ' (with-current-buffer (find-file-noselect org-default-notes-file) (save-buffer)) t)',
    elispString(text))
  hs.task.new(emacsclient, function(code)
    if code == 0 or appendToInbox(text) then hs.alert.show("📥 " .. text) end
  end, {"-e", elisp}):start()
end

local inboxChooser = hs.chooser.new(function(choice)
  if choice then captureToInbox(choice.text) end
end)
inboxChooser:placeholderText("Inbox…")
inboxChooser:queryChangedCallback(function(q)
  inboxChooser:choices(q:match("%S") and {{text = q}} or {})
end)

hs.hotkey.bind({"ctrl", "alt"}, "q", function()
  inboxChooser:query("")
  inboxChooser:show()
end)
