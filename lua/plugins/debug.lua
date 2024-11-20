return {
  {
    "mfussenegger/nvim-dap",
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
