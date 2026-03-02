return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', },
                lualine_c = { 'filename' },
                lualine_x = { 'filetype' },
                lualine_y = { 'location' },
                lualine_z = { '' }
            },
            component_separators = { left = require("config.icons").arrows.left_solid, right = require("config.icons").arrows.right_solid },
            section_separators = { left = require("config.icons").arrows.left_solid, right = require("config.icons").arrows.right_solid },
        },
    }
}
