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
        {
            base_path = "C:/Dev/voxel",
            dotnet_proj_file = "C:/Dev/voxel/Voxel.sln",
            dotnet_dll_path = "C:/Dev/voxel/bin/Debug-windows-x86_64/Sandbox/Voxel-Sandbox.exe",
            dotnet_debug_cwd = "C:/Dev/voxel/Sandbox", -- Useful for large, multi-project debugging
        },
    },
})

vim.g.copilot_assume_mapped = true

vim.g.undotree_DiffCommand = "FC"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
