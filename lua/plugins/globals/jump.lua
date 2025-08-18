return {
  {
    "folke/flash.nvim",
    event = "BufReadPost",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "n", mode = { "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "N", mode = { "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
      { "<c-S>", mode = { "c" }, function() require("flash").toggle() end, desc = "Flash Toggle Flash Search" },
    },
  },
}
