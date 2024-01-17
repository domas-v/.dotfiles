function borderless_telescope(hl, c)
    local prompt = "#2d3149"
    hl.TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
        bg = c.bg_dark,
        fg = c.bg_dark,
    }
    hl.TelescopePromptNormal = {
        bg = prompt,
    }
    hl.TelescopePromptBorder = {
        bg = prompt,
        fg = prompt,
    }
    hl.TelescopePromptTitle = {
        bg = prompt,
        fg = prompt,
    }
    hl.TelescopePreviewTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
    }
    hl.TelescopeResultsTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
    }
end

return {
    -- {
    --      "catppuccin/nvim",
    --      name = "catppuccin",
    --      opts = { transparent_background = true }
    -- },
    {
        'projekt0n/github-nvim-theme',
        opt = {
            transparent = true,
            on_highlights = borderless_telescope
        }
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            styles = {
                comments = { italic = true, },
                keywords = { italic = true, bold = true },
                functions = { italic = true },
            },
            on_highlights = borderless_telescope,
        }
    }

}
