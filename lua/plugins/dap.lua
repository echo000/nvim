return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- fancy UI for the debugger
            {
                "rcarriga/nvim-dap-ui",
                event = "VeryLazy",
                dependencies = { "nvim-neotest/nvim-nio" },
                keys = {
                    {
                        "<leader>du",
                        function()
                            require("dapui").toggle({})
                        end,
                        desc = "Dap UI",
                    },
                    {
                        "<leader>de",
                        function()
                            require("dapui").eval()
                        end,
                        desc = "Eval",
                        mode = { "n", "v" },
                    },
                },
                config = function()
                    local status, dap = pcall(require, "dap")
                    if not status then
                        print("dap not loaded")
                        return
                    end
                    local dap_status, dapui = pcall(require, "dapui")
                    if not dap_status then
                        print("dapui not loaded")
                        return
                    end
                    local status_ui, dap_ui = pcall(require, "dapui")
                    if not status_ui then
                        print("dapui not loaded")
                        return
                    end
                    dap_ui.setup({
                        controls = {
                            element = "repl",
                            enabled = true,
                            icons = {
                                disconnect = "",
                                pause = "",
                                play = "",
                                run_last = "",
                                step_back = "",
                                step_into = "",
                                step_out = "",
                                step_over = "",
                                terminate = "",
                            },
                        },
                        element_mappings = {},
                        expand_lines = true,
                        floating = {
                            border = "single",
                            mappings = {
                                close = { "q", "<Esc>" },
                            },
                        },
                        force_buffers = true,
                        icons = {
                            collapsed = "",
                            current_frame = "",
                            expanded = "",
                        },
                        layouts = {
                            {
                                elements = {
                                    {
                                        id = "console",
                                        size = 0.2,
                                    },
                                    {
                                        id = "breakpoints",
                                        size = 0.2,
                                    },
                                    {
                                        id = "stacks",
                                        size = 0.2,
                                    },
                                    {
                                        id = "repl",
                                        size = 0.2,
                                    },
                                    {
                                        id = "watches",
                                        size = 0.2,
                                    },
                                },
                                position = "left",
                                size = 50,
                            },
                            {
                                elements = {
                                    {
                                        id = "scopes",
                                        size = 1,
                                    },
                                },
                                position = "bottom",
                                size = 10,
                            },
                        },
                        mappings = {
                            edit = "e",
                            expand = { "<CR>", "<2-LeftMouse>" },
                            open = "o",
                            remove = "d",
                            repl = "r",
                            toggle = "t",
                        },
                        render = {
                            indent = 1,
                            max_value_lines = 100,
                        },
                    })

                    ------------
                    -- Dap UI --
                    ------------

                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open()
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close()
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close()
                    end

                    vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
                    vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
                end,
            },
            {
                "jay-babu/mason-nvim-dap.nvim",
                event = "VeryLazy",
                dependencies = {
                    "williamboman/mason.nvim",
                    "mfussenegger/nvim-dap",
                },
                opts = {
                    handlers = {},
                },
            },
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },

            -- which key integration
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>d"] = { name = "+debug" },
                    },
                },
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<leader>dj", function() require("dap").down() end, desc = "Down" },
            { "<leader>dk", function() require("dap").up() end, desc = "Up" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
            { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<leader>ds", function() require("dap").session() end, desc = "Session" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
        },
        config = function(_, _)
            local status, dap = pcall(require, "dap")
            if not status then
                print("dap not loaded")
                return
            end
            local ph_status, dotnet_ph = pcall(require, "utilities.path_finder")
            if not ph_status then
                print("path_finder not loaded")
                return
            end

            local mason_registry = require("mason-registry")
            local codelldb_root = mason_registry.get_package("codelldb"):get_install_path()
                .. "/extension/adapter/codelldb"

            -- used by nvim-dap
            dap.adapters.coreclr = {
                type = "executable",
                command = vim.fs.normalize(vim.fn.stdpath("data") .. "/netcoredbg/netcoredbg.exe"),
                args = { "--interpreter=vscode" },
                options = {
                    detached = false, -- Will put the output in the REPL. #CloseEnough
                    cwd = dotnet_ph.GetDebugCwd(),
                },
            }

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_root,
                    args = {
                        "--port",
                        "${port}",
                    },
                    detached = false,
                },
            }

            -- Neotest Test runner looks at this table
            dap.adapters.netcoredbg = dap.adapters.coreclr

            -- useful for debugging issues with dap
            -- Logs are written to :lua print(vim.fn.stdpath('cache'))
            -- dap.set_log_level('DEBUG')  -- or `TRACE` for more logs

            -- Used by nvim-dap

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "launch",
                    program = dotnet_ph.GetDllPath,
                    console = "integratedTerminal",
                },
            }

            dap.configurations.cpp = {
                {
                    name = "Launch - C++",
                    type = "codelldb",
                    request = "launch",
                    program = dotnet_ph.GetDllPath2,
                    cwd = dotnet_ph.GetDebugCwd(),
                    console = "integratedTerminal",
                },
            }
        end,
    },
}
