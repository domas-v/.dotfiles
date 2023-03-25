return {
    {
        'nvim-lualine/lualine.nvim',
        config = function ()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    globalstatusline = true,
                    theme = 'auto',
                    component_separators = {'', ''},
                    section_separators = {'', ''},
                    disabled_filetypes = {}
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch'},
                    lualine_c = {'filename'},
                    lualine_x = {'filetype'},
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {'branch'},
                    lualine_c = {'filename'},
                    lualine_x = {'filetype'},
                    lualine_z = {'location'}
                }
            }
        end
    }
}
