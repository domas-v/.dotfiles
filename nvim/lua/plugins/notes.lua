return {
    {
        'toppair/peek.nvim',
        build = 'deno task --quiet build:fast',
        ft = 'markdown',
        config = function()
            require('peek').setup({
                app = 'browser',
            })

            vim.api.nvim_create_user_command('PeekToggle', function()
                if require('peek').is_open() then
                    require('peek').close()
                else
                    require('peek').open()
                end
            end, {})
        end,
    }
}
