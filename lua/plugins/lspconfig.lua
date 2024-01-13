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
        },
    },
}
