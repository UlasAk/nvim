return {
  {
    "mfussenegger/nvim-dap",
    event = "LspAttach",
    keys = {
      { "<leader>dbt", "<cmd>DapToggleBreakpoint<CR>", desc = "Debug Toggle Breakpoint" },
      { "<leader>dba", "<cmd>DapClearBreakpoints<CR>", desc = "Debug Clear Breakpoints" },
      { "<leader>dc", "<cmd>DapContinue<CR>", desc = "Debug Continue" },
      { "<leader>dsov", "<cmd>DapStepOver<CR>", desc = "Debug Step Over" },
      { "<leader>dsou", "<cmd>DapStepOut<CR>", desc = "Debug Step Out" },
      { "<leader>dsi", "<cmd>DapStepIn<CR>", desc = "Debug Step In" },
      { "<leader>dr", "<cmd>DapToggleRepl<CR>", desc = "Debug Toggle Repl" },
      { "<leader>dd", "<cmd>DapDisconnect<CR>", desc = "Debug Disconnect" },
      { "<leader>dt", "<cmd>DapTerminate<CR>", desc = "Debug Terminate" },
      {
        "<leader>ds",
        function()
          local widgets = require "dap.ui.widgets"
          local sidebar = widgets.sidebar(widgets.scopes)
          sidebar.open()
        end,
        desc = "Debug Open sidebar",
      },
    },
    config = function()
      require("configs.dap").setup_adapters()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    event = "LspAttach",
    config = function()
      require("nvim-dap-virtual-text").setup {
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        --- A callback that determines how a variable is displayed or whether it should be omitted
        --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        --- @param buf number
        --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
        --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
        --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, buf, stackframe, node, options)
          -- by default, strip out new line characters
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value:gsub("%s+", " ")
          else
            return variable.name .. " = " .. variable.value:gsub("%s+", " ")
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = "inline",

        -- experimental features:
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "nvim-dap-ui" },
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "folke/lazydev.nvim" },
    keys = {
      {
        "<leader>dut",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug Toggle UI",
      },
    },
  },
  { "Bilal2453/luvit-meta" },
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
