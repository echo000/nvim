return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                require("telescope").load_extension("fzf")
            end,
        },
        -- project management
        {
            "ahmedkhalf/project.nvim",
            opts = {
                manual_mode = true,
            },
            -- All the patterns used to detect root dir, when **"pattern"** is in
            -- detection_methods
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
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
    lazy = false,
    event = "VimEnter",
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                file_ignore_patterns = { "node_modules", "target" },
            },
        })
    end,
}
