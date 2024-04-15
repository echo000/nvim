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
        "tikhomirov/vim-glsl",
    },
}
