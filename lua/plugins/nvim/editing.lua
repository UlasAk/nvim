return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    enabled = false,
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { enabled = false, char = "│", highlight = "IblScopeChar" },
    },
    keys = {
      {
        "<leader>gc",
        function()
          local config = { scope = {} }
          config.scope.exclude = { language = {}, node_type = {} }
          config.scope.include = { node_type = {} }
          local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

          if node then
            local start_row, _, end_row, _ = node:range()
            if start_row ~= end_row then
              vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
              vim.api.nvim_feedkeys("_", "n", true)
            end
          end
        end,
        desc = "Goto Inner Context",
      },
      {
        "<leader>ti",
        "<cmd>IBLToggle<CR>",
        desc = "Toggle Indentation lines",
      },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "IblScopeChar", {
        fg = "#fdfd96",
      })
      vim.api.nvim_set_hl(0, "IblScope", {
        fg = "#fdfd96",
      })
      vim.api.nvim_set_hl(0, "IblChar", {
        fg = "#383747",
      })
      require("ibl").setup(opts)
      local hooks = require "ibl.hooks"

      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

      require("ibl").refresh()
    end,
  },
  {
    "numtostr/Comment.nvim",
    keys = {
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        desc = "Toggle Comment",
      },
      {
        "<leader>/",
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        desc = "Toggle Comment",
        mode = "v",
      },
    },
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "angular",
      "angular.html",
      "html",
      "htmlangular",
      "javascript",
      "jsx",
      "markdown",
      "php",
      "tsx",
      "typescript",
      "vue",
      "xml",
    },
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
    config = function(_, opts)
      require("nvim-ts-autotag").setup {
        opts = opts,
      }
    end,
  },
  {
    "jiaoshijie/undotree",
    keys = {
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle Undotree" },
    },
    opts = {},
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufEnter", "BufNew" },
    submodules = false,
    keys = {
      {
        "<leader>tr",
        function()
          require("rainbow-delimiters").toggle()
        end,
        desc = "Toggle Rainbow delimiters",
      },
    },
    config = function()
      require("rainbow-delimiters.setup").setup {
        strategy = {
          -- ...
        },
        query = {
          -- ...
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterViolet",
          "RainbowDelimiterBlue",
          "RainbowDelimiterGreen",
          "RainbowDelimiterOrange",
          "RainbowDelimiterCyan",
        },
      }
      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", {
        fg = "#f38ba8",
      })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", {
        fg = "#fdfd96",
      })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", {
        fg = "#b4befe",
      })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", {
        fg = "#89b4fa",
      })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", {
        fg = "#a6e3a1",
      })
      vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", {
        fg = "#fab387",
      })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", {
        fg = "#94e2d5",
      })
    end,
  },
}
