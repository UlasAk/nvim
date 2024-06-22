return {
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    lazy = false,
    config = function()
      local lspconfig = require "configs.lsp"
      vim.g.rustaceanvim = {
        server = {
          on_attach = lspconfig.on_attach,
          capabilities = lspconfig.capabilities,
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      local on_attach = require("configs.lsp").on_attach
      require("crates").setup {
        lsp = {
          enabled = true,
          on_attach = on_attach,
          actions = true,
          completion = true,
          hover = true,
        },
        completion = {
          insert_closing_quote = true,
          cmp = {
            enabled = true,
          },
          crates = {
            enabled = true,
          },
        },
      }
    end,
  },
}
