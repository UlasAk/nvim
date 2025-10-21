return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    event = { "BufRead *.dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    keys = {
      {
        "<leader>flc",
        function()
          require("telescope").extensions.flutter.commands()
        end,
        desc = "Telescope Flutter commands",
      },
      {
        "<leader>flv",
        function()
          require("telescope").extensions.flutter.fvm()
        end,
        desc = "Telescope Flutter commands",
      },
      { "<leader>fld", "<cmd>FlutterDevices<CR>", desc = "Flutter Select Device" },
      { "<leader>fle", "<cmd>FlutterEmulators<CR>", desc = "Flutter Emulators" },
      { "<leader>flr", "<cmd>FlutterRun<CR>", desc = "Flutter Run" },
      { "<leader>flh", "<cmd>FlutterReload<CR>", desc = "Flutter Hot Reload" },
      { "<leader>flH", "<cmd>FlutterRestart<CR>", desc = "Flutter Hot Restart" },
      {
        "<leader>flt",
        function()
          require("flutter-tools.commands").open_dev_tools()
        end,
        desc = "Flutter Open Dev Tools",
      },
      { "<leader>flo", "<cmd>FlutterOutlineToggle<CR>", desc = "Flutter Toggle Outline" },
      { "<leader>flq", "<cmd>FlutterQuit<CR>", desc = "Flutter Quit" },
    },
    opts = function()
      local lspconfig = require "lsp-opts"
      return {
        decorations = {
          statusline = {
            app_version = true,
            device = true,
            project_config = true,
          },
        },
        debugger = {
          enabled = true,
          exception_breakpoints = {},
          evaluate_to_string_in_debug_views = true,
          register_configurations = function(paths)
            local api = vim.api
            local fs = vim.fs
            local buf = api.nvim_get_current_buf()
            local buffer_path = api.nvim_buf_get_name(buf)
            local path = fs.dirname(fs.find({ ".git" }, {
              path = buffer_path,
              upward = true,
            })[1])
            if path ~= nil then
              path = path .. "/.vscode/launch.json"
              require("dap.ext.vscode").load_launchjs(path)
            end
          end,
        },
        root_patterns = { ".git", "android", "ios", "macos", "linux" },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          enabled = true,
          highlight = "htmlBoldItalic",
          prefix = "> ",
        },
        dev_log = {
          enabled = false,
        },
        outline = {
          open_cmd = "60vnew",
        },
        lsp = {
          color = {
            enabled = true,
            background = true,
            background_color = { r = 19, g = 17, b = 24 },
            virtual_text = false,
          },
          capabilities = lspconfig.capabilities,
          settings = {
            showTodos = false,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
            onlyAnalyzeProjectsWithOpenFiles = false,
          },
        },
      }
    end,
  },
}
