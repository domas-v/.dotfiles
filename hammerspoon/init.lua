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
-- Text selected in the front app when the key is pressed is filled in, and
-- where it came from (the browser page, the Mail message, the open file)
-- goes below the heading as a link. The prompt's second row files it
-- without the link.
-- With Emacs running it goes through `dom/org-capture-from-hammerspoon'
-- (~/.emacs.d/config/dom-org.el), which also saves the file for beorg.
-- Without Emacs, the entry is appended to the file directly.

local emacsclient = "/opt/homebrew/bin/emacsclient"
local inboxFile = os.getenv("HOME") ..
  "/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/inbox.org"

local function elispString(s)
  if s == nil or s == "" then return "nil" end
  return '"' .. (s:gsub('\\', '\\\\'):gsub('"', '\\"')) .. '"'
end

local function orgLink(source)
  if not (source and source.url) then return nil end
  local title = source.title and source.title:gsub("[%[%]]", {["["] = "(", ["]"] = ")"})
  if title and title:match("%S") then
    return string.format("[[%s][%s]]", source.url, title)
  end
  return string.format("[[%s]]", source.url)
end

local function appendToInbox(text, source)
  local f = io.open(inboxFile, "a")
  if not f then
    hs.alert.show("⚠️ Inbox capture failed: can't open inbox.org")
    return false
  end
  local link = orgLink(source)
  f:write(string.format("* TODO %s\n:PROPERTIES:\n:CREATED:  %s\n:END:\n%s",
    text, os.date("[%Y-%m-%d %a %H:%M]"), link and (link .. "\n") or ""))
  f:close()
  return true
end

local function captureToInbox(text, source)
  source = source or {}
  local elisp = string.format("(dom/org-capture-from-hammerspoon %s %s %s)",
    elispString(text), elispString(source.url), elispString(source.title))
  hs.task.new(emacsclient, function(code)
    if code == 0 or appendToInbox(text, source) then
      hs.alert.show("📥 " .. text .. (source.url and "  🔗" or ""))
    end
  end, {"-e", elisp}):start()
end

-- Where the capture comes from ---------------------------------------------

-- Page URL and title, or a Mail message link and subject, asked for with
-- AppleScript. The first time, macOS asks to let Hammerspoon control the app.
local function chromiumScript(app)
  return 'tell application "' .. app .. '" to tell active tab of front window' ..
    ' to return URL & linefeed & title'
end
local sourceScripts = {
  ["Brave Browser"] = chromiumScript("Brave Browser"),
  ["Google Chrome"] = chromiumScript("Google Chrome"),
  ["Arc"] = chromiumScript("Arc"),
  ["Safari"] = 'tell application "Safari" to tell front document' ..
    ' to return URL & linefeed & name',
  ["Mail"] = 'tell application "Mail"\n' ..
    'set m to item 1 of (get selection)\n' ..
    'return "message://%3C" & message id of m & "%3E" & linefeed & subject of m\n' ..
    'end tell',
}

local function urlDecode(s)
  return (s:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

-- The focused window's document: the page in a browser, the open file in
-- Preview, TextEdit, Xcode... Folders (a terminal's working directory) don't
-- count.
local function windowDocument(app)
  local ok, url, title = pcall(function()
    local ax = hs.axuielement.applicationElement(app)
    ax:setTimeout(0.2)
    local win = ax:attributeValue("AXFocusedWindow")
    local doc = win and win:attributeValue("AXDocument")
    if type(doc) == "table" then doc = doc.url end
    return doc, win and win:attributeValue("AXTitle")
  end)
  if not (ok and type(url) == "string" and url ~= "") then return nil end
  local path = url:match("^file://(.*)")
  if path then
    path = urlDecode(path)
    if hs.fs.attributes(path, "mode") ~= "file" then return nil end
    return "file:" .. path, title
  end
  return url
end

-- Filled in now from the window; the AppleScript answer (title, Mail link)
-- lands later, before Enter is pressed in practice. onUpdate runs then.
local function frontSource(onUpdate)
  local source = {}
  local app = hs.application.frontmostApplication()
  if not app then return source end
  local name = app:name()
  source.url, source.title = windowDocument(app)
  if sourceScripts[name] then
    source.title = nil -- a browser's window title isn't the page's
    source.task = hs.task.new("/usr/bin/osascript", function(code, out)
      source.task = nil
      local url, title = (out or ""):match("^(.-)\n(.-)\n?$")
      if code == 0 and url and url ~= "" then
        source.url, source.title = url, title
        onUpdate()
      end
    end, {"-e", sourceScripts[name]})
    source.task:start()
  end
  return source
end

-- The prompt ------------------------------------------------------------------

local inboxChooser
local currentSource -- where the open prompt's capture comes from

local function setInboxChoices(q)
  if not q:match("%S") then return inboxChooser:choices({}) end
  local source = currentSource or {}
  if not source.url then return inboxChooser:choices({{text = q}}) end
  inboxChooser:choices({
    {text = q, subText = "🔗 " .. (source.title or source.url), withSource = true},
    {text = q, subText = "Without the link"},
  })
end

inboxChooser = hs.chooser.new(function(choice)
  local source = currentSource
  if source and source.task then source.task:terminate() end
  currentSource = nil
  if choice then captureToInbox(choice.text, choice.withSource and source or nil) end
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
  local source
  source = frontSource(function()
    if currentSource == source and inboxChooser:isVisible() then
      setInboxChoices(inboxChooser:query())
    end
  end)
  currentSource = source
  local text = selectedTextAX()
  if text then
    showInboxPrompt(text)
  else
    selectedTextViaCopy(showInboxPrompt)
  end
end)
