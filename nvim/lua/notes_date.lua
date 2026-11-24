-- Date helpers and an org-mode style date parser (modelled on org-read-date-analyze).
-- Dates are plain tables: { year = 2026, month = 11, day = 23 }.
local M = {}

local MONTHS = { "january", "february", "march", "april", "may", "june", "july",
    "august", "september", "october", "november", "december" }
local WEEKDAYS = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }

local function stamp(y, m, d)
    return os.time({ year = y, month = m, day = d, hour = 12 })
end

--- Build a date, normalizing overflow (month 13, day 0, ...).
function M.make(y, m, d)
    local t = os.date("*t", stamp(y, m, d))
    return { year = t.year, month = t.month, day = t.day }
end

function M.today()
    local t = os.date("*t")
    return { year = t.year, month = t.month, day = t.day }
end

function M.days_in_month(y, m)
    return os.date("*t", stamp(y, m + 1, 0)).day
end

--- Like make(), but nil if the day doesn't exist (e.g. 2026-02-30).
function M.valid(y, m, d)
    if not (y and m and d) or m < 1 or m > 12 or d < 1 or d > M.days_in_month(y, m) then
        return nil
    end
    return { year = y, month = m, day = d }
end

function M.add_days(date, n)
    return M.make(date.year, date.month, date.day + n)
end

--- Add months, clamping the day (Jan 31 + 1m = Feb 28).
function M.add_months(date, n)
    local first = M.make(date.year, date.month + n, 1)
    return M.make(first.year, first.month, math.min(date.day, M.days_in_month(first.year, first.month)))
end

--- ISO weekday: Monday = 1 ... Sunday = 7.
function M.weekday(date)
    return (os.date("*t", stamp(date.year, date.month, date.day)).wday + 5) % 7 + 1
end

function M.ordinal(date)
    return date.year * 10000 + date.month * 100 + date.day
end

function M.equal(a, b)
    return a and b and M.ordinal(a) == M.ordinal(b)
end

--- Whole days from a to b (positive if b is later).
function M.days_between(a, b)
    return math.floor((stamp(b.year, b.month, b.day) - stamp(a.year, a.month, a.day)) / 86400 + 0.5)
end

function M.format(date, fmt)
    return os.date(fmt or "%Y-%m-%d", stamp(date.year, date.month, date.day))
end

--- Date of ISO week `week` of `year`, weekday 1-7 (Mon-Sun).
function M.iso_week(year, week, wday)
    local jan4 = { year = year, month = 1, day = 4 }
    local monday = M.add_days(jan4, 1 - M.weekday(jan4))
    return M.add_days(monday, (week - 1) * 7 + (wday - 1))
end

