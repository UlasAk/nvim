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
        desc = "Test Debug file",
      },
      {
        "<leader>TS",
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
      {
        "<leader>Tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test Run last",
      },
      {
        "<leader>TL",
        function()
          require("neotest").run.run_last { strategy = "dap" }
        end,
        desc = "Test Debug last",
      },
      {
        "<leader>Ts",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test Stop",
      },
    },
    opts = function()
      return {
        adapters = {
          require "neotest-dart" {
            command = "flutter",
            use_lsp = true,
            custom_test_method_names = { "blocTest" },
          },
          require "neotest-gradle",
          require "neotest-jest" {
            cwd = function()
              return vim.fn.getcwd()
            end,
            jestCommand = "npm test --",
          },
        },
      }
    end,
  },
}
