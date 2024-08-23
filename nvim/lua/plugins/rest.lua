return {
    {
        'mistweaverco/kulala.nvim',
        opts = {},
        keys = {
            { "<leader>kk", "<cmd>lua require('kulala').run()<cr>" },
            { "<leader>kr", "<cmd>lua require('kulala').replay()<cr>" },
            { "<leader>ka", "<cmd>lua require('kulala').run_all()<cr>" },
            { "<leader>ki", "<cmd>lua require('kulala').inspect()<cr>" },
            { "<leader>ks", "<cmd>lua require('kulala').scratchpad()<cr>" },
            { "<leader>kc", "<cmd>lua require('kulala').copy()<cr>" },
            { "<leader>kx", "<cmd>lua require('kulala').close()<cr>" },
            { "<leader>kv", "<cmd>lua require('kulala').toggle_view()<cr>" },
            { "<leader>kf", "<cmd>lua require('kulala').search()<cr>" },
            { "<leader>kn", "<cmd>lua require('kulala').jump_next()<cr>" },
            { "<leader>kp", "<cmd>lua require('kulala').jump_prev()<cr>" },
        }
    }
}
