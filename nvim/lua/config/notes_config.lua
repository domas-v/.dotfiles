local M = {}

M.notes_path = "~/Desktop/Notes/"
M.daily_notes_path = M.notes_path .. "daily/"
M.priority = {
    tags = { "#important", "#later" },
    hls = {
        "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo",
        "DiagnosticHint", "DiagnosticOk",
    }
}
M.tags = { "#current", "#idea" }
M.categories = { "@work", "@nvim", "@personal" }
M.checkboxes = {
    { "- [ ]", "- [-]", "- [x]", },
    { "+ [ ]", "+ [-]", "+ [x]", }
}

M.presets = {
    due = {
        heading = "# 📅 Due",
        match = "unchecked",
        date_match = "selected",
        group_by = nil,
        sort = "priority",
    },
    overdue = {
        heading = "# ⚠️ Overdue",
        match = "unchecked",
        date_match = "before_selected",
        group_by = nil,
        sort = "priority",
    },
    todo = {
        heading = "# 📋 Todo",
        match = "open",
        date_match = nil,
        group_by = "date",
        sort = "priority",
    },
    important = {
        heading = "# 🔥 Important",
        match = "unchecked",
        date_match = nil,
        text_match = "#important",
        group_by = nil,
        sort = "priority",
    },
    in_progress = {
        heading = "# 🔄 In Progress",
        match = "in_progress",
        date_match = nil,
        group_by = nil,
        sort = "priority",
    },
    done = {
        heading = "# ✅ Done",
        match = "checked",
        date_match = nil,
        group_by = "date",
        sort = "date_desc",
    },
    week = {
        heading = nil,
        match = "all",
        date_match = "current_week",
        group_by = "weekday",
        sort = "priority",
    },
}

M.views = {
    day = {
        panes = { "due", "todo" },
    },
    week = {
        panes = { "week", "todo" },
    },
    done = {
        panes = { "done" },
    },
}

return M
