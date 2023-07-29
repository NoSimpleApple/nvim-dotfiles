return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
        -- to postpone autopairs' loading and enable the compat for coc
        "neoclide/coc.nvim"
    },
    opts = {
        check_ts = true,
        map_c_w = true,
    },
    config = function()
        -- bracket completion compat for coc
        local remap = vim.api.nvim_set_keymap
        local npairs = require("nvim-autopairs")
        npairs.setup({ map_cr = false })

        -- skip it, if you use another global object
        _G.MUtils = {}

        MUtils.completion_confirm = function()
            if vim.fn["coc#pum#visible"]() ~= 0 then
                return vim.fn["coc#pum#confirm"]()
            else
                return npairs.autopairs_cr()
            end
        end
        remap("i", "<CR>", "v:lua.MUtils.completion_confirm()", { expr = true, noremap = true })

        -- User rules
        require("plugins.nvim-autopairs.rules")
    end,
}
