return {
    -- disable dashboard
    { "nvimdev/dashboard-nvim", enabled = false },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "omnisharp",
                "clangd",
                "clang-format",
                "codelldb",
            },
        },
    },
    {
        "mbbill/undotree",
        lazy = false,
        init = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "tikhomirov/vim-glsl",
    },
    {
        "echo000/csharp.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim", -- Required, automatically installs omnisharp
            "mfussenegger/nvim-dap",
            "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
        },
        config = function()
            require("mason").setup() -- Mason setup must run before csharp
            require("csharp").setup({
                logging = {
                    -- The minimum log level.
                    level = "TRACE",
                },
            })
        end,
    },
}
