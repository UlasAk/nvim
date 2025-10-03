return {
  {
    "OXY2DEV/markview.nvim",
    -- lazy = false,
    ft = "markdown",
    priority = 49,
    opts = {
      markdown = {
        headings = {
          heading_1 = { icon_hl = "@markup.link", icon = "[%d] " },
          heading_2 = { icon_hl = "@markup.link", icon = "[%d.%d] " },
          heading_3 = { icon_hl = "@markup.link", icon = "[%d.%d.%d] " },
          heading_4 = { icon_hl = "@markup.link", icon = "[%d.%d.%d.%d] " },
          heading_5 = { icon_hl = "@markup.link", icon = "[%d.%d.%d.%d.%d] " },
          heading_6 = { icon_hl = "@markup.link", icon = "[%d.%d.%d.%d.%d.%d] " },
        },
      },
    },
    config = function(_, opts)
      require("markview").setup(opts)
      require("markview.extras.checkboxes").setup {
        default = "X",
        remove_style = "disable",
        states = {
          { " ", "/", "X" },
          { "<", ">" },
          { "?", "!", "*" },
          { '"' },
          { "l", "b", "i" },
          { "S", "I" },
          { "p", "c" },
          { "f", "k", "w" },
          { "u", "d" },
        },
      }
      require("markview.extras.headings").setup()
      require("markview.extras.editor").setup()
    end,
  },
}
