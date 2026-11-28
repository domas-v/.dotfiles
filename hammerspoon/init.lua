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
-- Text selected in the front app when the key is pressed is filled in.
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

local inboxChooser -- created below; the prompt

local function captureToInbox(text)
  local elisp = string.format(
    '(progn (org-capture-string %s "I")' ..
    ' (with-current-buffer (find-file-noselect org-default-notes-file) (save-buffer)) t)',
    elispString(text))
  hs.task.new(emacsclient, function(code)
    if code == 0 or appendToInbox(text) then hs.alert.show("📥 " .. text) end
  end, {"-e", elisp}):start()
end

local function setInboxChoices(q)
  inboxChooser:choices(q:match("%S") and {{text = q}} or {})
end

inboxChooser = hs.chooser.new(function(choice)
  if choice then captureToInbox(choice.text) end
end)
inboxChooser:placeholderText("Inbox…")
inboxChooser:queryChangedCallback(setInboxChoices)

-- The focused app's selected text, asked for through Accessibility. Native
-- apps answer; browsers, Electron apps and terminals usually don't.
local function selectedTextAX()
  local ok, text = pcall(function()
    local system = hs.axuielement.systemWideElement()
    system:setTimeout(0.2)
    local focused = system:attributeValue("AXFocusedUIElement")
    return focused and focused:attributeValue("AXSelectedText")
  end)
  if ok and type(text) == "string" and text:match("%S") then return text end
end

-- Fallback: press cmd-c and see whether the clipboard changes. The old
-- clipboard (every format on it) is put back afterwards.
local copyTimer -- kept here so it isn't garbage-collected mid-wait
local function selectedTextViaCopy(callback)
  local saved = hs.pasteboard.readAllData()
  local before = hs.pasteboard.changeCount()
  hs.eventtap.keyStroke({"cmd"}, "c", 0)
  local tries = 0
  copyTimer = hs.timer.doEvery(0.03, function()
    tries = tries + 1
    local changed = hs.pasteboard.changeCount() ~= before
    if not changed and tries < 10 then return end
    copyTimer:stop()
    copyTimer = nil
    local text = changed and hs.pasteboard.getContents() or nil
    if changed then
      if saved and next(saved) then
        hs.pasteboard.writeAllData(saved)
      else
        hs.pasteboard.clearContents()
      end
    end
    callback(text)
  end)
end

local function showInboxPrompt(text)
  -- One-line prompt and the note becomes a heading: flatten line breaks.
  local q = text and text:gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
  inboxChooser:query(q)
  setInboxChoices(q)
  inboxChooser:show()
end

hs.hotkey.bind({"ctrl", "alt"}, "q", function()
  if inboxChooser:isVisible() then return end
  local text = selectedTextAX()
  if text then
    showInboxPrompt(text)
  else
    selectedTextViaCopy(showInboxPrompt)
  end
end)
