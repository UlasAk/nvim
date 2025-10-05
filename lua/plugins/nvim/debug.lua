return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>D", "<cmd>DapNew<CR>", desc = "Debug New" },
      { "<leader>dbt", "<cmd>DapToggleBreakpoint<CR>", desc = "Debug Toggle Breakpoint" },
      {
        "<leader>dbc",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition")
        end,
        desc = "Debug Breakpoint with condition",
      },
      { "<leader>dba", "<cmd>DapClearBreakpoints<CR>", desc = "Debug Clear Breakpoints" },
      { "<leader>dc", "<cmd>DapContinue<CR>", desc = "Debug Continue" },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Debug Continue to cursor",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Debug Pause",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Debug Up",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Debug Down",
      },
      { "<leader>dso", "<cmd>DapStepOver<CR>", desc = "Debug Step Over" },
      { "<leader>dsO", "<cmd>DapStepOut<CR>", desc = "Debug Step Out" },
      { "<leader>dsi", "<cmd>DapStepIn<CR>", desc = "Debug Step In" },
      {
        "<leader>de",
        function()
          require("dap").set_exception_breakpoints()
        end,
        desc = "Debug Set exception breakpoints",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Debug Widgets hover",
      },
      { "<leader>dr", "<cmd>DapToggleRepl<CR>", desc = "Debug Toggle Repl" },
      { "<leader>dd", "<cmd>DapDisconnect<CR>", desc = "Debug Disconnect" },
      { "<leader>dt", "<cmd>DapTerminate<CR>", desc = "Debug Terminate" },
      {
        "<leader>dus",
        function()
          local widgets = require "dap.ui.widgets"
          local sidebar = widgets.sidebar(widgets.scopes)
          sidebar.open()
        end,
        desc = "Debug Open sidebar",
      },
    },
    opts = function()
      local M = {}
      local dap = require "dap"

      -- Adapters
      local dartAdapter = function()
        dap.adapters.dart = {
          type = "executable",
          command = "dart",
          args = { "debug_adapter" },
          options = {
            detached = false,
          },
        }
      end

      local flutterAdapter = function()
        dap.adapters.flutter = {
          type = "executable",
          command = "flutter",
          args = { "debug_adapter" },
          options = {
            detached = false,
          },
        }
      end

      local javascriptAdapter = function()
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = {
              "${port}",
            },
          },
          enrich_config = function(config, on_config)
            config.type = "pwa-node"
            -- TODO: fix for launching vscode launch.js configurations
            -- if config.program ~= nil and string.match(config.program, "%.ts$") then
            --   config.runtimeExecutable = "nodemon"
            --   config.args = { "--watch", "src/**/*.ts", "--exec", "npx", "ts-node", "${file}" }
            -- end
            on_config(config)
          end,
        }

        dap.adapters["node"] = dap.adapters["pwa-node"]
      end

      local chromeAdapter = function()
        dap.adapters["pwa-chrome"] = {
          type = "executable",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = {
              "${port}",
            },
          },
          enrich_config = function(config, on_config)
            config.type = "pwa-chrome"
            on_config(config)
          end,
        }

        dap.adapters["chrome"] = dap.adapters["pwa-chrome"]
      end

      -- Configurations
      local javascriptConfigurations = function()
        dap.configurations.javascript = {
          {
            name = "Launch file",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            sourceMaps = true,
          },
          {
            name = "Attach to Node",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          -- Divider for the launch.json derived configs
          {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
          },
        }
      end

      local typescriptConfigurations = function()
        dap.configurations.typescript = {
          {
            name = "Launch Node",
            type = "pwa-node",
            request = "launch",
            runtimeExecutable = "tsx",
            args = { "--inspect", "${file}" },
            skipFiles = { "node_modules/**" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            sourceMaps = true,
          },
          {
            name = "Launch Nodemon (npx)",
            type = "pwa-node",
            request = "launch",
            runtimeExecutable = "npx",
            args = { "nodemon", "--watch", "src/**/*.ts", "--exec", "npx", "ts-node", "${file}" },
            skipFiles = { "node_modules/**" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            sourceMaps = true,
          },
          {
            name = "Launch Nodemon (npx): src/main.ts",
            type = "pwa-node",
            request = "launch",
            runtimeExecutable = "npx",
            args = { "nodemon", "--watch", "src/**/*.ts", "--exec", "npx", "ts-node", "${workspaceFolder}/src/main.ts" },
            skipFiles = { "node_modules/**" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            sourceMaps = true,
          },
          {
            name = "Launch Nodemon (global)",
            type = "pwa-node",
            request = "launch",
            runtimeExecutable = "nodemon",
            args = { "--watch", "src/**/*.ts", "--exec", "npx", "ts-node", "${file}" },
            skipFiles = { "node_modules/**" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            sourceMaps = true,
          },
          {
            name = "Attach to Node",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          -- Divider for the launch.json derived configs
          {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
          },
        }
      end

      M.setup_adapters = function()
        dartAdapter()
        flutterAdapter()
        javascriptAdapter()
        chromeAdapter()
      end

      M.setup_configurations = function()
        javascriptConfigurations()
        typescriptConfigurations()
      end

      M.setup_colors = function()
        require("colors").add_and_set_color_module("debug", function()
          vim.api.nvim_set_hl(0, "SignColumn", {
            fg = "#bbbbbb",
          })
          vim.api.nvim_set_hl(0, "DapBreakpoint", {
            fg = "#abe9b3",
          })
          vim.api.nvim_set_hl(0, "DapLogPoint", {
            fg = "#89dceb",
          })
          vim.api.nvim_set_hl(0, "DapStopped", {
            fg = "#f38ba8",
          })
          vim.api.nvim_set_hl(0, "DapBreakpointRejected", {
            fg = "#fdfd96",
          })
        end)
      end

      return M
    end,
    config = function(_, opts)
      vim.fn.sign_define("DapBreakpoint", { text = "󰙧", numhl = "DapBreakpoint", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DagLogPoint", { text = "", numhl = "DapLogPoint", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "", numhl = "DapStopped", texthl = "DapStopped" })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", numhl = "DapBreakpointRejected", texthl = "DapBreakpointRejected" }
      )
      local dap_config = opts
      dap_config.setup_colors()
      dap_config.setup_adapters()
      dap_config.setup_configurations()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    event = "LspAttach",
    config = function()
      require("nvim-dap-virtual-text").setup {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = false,
        all_references = true,
        clear_on_continue = true,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value:gsub("%s+", " ")
          else
            return variable.name .. " = " .. variable.value:gsub("%s+", " ")
          end
        end,
        virt_text_pos = "inline",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      }
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    ---@module 'dap-view'
    ---@type dapview.Config
    keys = {
      {
        "<leader>dv",
        "<cmd>DapViewToggle<CR>",
        desc = "Debug Toggle UI",
      },
    },
    opts = {
      winbar = {
        default_section = "repl",
      },
    },
  },
  {
    "LiadOz/nvim-dap-repl-highlights",
    event = "LspAttach",
    config = function()
      require("nvim-dap-repl-highlights").setup()
      vim.api.nvim_create_user_command("DapReplHighlightsSetup", function()
        require("nvim-dap-repl-highlights").setup_highlights()
      end, {})
    end,
  },
}
