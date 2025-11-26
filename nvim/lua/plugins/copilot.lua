return {
    "zbirenbaum/copilot.lua",
    dependencies = {
        "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    opts = {
        suggestion = {
            enabled = true,
            auto_trigger = true,
            hide_during_completion = true,
            debounce = 75,
            trigger_on_accept = true,
            keymap = {
                accept = "<M-j>",
                accept_word = false,
                accept_line = "<TAB>",
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-x>",
            },
        },
        nes = {
            enabled = false,
            keymap = {
                accept_and_goto = "<M-p>",
                accept = false,
                dismiss = "<ESC>",
            },
        },
    },
}
