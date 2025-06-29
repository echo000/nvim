return {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = { "rust" },
    opts = {
        server = {
            on_attach = function(_, bufnr)
                vim.keymap.set("n", "<leader>cR", function()
                    vim.cmd.RustLsp("codeAction")
                end, { desc = "Code Action", buffer = bufnr })
                vim.keymap.set("n", "<leader>dr", function()
                    vim.cmd.RustLsp("debuggables")
                end, { desc = "Rust Debuggables", buffer = bufnr })
                vim.keymap.set("n", "K", function()
                    vim.cmd.RustLsp({ "hover", "actions" })
                end, { silent = true, buffer = bufnr })
            end,
            default_settings = {
                -- rust-analyzer language server configuration
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        buildScripts = {
                            enable = true,
                        },
                    },
                    workspace = {
                        symbol = {
                            search = {
                                -- Controls which symbols are shown in `workspace_symbol`
                                kind = "all_symbols", -- "all_symbols" | "only_types" | "only_functions"
                                limit = 512, -- How many results to return
                                query = nil, -- Optional pre-filter
                                -- Optional fuzzy config (requires latest RA)
                                -- caseSensitive = false,
                                -- subString = true,
                            },
                        },
                    },
                    -- Add clippy lints for Rust.
                    checkOnSave = true,
                    procMacro = {
                        enable = true,
                        ignored = {
                            ["async-trait"] = { "async_trait" },
                            ["napi-derive"] = { "napi" },
                            ["async-recursion"] = { "async_recursion" },
                        },
                    },
                    files = {
                        excludeDirs = {
                            ".direnv",
                            ".git",
                            ".github",
                            ".gitlab",
                            "bin",
                            "node_modules",
                            "target",
                            "venv",
                            ".venv",
                        },
                    },
                },
            },
        },
    },
    config = function(_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
        if vim.fn.executable("rust-analyzer") == 0 then
            LazyVim.error(
                "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
                { title = "rustaceanvim" }
            )
        end
    end,
}
