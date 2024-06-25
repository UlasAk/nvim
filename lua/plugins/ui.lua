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
            background_colour = "#00000000",
          }
        end,
        config = function(_, opts)
          require("notify").setup(opts)
        end,
      },
    },
    config = function()
      require("noice").setup(require "configs.noice")
    end,
  },
  {
    "nvim-lua/popup.nvim",
  },
}
