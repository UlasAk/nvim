return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = function()
          return {
            fps = 60,
            background_colour = "#FDFD9A",
          }
        end,
        config = function(_, opts)
          require("notify").setup(opts)
        end,
      },
    },
    config = function()
      require("noice").setup(require "configs.noice")
      -- Change Noice Mini Background Color (where LSP Progress is shown)
      vim.cmd "hi NoiceMini guifg=#282737 guibg=#1E1E2E"
    end,
  },
  {
    "nvim-lua/popup.nvim",
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup {
        theme = "hyper",
        shortcut_type = "number",
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {},
          footer = {},
        },
      }
      vim.cmd "hi DashboardHeader guifg=#FDFD9A"
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
}
