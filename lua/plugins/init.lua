local cmp = require "cmp"

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return require "configs.treesitter"
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require("configs.lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "prettier",
      },
    },
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    config = function ()
      local lspconfig = require("configs.lspconfig")
      require('rust-tools').setup({
        server = {
          on_attach = lspconfig.on_attach,
          capabilities = lspconfig.capabilities
        }
      })
    end
  },
  {
    "mfussenegger/nvim-dap",
  },
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^4",
  --   ft = { "rust" },
  -- },
  {
    'saecki/crates.nvim',
    ft = { "toml" },
    config = function()
      require("crates").setup {
        lsp = {
          enabled = true,
          on_attach = require("configs.lspconfig").on_attach,
          actions = true,
          completion = true,
          hover = true,
        },
        src = {
          cmp = {
            enabled = true,
          }
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require('nvchad.configs.cmp')
      M.completion.completeopt = "menu,menuone,noselect"
      M.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      -- add sources to cmp
      table.insert(M.sources, {name = "crates"})
      return M
    end,
  },
  {
    "NvChad/nvterm",
    config = function ()
      require("nvterm").setup({
        terminals = {
          type_opts = {
            horizontal = { location = "rightbelow", split_ratio = .3},
            vertical = { location = "rightbelow", split_ratio = .3},
          }
        }
      })
    end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {

    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function ()
      require("noice").setup({
        lsp = {
          hover = {
            enabled = false
          },
          signature = {
            enabled = false
          }
        }
      })
    end
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = false
  },
  {
    "hrsh7th/cmp-path",
    lazy = false
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = false
  },
  -- {
  --   "github/copilot.vim",
  --   lazy = false
  -- },
}
