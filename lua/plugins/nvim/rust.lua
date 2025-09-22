return {
  {
    "mrcjkb/rustaceanvim",
    -- version = "^5",
    -- lazy = false,
    event = "BufEnter *Cargo.toml",
    ft = "rust",
    config = function()
      local lspconfig = require "lsp-opts"
      vim.g.rustaceanvim = {
        server = {
          autostart = true,
          capabilities = lspconfig.capabilities,
          on_init = lspconfig.on_init,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    keys = {
      {
        "<leader>cu",
        function()
          require("crates").upgrade_all_crates()
        end,
        desc = "Update Crates",
      },
    },
    opts = function()
      return {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
}
