-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

require("utilities.path_finder").setup({
    projects = {
        {
            base_path = "C:/Dev/Saluki",
            dotnet_proj_file = "C:/Dev/Saluki/src/Saluki.sln",
            dotnet_dll_path = "C:/Dev/Saluki/src/Saluki/bin/x64/Debug/net7.0-windows/Saluki.dll",
            dotnet_debug_cwd = "C:/Dev/Saluki/src", -- Useful for large, multi-project debugging
        },
    },
})

vim.g.copilot_assume_mapped = true

vim.g.undotree_DiffCommand = "FC"
