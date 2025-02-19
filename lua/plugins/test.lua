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
    keys = {
      {
        "<leader>Td",
        function()
          require("neotest").run.run { strategy = "dap" }
        end,
        desc = "Test Debug nearest",
      },
      {
        "<leader>Tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Test Run nearest",
      },
      {
        "<leader>TR",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Test Run file",
      },
      {
        "<leader>TD",
        function()
          require("neotest").run.run { vim.fn.expand "%", strategy = "dap" }
        end,
        desc = "Test Run file",
      },
      {
        "<leader>Ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test Toggle summary",
      },
      {
        "<leader>To",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test Toggle output",
      },
    },
    opts = function()
      return require "configs.neotest"
    end,
  },
}
