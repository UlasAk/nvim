return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
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
      { "<leader>flr", "<cmd>FlutterRun<CR>", desc = "Flutter Run" },
      { "<leader>flh", "<cmd>FlutterRestart<CR>", desc = "Flutter Hot Restart" },
      {
        "<leader>flt",
        function()
          require("flutter-tools.commands").open_dev_tools()
        end,
        desc = "Flutter Open Dev Tools",
      },
      { "<leader>flq", "<cmd>FlutterQuit<CR>", desc = "Flutter Quit" },
    },
    opts = function()
      local lspconfig = require "lsp-opts"
      return {
        ui = {
          -- the border type to use for all floating windows, the same options/formats
          -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
          border = "rounded",
          -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
          -- please note that this option is eventually going to be deprecated and users will need to
          -- depend on plugins like `nvim-notify` instead.
          notification_style = "native", -- "native" | "plugin",
        },
        decorations = {
          statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = true,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = true,
            -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
            -- this will show the currently selected project configuration
            project_config = true,
          },
        },
        debugger = { -- integrate with nvim dap + install dart code debugger
          enabled = true,
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |:help dap.set_exception_breakpoints()| for more info
          exception_breakpoints = {},
          -- Whether to call toString() on objects in debug views like hovers and the
          -- variables list.
          -- Invoking toString() has a performance cost and may introduce side-effects,
          -- although users may expected this functionality. null is treated like false.
          evaluate_to_string_in_debug_views = true,
          register_configurations = function(paths)
            -- require("dap").configurations.dart = {
            --   --put here config that you would find in .vscode/launch.json
            -- }
            -- If you want to load .vscode launch.json automatically run the following:
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
        flutter_path = nil, -- <-- this takes priority over the lookup
        flutter_lookup_cmd = nil, -- example "dirname $(which flutter)" or "asdf where flutter"
        root_patterns = { ".git" }, -- patterns to find the root of your flutter project
        fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "htmlBoldItalic", -- highlight for the closing tag
          prefix = "> ", -- character to use for close tag e.g. > Widget
          priority = 10, -- priority of virtual text in current line
          -- consider to configure this when there is a possibility of multiple virtual text items in one line
          -- see `priority` option in |:help nvim_buf_set_extmark| for more info
          enabled = true, -- set to false to disable
        },
        dev_log = {
          enabled = false,
          filter = nil, -- optional callback to filter the log
          -- takes a log_line as string argument; returns a boolean or nil;
          -- the log_line is only added to the output if the function returns true
          notify_errors = false, -- if there is an error whilst running then notify the user
          open_cmd = "botright 70vnew", -- command to use to open the log buffer
          focus_on_open = false,
        },
        dev_tools = {
          autostart = false, -- autostart devtools server if not detected
          auto_open_browser = false, -- Automatically opens devtools in the browser
        },
        outline = {
          open_cmd = "60vnew", -- command to use to open the outline buffer
          auto_open = false, -- if true this will open the outline automatically when it is first populated
        },
        lsp = {
          color = { -- show the derived colours for dart variables
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = true, -- highlight the background
            background_color = { r = 19, g = 17, b = 24 }, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = false, -- highlight the foreground
            virtual_text = false, -- show the highlight using virtual text
            virtual_text_str = "■", -- the virtual text character to highlight
          },
          on_attach = lspconfig.on_attach,
          capabilities = lspconfig.capabilities, -- e.g. lsp_status capabilities
          --- OR you can specify a function to deactivate or change or control how the config is created
          -- capabilities = function(config)
          --   config.specificThingIDontWant = false
          --   return config
          -- end,
          -- see the link below for details on each option:
          -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            -- analysisExcludedFolders = { "<path-to-flutter-sdk-packages>" },
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
            onlyAnalyzeProjectsWithOpenFiles = true,
          },
        },
      }
    end,
    config = function(_, opts)
      -- Statusline
      local function flutterStatusLine()
        local decorations = vim.g.flutter_tools_decorations
        if not decorations then
          return ""
        end

        local information_table = {}

        -- type: Device
        local device = decorations.device
        if device then
          table.insert(information_table, device.name)
        end

        -- tpye: flutter.ProjectConfig
        local project_config = decorations.project_config
        if project_config and project_config.name then
          table.insert(information_table, project_config.name)
        end

        -- type: string
        local app_version = decorations.app_version
        if app_version then
          local comment_pos, _ = string.find(app_version, "#")
          if comment_pos then
            app_version = string.gsub(string.sub(app_version, 0, comment_pos - 1), "%s+", "")
          end
          table.insert(information_table, app_version)
        end

        return table.concat(information_table, " - ")
      end

      local statusline = require("chadrc").ui.statusline
      statusline.modules.flutter = function()
        return flutterStatusLine()
      end
      local function indexOf(table, value)
        for i, v in ipairs(table) do
          if v == value then
            return i
          end
        end
        return nil
      end
      local pos = indexOf(statusline.order, "diagnostics")
      if pos then
        table.insert(statusline.order, pos, "flutter")
      end

      -- Setup
      require("flutter-tools").setup(opts)
    end,
  },
  {
    "wa11breaker/flutter-bloc.nvim",
    dependencies = {
      "nvimtools/none-ls.nvim", -- Required for code actions
    },
    ft = "dart",
    opts = {
      bloc_type = "default", -- Choose from: 'default', 'equatable', 'freezed'
      use_sealed_classes = false,
      enable_code_actions = true,
    },
  },
  {
    "akinsho/pubspec-assist.nvim",
    event = "BufEnter *pubspec.yaml",
    cmd = { "PubspecAssistAddPackage", "PubspecAssistPickVersion", "PubspecAssistAddDevPackage" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("pubspec-assist").setup()
    end,
  },
}
