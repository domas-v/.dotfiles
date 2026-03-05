return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = { globalstatus = true, },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', },
            lualine_c = { 'filename' },
            lualine_x = { 'filetype' },
            lualine_y = { 'location' },
            lualine_z = { '' }
        }
    },
}
