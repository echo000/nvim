return {
    -- disable dashboard
    { "nvimdev/dashboard-nvim", enabled = false },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
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
        "iabdelkareem/csharp.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "Tastyep/structlog.nvim",
        },
        config = function()
            -- Roslyn LSP Specific Prerequisites
            -- local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
            -- -- Construct the path based on the OS
            -- local roslyn_lsp_path
            -- if is_windows then
            --     local localappdata = os.getenv("LOCALAPPDATA")
            --     roslyn_lsp_path = localappdata .. "\\csharp\\Microsoft.CodeAnalysis.LanguageServer.dll"
            -- else
            --     local xdg_config_home = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"
            --     roslyn_lsp_path = xdg_config_home .. "/csharp/Microsoft.CodeAnalysis.LanguageServer.dll"
            -- end
            require("mason").setup() -- Mason setup must run before csharp, only if you want to use omnisharp
            require("csharp").setup({
                logging = {
                    level = "TRACE",
                },
                lsp = {
                    -- roslyn = {
                    --     -- When set to true, csharp.nvim will launch roslyn automatically.
                    --     enable = true,
                    --     -- Path to the roslyn LSP see 'Roslyn LSP Specific Prerequisites' above.
                    --     cmd_path = roslyn_lsp_path,
                    -- },
                    omnisharp = {
                        enable = true,
                    },
                },
                -- dap = {
                --     adapter_name = nil,
                -- },
            })
        end,
    },
}
