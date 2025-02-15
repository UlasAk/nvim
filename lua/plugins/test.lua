return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Language specifics
      "sidlatau/neotest-dart",
      "nvim-neotest/neotest-jest",
      "weilbith/neotest-gradle",
    },
    cmd = "Neotest summary",
    event = { "BufEnter *spec*", "BufEnter *test*" },
    config = function()
      local opts = require "configs.neotest"
      require("neotest").setup(opts)
    end,
  },
}
