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
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "xiyaowong/transparent.nvim" },
    opts = function()
      return require "configs.bufferline"
    end,
    config = function(_, opts)
      vim.opt.termguicolors = true
      require("bufferline").setup { options = opts.options }
      opts.setup_colors()
      require("transparent").clear_prefix "BufferLine"
    end,
  },
  -- {
  --   "willothy/nvim-cokeline",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for v0.4.0+
  --     "nvim-tree/nvim-web-devicons", -- If you want devicons
  --     "stevearc/resession.nvim", -- Optional, for persistent history
  --   },
  --   config = true,
  -- },
  -- {
  --   "giusgad/pets.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
  --   config = function()
  --     require("pets").setup {
  --       avoid_statusline = true,
  --       winblend = 0,
  --     }
  --   end,
  -- },
}
