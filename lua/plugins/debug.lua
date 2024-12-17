return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local map = vim.keymap.set
      map("n", "<leader>dbt", "<cmd>DapToggleBreakpoint<CR>", { desc = "Debug Toggle Breakpoint" })
      map("n", "<leader>ds", function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end, { desc = "Debug Open sidebar" })
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
  { "Bilal2453/luvit-meta", lazy = true },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
}
