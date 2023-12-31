return {
    'hrsh7th/nvim-cmp',
    enabled = false,
    cond = not vim.g.vscode,
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'felipelema/cmp-async-path',
        'hrsh7th/cmp-cmdline',
        {
            'uga-rosa/cmp-dictionary',
            config = function()
                local dict = require("cmp_dictionary")

                dict.setup({
                    -- the following are default values.
                    exact = 2,
                    first_case_insensitive = false,
                    document = false,
                    document_command = "wn %s -over",
                    async = true,
                    sqlite = false,
                    max_items = -1,
                    capacity = 5,
                    debug = false,
                })

                dict.switcher({})
            end,
        },
        {
            'quangnguyen30192/cmp-nvim-ultisnips',
            dependencies = {
                {
                    'sirver/ultisnips',
                    enabled = false,
                    config = function()
                        vim.g.ultisnipsexpandtrigger = '<plug>(ultisnips_expand)'
                        vim.g.ultisnipsjumpforwardtrigger = '<plug>(ultisnips_jump_forward)'
                        vim.g.ultisnipsjumpbackwardtrigger = '<plug>(ultisnips_jump_backward)'
                        vim.g.ultisnipslistsnippets = '<c-x><c-s>'
                        vim.g.ultisnipsremoveselectmodemappings = 0
                    end,
                },
            }
        },
        {
            'saadparwaiz1/cmp_luasnip',
            dependencies = {
                {
                    'l3mon4d3/luasnip',
                    dependencies = {
                        "rafamadriz/friendly-snippets",
                    }
                },
            }
        },
    },

    config = function()
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        require("luasnip.loaders.from_vscode").lazy_load()
        local luasnip = require("luasnip")
        local cmp = require 'cmp'
        cmp.setup {
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            sources = cmp.config.sources {
                { name = 'nvim_lsp', keyword_length = 6, group_index = 1, max_item_count = 30},
                { name = 'luasnip', max_item_count = 5},
                { name = 'path', max_item_count = 8},
                { name = "buffer", max_item_count = 5},
            },
            mapping = cmp.mapping.preset.insert {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- they way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            },
            experimental = {
                ghost_text = true,
            }
        }

        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' },
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'cmdline' }
            })
        })
    end,
}
