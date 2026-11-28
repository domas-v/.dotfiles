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
-- ctrl-opt-q opens a prompt; Enter files the text as a task, `- [ ] text`,
-- at the end of the notes vault's inbox.md (the one Neovim's <leader>ni and
-- :Agenda read, see nvim/lua/config/notes.lua). Text selected in the front
-- app when the key is pressed is filled in, and where it came from (the
-- browser page, the Mail message, the open file) goes on an indented line
-- below the task as a link. The prompt's second row files it without the
-- link. URLs in the text become markdown links named after the page.

local inboxFile = (function()
  local vault = os.getenv("NOTES_VAULT")
  if not vault or vault == "" then
    vault = os.getenv("HOME") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs"
  end
  return vault .. "/inbox.md"
end)()

-- A markdown link. Brackets in the title would end it early, so they become
-- parens. A destination with spaces or unbalanced parens goes in <...>.
local function mdLink(url, title)
  title = title and title:gsub("[%[%]]", {["["] = "(", ["]"] = ")"})
  if not (title and title:match("%S")) then return "<" .. url .. ">" end
  local _, opens = url:gsub("%(", "")
  local _, closes = url:gsub("%)", "")
  if url:match("%s") or opens ~= closes then url = "<" .. url .. ">" end
  return string.format("[%s](%s)", title, url)
end

-- The task goes right after the last line of the file, so it joins the list
-- there; trailing blank lines are dropped.
local function appendToInbox(text, source)
  local f = io.open(inboxFile, "r")
  local content = f and f:read("a") or ""
  if f then f:close() end
  content = content:gsub("%s+$", "")
  local entry = "- [ ] " .. text .. "\n"
  if source and source.url then
    entry = entry .. "    - " .. mdLink(source.url, source.title) .. "\n"
  end
  content = (content == "" and "" or content .. "\n") .. entry

  -- Written next to the file and moved over it, so a failed write can't
  -- leave the inbox half written.
  local tmp = inboxFile .. ".capture"
  f = io.open(tmp, "w")
  local ok = f and f:write(content) and f:close()
  if not (ok and os.rename(tmp, inboxFile)) then
    os.remove(tmp)
    hs.alert.show("⚠️ Inbox capture failed: can't write inbox.md")
    return false
  end
  return true
end

-- Bare URLs in the note become markdown links named after the page's
-- <title>, fetched when Enter is pressed. A page that hasn't answered within
-- a few seconds, or has no title, becomes <url>. Links already in the text,
-- [title](url), <url> or [[wikilink]], are left alone.

local userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " ..
  "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
local linkifyTimers = {} -- kept here so they aren't garbage-collected

local function decodeEntities(s)
  local named = {amp = "&", lt = "<", gt = ">", quot = '"', apos = "'", nbsp = " "}
  local function char(n) return n and n <= 0x10FFFF and utf8.char(n) or nil end
  s = s:gsub("&#[xX](%x+);", function(h) return char(tonumber(h, 16)) end)
  s = s:gsub("&#(%d+);", function(d) return char(tonumber(d)) end)
  return (s:gsub("&(%a+);", function(n) return named[n] end))
end

local function pageTitle(body)
  local t = body and body:match("<[Tt][Ii][Tt][Ll][Ee][^>]*>(.-)</[Tt][Ii][Tt][Ll][Ee]>")
  if not t then return nil end
  t = decodeEntities(t):gsub("%s+", " "):match("^%s*(.-)%s*$")
  return t ~= "" and t or nil
end

-- Trailing punctuation belongs to the sentence, not the URL; a closing
-- paren only to the URL when it opened one, as in Wikipedia's Foo_(bar).
local function trimUrl(url)
  while true do
    local t = url:gsub("[%.,;:!%?'\"]+$", "")
    local _, opens = t:gsub("%(", "")
    local _, closes = t:gsub("%)", "")
    if closes > opens and t:sub(-1) == ")" then t = t:sub(1, -2) end
    if t == url then return url end
    url = t
  end
end

local function linkifyText(text, source, done)
  local protected = {} -- spans of links already in the text
  for _, pattern in ipairs({"()%[[^%]]*%]%b()()", "()<[^>%s]+>()", "()%[%[.-%]%]()"}) do
    for a, b in text:gmatch(pattern) do protected[#protected + 1] = {a, b - 1} end
  end
  local found, pos = {}, 1
  while true do
    local a, b = text:find("https?://[^%s<>\"%[%]]+", pos)
    if not a then break end
    local url = trimUrl(text:sub(a, b))
    local inside = false
    for _, r in ipairs(protected) do
      if a >= r[1] and a <= r[2] then inside = true; break end
    end
    if not inside then found[#found + 1] = {a = a, b = a + #url - 1, url = url} end
    pos = b + 1
  end
  if #found == 0 then return done(text) end

  local titles, requested, pending, finished, timer = {}, {}, 0, false, nil
  local function finish()
    if finished then return end
    finished = true
    if timer then timer:stop(); linkifyTimers[timer] = nil end
    local out, last = {}, 1
    for _, f in ipairs(found) do
      out[#out + 1] = text:sub(last, f.a - 1)
      out[#out + 1] = mdLink(f.url, titles[f.url])
      last = f.b + 1
    end
    out[#out + 1] = text:sub(last)
    done(table.concat(out))
  end

  for _, f in ipairs(found) do
    local url = f.url
    if not requested[url] then
      requested[url] = true
      if source and source.url == url and source.title then
        titles[url] = source.title -- the page it was captured from
      else
        pending = pending + 1
        hs.http.asyncGet(url, {["User-Agent"] = userAgent}, function(status, body)
          if status >= 200 and status < 300 then titles[url] = pageTitle(body) end
          pending = pending - 1
          if pending == 0 then finish() end
        end)
      end
    end
  end
  if pending == 0 then return finish() end
  timer = hs.timer.doAfter(5, finish)
  linkifyTimers[timer] = true
end

local function captureToInbox(text, source)
  source = source or {}
  linkifyText(text, source, function(task)
    if appendToInbox(task, source) then
      hs.alert.show("📥 " .. text .. (source.url and "  🔗" or ""))
    end
  end)
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
    if hs.fs.attributes(urlDecode(path), "mode") ~= "file" then return nil end
    return url, title -- still percent-encoded, so it works as a link target
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
  -- One-line prompt and the note becomes a one-line task: flatten line breaks.
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
