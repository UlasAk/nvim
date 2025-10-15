return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      "<leader>",
      "<c-r>",
      "<c-w>",
      '"',
      "'",
      "`",
      "c",
      "v",
      "g",
      "\\",
      { "<leader>Wka", "<cmd>WhichKey<CR>", desc = "Whichkey Keymaps (all)" },
      {
        "<leader>WKc",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Whichkey Keymaps (current buffer)",
      },
      {
        "<leader>WKq",
        function()
          vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
        end,
        desc = "Whichkey Query lookup",
      },
    },
    cmd = "WhichKey",
    opts = function()
      return {
        preset = "modern",
        triggers = {
          { "<auto>", mode = "nixsotc" },
        },
      }
    end,
  },
}
