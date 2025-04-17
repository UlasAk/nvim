return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<leader>th",
        function()
          local hardtime = require "hardtime"
          hardtime.toggle()
          Snacks.notify(hardtime.is_plugin_enabled and "Enabled" or "Disabled", { title = "Hardtime" })
        end,
        desc = "Toggle Hardtime",
      },
    },
    opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
    },
  },
  {
    "tris203/precognition.nvim",
    keys = {
      {
        "<leader>tp",
        function()
          Snacks.notify(require("precognition").toggle() and "Enabled" or "Disabled", { title = "Precognition" })
        end,
        desc = "Toggle Precognition",
      },
      {
        "<leader>pp",
        function()
          require("precognition").peek()
        end,
        desc = "Toggle Precognition",
      },
    },
    opts = {
      startVisible = false,
      -- showBlankVirtLine = true,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --     G = { text = "G", prio = 10 },
      --     gg = { text = "gg", prio = 9 },
      --     PrevParagraph = { text = "{", prio = 8 },
      --     NextParagraph = { text = "}", prio = 8 },
      -- },
      -- disabled_fts = {
      --     "startify",
      -- },
    },
  },
}