local function lookup(names, word)
    if not word or #word < 3 then
        return nil
    end
    for i, name in ipairs(names) do
        if name:sub(1, #word) == word then
            return i
        end
    end
end

local function month_of(word) return lookup(MONTHS, word) end
local function weekday_of(word) return lookup(WEEKDAYS, word) end

--- Two-digit years mean 20xx.
local function full_year(y)
    y = tonumber(y)
    return y < 100 and 2000 + y or y
end

-- org-read-date-prefer-future: a date without a year is pushed to next year if
-- already past; a bare day of month is pushed to next month if already past.
local function future_year(today, m, d)
    local y = today.year
    if m < today.month or (m == today.month and d < today.day) then
        y = y + 1
    end
    return M.valid(y, m, d)
end

local function future_month(today, d)
    local m, y = today.month, today.year
    if d < today.day then
        m = m + 1
        if m > 12 then m, y = 1, y + 1 end
    end
    return M.valid(y, m, d)
end

--- Relative dates as in org-read-date-get-relative:
--- [+-]{0,2} N? (d|w|m|y|h|weekday); needs a sign or a weekday. "++"/"--" count from `default`.
local function relative(s, today, default)
    local sign, num, unit = s:match("^([+-]?[+-]?)(%d*)(%a*)$")
    if not sign then
        return nil
    end
    local wday = weekday_of(unit)
    if sign == "" and not wday then
        -- extension (not in org): bare "3d", "2w", "1m", "1y" mean "+3d" etc.
        if num ~= "" and unit:match("^[dwmy]$") then
            sign = "+"
        else
            return nil
        end
    end
    if unit ~= "" and not wday and not unit:match("^[dwmyh]$") then
        return nil
    end
    local base = #sign == 2 and default or today
    local dir = sign:sub(-1) == "-" and -1 or 1
    local n = tonumber(num) or 1
    if wday then
        local delta = (wday - M.weekday(base)) % 7
        if delta == 0 then delta = 7 end
        if dir < 0 then
            delta = delta - 7
            if delta == 0 then delta = -7 end
        end
        return M.add_days(base, delta + (n - 1) * 7 * dir)
    end
    if unit == "" or unit == "d" then return M.add_days(base, dir * n) end
    if unit == "w" then return M.add_days(base, dir * n * 7) end
    if unit == "m" then return M.add_months(base, dir * n) end
    if unit == "y" then return M.add_months(base, dir * n * 12) end
    return base -- "h": hours don't change the date
end

--- Parse org-style date input.
--- Returns a date table, false for "none"/"clear" (remove the date), or nil if it can't be parsed.
---
---   .  / today        today                 +3 / +3d / -2w / +1m   relative to today
---   fri / +2tue       next Friday / 2nd Tuesday from today      ++3  relative to the default date
---   14                the 14th (this month, or next if past)
---   sep 15 / 15 sep   (this year, or next if past)            sep 15 2027 / sep 12 9 (2009)
---   2026-12-24 / 12-24 / 12/24 / 12/24/27 / 24.12. / 24.12.2026
---   w4 / w4 fri / 2027 w4 fri / 2027-w04-5
---   extensions: tomorrow / tom / yesterday, bare 3d / 2w
function M.parse(input, default)
    local today = M.today()
    default = default or today
    local s = vim.trim(input or ""):lower()
    -- times of day are irrelevant for ⏳ dates
    s = s:gsub("%f[%d]%d%d?:%d%d[ap]?m?", ""):gsub("%f[%d]%d%d?[ap]m%f[%A]", "")
    s = vim.trim((s:gsub("[,%s]+", " ")))

    if s == "" then return default end
    if s == "none" or s == "clear" then return false end
    if s == "." or s == "today" then return today end
    if s == "tomorrow" or s == "tom" then return M.add_days(today, 1) end
    if s == "yesterday" then return M.add_days(today, -1) end

    local rel = relative(s, today, default)
    if rel then
        return rel
    end

    -- ISO week: w4, w4 fri, 2027 w4 fri, 2027-w04-5
    local wy, wk, rest = s:match("^(%d%d%d%d)[%s%-]?w(%d%d?)(.*)$")
    if not wk then
        wk, rest = s:match("^w(%d%d?)(.*)$")
    end
    if wk then
        wk = tonumber(wk)
        rest = vim.trim(rest)
        local wday = 1
        if rest ~= "" then
            local digit = rest:match("^%-(%d)$")
            wday = digit and tonumber(digit) or weekday_of(rest)
            if wday == 0 then wday = 7 end -- org: 0 = Sunday
        end
        if not wday or wday > 7 or wk < 1 or wk > 53 then
            return nil
        end
        return M.iso_week(wy and tonumber(wy) or today.year, wk, wday)
    end

    local a, b, c
    -- ISO: 2026-12-24, 26-12-24, 12-24
    a, b, c = s:match("^(%d+)%-(%d%d?)%-(%d%d?)$")
    if a then return M.valid(full_year(a), tonumber(b), tonumber(c)) end
    a, b = s:match("^(%d%d?)%-(%d%d?)$")
    if a then return future_year(today, tonumber(a), tonumber(b)) end
    -- American: 12/24, 12/24/27
    a, b, c = s:match("^(%d%d?)/(%d%d?)/(%d+)$")
    if a then return M.valid(full_year(c), tonumber(a), tonumber(b)) end
    a, b = s:match("^(%d%d?)/(%d%d?)$")
    if a then return future_year(today, tonumber(a), tonumber(b)) end
    -- European: 24.12. / 24.12.2026
    a, b, c = s:match("^(%d%d?)%. ?(%d%d?)%. ?(%d%d%d%d)$")
    if a then return M.valid(tonumber(c), tonumber(b), tonumber(a)) end
    a, b = s:match("^(%d%d?)%. ?(%d%d?)%.?$")
    if a then return future_year(today, tonumber(b), tonumber(a)) end
    -- Day of month: 14
    a = s:match("^(%d%d?)$")
    if a then return future_month(today, tonumber(a)) end

    -- Words: sep 15, 15 sep, sep 15 2027, sep 12 9, sep, 2027
    local month, nums = nil, {}
    for word in s:gmatch("%S+") do
        local n = word:match("^(%d+)$") or word:match("^(%d%d?)[snrt][tdh]$") -- 15th, 1st, 2nd, 3rd
        if n then
            table.insert(nums, tonumber(n))
        elseif not month and month_of(word) then
            month = month_of(word)
        else
            return nil
        end
    end
    local day, year
    for _, n in ipairs(nums) do
        if not day and not year and n >= 1 and n <= 31 and month then
            day = n
        elseif not year then
            year = full_year(n)
        else
            return nil
        end
    end
    if not month and not year then
        return nil
    end
    month = month or default.month
    day = day or math.min(default.day, M.days_in_month(year or today.year, month))
    if year then
        return M.valid(year, month, day)
    end
    return future_year(today, month, day)
end

return M
