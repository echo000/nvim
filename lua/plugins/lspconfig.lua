return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            omnisharp = {
                handlers = {
                    ["textDocument/definition"] = function(...)
                        return require("omnisharp_extended").handler(...)
                    end,
                },
                keys = {
                    {
                        "gd",
                        function()
                            require("omnisharp_extended").telescope_lsp_definitions()
                        end,
                        desc = "Goto Definition",
                    },
                },
                analyze_open_documents_only = false,
                enable_ms_build_load_projects_on_demand = false,
                enable_roslyn_analyzers = false,
                organize_imports_on_format = true,
                enable_import_completion = true,
                sdk_include_prereleases = true,
            },
            glsl_analyzer = {
                setup = {},
            },
            clangd = {
                keys = {
                    { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                },
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(
                        "Makefile",
                        "configure.ac",
                        "configure.in",
                        "config.h.in",
                        "meson.build",
                        "meson_options.txt",
                        "build.ninja"
                    )(fname) or require("lspconfig.util").root_pattern(
                        "compile_commands.json",
                        "compile_flags.txt"
                    )(fname) or require("lspconfig.util").find_git_ancestor(fname)
                end,
                capabilities = {
                    offsetEncoding = { "utf-16" },
                },
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            },

            -- Ensure mason installs the server
            rust_analyzer = {
                keys = {
                    { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
                    { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
                    { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
                },
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        -- Add clippy lints for Rust.
                        checkOnSave = {
                            allFeatures = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                    },
                },
            },
            taplo = {
                keys = {
                    {
                        "K",
                        function()
                            if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                                require("crates").show_popup()
                            else
                                vim.lsp.buf.hover()
                            end
                        end,
                        desc = "Show Crate Documentation",
                    },
                },
            },
        },
        setup = {
            rust_analyzer = function(_, opts)
                return true
            end,
            clangd = function(_, opts)
                local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
                require("clangd_extensions").setup(
                    vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
                )
                return false
            end,
        },
    },
}
