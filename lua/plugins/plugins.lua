return {
    -- disable dashboard
    { "nvimdev/dashboard-nvim", enabled = false },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "rust-analyzer",
                "omnisharp",
                "clangd",
                "clang-format",
                "codelldb",
            },
        },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                cs = { "csharpier" },
            },
            formatters = {
                csharpier = {
                    command = "dotnet-csharpier",
                    args = { "--write-stdout" },
                },
            },
        },
    },
    {
        "telescope.nvim",
        dependencies = {
            -- project management
            {
                "ahmedkhalf/project.nvim",
                opts = {
                    manual_mode = true,
                },
                -- All the patterns used to detect root dir, when **"pattern"** is in
                -- detection_methods
                patterns = { ".sln" },
                event = "VeryLazy",
                config = function(_, opts)
                    require("project_nvim").setup(opts)
                    require("lazyvim.util").on_load("telescope.nvim", function()
                        require("telescope").load_extension("projects")
                    end)
                end,
                keys = {
                    { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
                },
            },
        },
    },
    {
        -- Code actions in telescope
        "aznhe21/actions-preview.nvim",
        config = function() end,
        event = "VeryLazy",
    },
    {
        -- Show all todo comments in solution
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup({})
        end,
        event = "VeryLazy",
    },
    {
        "mbbill/undotree",
        lazy = false,
        init = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },
    {
        "nvim-cmp",
        dependencies = {
            {
                "zbirenbaum/copilot-cmp",
                dependencies = "copilot.lua",
                opts = {},
                config = function(_, opts)
                    local copilot_cmp = require("copilot_cmp")
                    copilot_cmp.setup(opts)
                    -- attach cmp source whenever copilot attaches
                    -- fixes lazy-loading issues with the copilot cmp source
                    require("lazyvim.util").lsp.on_attach(function(client)
                        if client.name == "copilot" then
                            copilot_cmp._on_insert_enter({})
                        end
                    end)
                end,
            },
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            table.insert(opts.sources, 1, {
                name = "copilot",
                group_index = 1,
                priority = 100,
            })
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")
            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- this way you will only jump inside the snippet region
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
            })
        end,
    },
    -- {
    --     "github/copilot.vim",
    --     lazy = false,
    --     config = function (_,_)
    --         require("core.utils").load_mappings("copilot")
    --     end
    -- },
    {
        "Bekaboo/dropbar.nvim",
        -- optional, but required for fuzzy finder support
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        init = function()
            require("dropbar").setup()
        end,
    },
    {
        -- Show errors in the solution
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("trouble").setup({})
            vim.keymap.set("n", "<leader>ww", function()
                require("trouble").open("workspace_diagnostics")
            end)
        end,
    },
}
