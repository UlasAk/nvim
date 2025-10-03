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
      { "<leader>flh", "<cmd>FlutterRestart<CR>", desc = "Flutter Hot Restart" },
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
        ui = {
          border = "rounded",
          notification_style = "native", -- "native" | "plugin",
        },
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
            })[1]) .. "/.vscode/launch.json"
            require("dap.ext.vscode").load_launchjs(path)
          end,
        },
        flutter_path = nil,
        flutter_lookup_cmd = nil,
        root_patterns = { ".git", "android", "ios", "macos", "linux" },
        fvm = false,
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "htmlBoldItalic",
          prefix = "> ",
          priority = 10,
          enabled = true,
        },
        dev_log = {
          enabled = false,
          filter = nil,
          notify_errors = false,
          open_cmd = "botright 70vnew",
          focus_on_open = false,
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          open_cmd = "60vnew",
          auto_open = false,
        },
        lsp = {
          color = {
            enabled = true,
            background = true,
            background_color = { r = 19, g = 17, b = 24 },
            foreground = false,
            virtual_text = false,
            virtual_text_str = "■",
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
  -- {
  --   "wa11breaker/flutter-bloc.nvim",
  --   dependencies = {
  --     "nvimtools/none-ls.nvim", -- Required for code actions
  --   },
  --   ft = "dart",
  --   opts = {
  --     bloc_type = "default", -- Choose from: 'default', 'equatable', 'freezed'
  --     use_sealed_classes = false,
  --     enable_code_actions = true,
  --   },
  -- },
  -- {
  --   "akinsho/pubspec-assist.nvim",
  --   event = "BufEnter *pubspec.yaml",
  --   cmd = { "PubspecAssistAddPackage", "PubspecAssistPickVersion", "PubspecAssistAddDevPackage" },
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require("pubspec-assist").setup()
  --   end,
  -- },
}
