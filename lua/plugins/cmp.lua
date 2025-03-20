return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        dependencies = {
          "neovim/nvim-lspconfig",
        },
      },
      {
        "hrsh7th/cmp-buffer",
      },
      {
        "hrsh7th/cmp-path",
      },
      {
        "hrsh7th/cmp-cmdline",
      },
      {
        "rcarriga/cmp-dap",
      },
      {
        "folke/lazydev.nvim",
      },

      {
        "L3MON4D3/LuaSnip",
      },
      -- cmp sources plugins
      {
        "neovim/nvim-lspconfig",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        {
          "David-Kunz/cmp-npm",
          dependencies = { "nvim-lua/plenary.nvim" },
          ft = "json",
          config = function()
            require("cmp-npm").setup {}
          end,
        },
        {
          "petertriho/cmp-git",
          opts = {},
        },
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },
  -- {
  --   "saghen/blink.cmp",
  --   lazy = false, -- lazy loading handled internally
  --   -- optional: provides snippets for the snippet source
  --   dependencies = { "rafamadriz/friendly-snippets", "L3MON4D3/LuaSnip" },
  --   -- use a release tag to download pre-built binaries
  --   version = "v0.*",
  --   -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  --   -- build = 'cargo build --release',
  --   -- If you use nix, you can build from source using latest nightly rust with:
  --   -- build = 'nix run .#build-plugin',
  --
  --   ---@module 'blink.cmp'
  --   ---@type blink.cmp.Config
  --   opts = {
  --     -- 'default' for mappings similar to built-in completion
  --     -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
  --     -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
  --     -- see the "default configuration" section below for full documentation on how to define
  --     -- your own keymap.
  --     keymap = {
  --       preset = "default",
  --       ["<Tab>"] = { "select_next", "fallback" },
  --       ["<S-Tab>"] = { "select_prev", "fallback" },
  --       ["<CR>"] = { "accept", "fallback" },
  --       cmdline = {
  --         preset = "super-tab",
  --       },
  --     },
  --
  --     appearance = {
  --       -- Sets the fallback highlight groups to nvim-cmp's highlight groups
  --       -- Useful for when your theme doesn't support blink.cmp
  --       -- will be removed in a future release
  --       use_nvim_cmp_as_default = false,
  --       -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
  --       -- Adjusts spacing to ensure icons are aligned
  --       nerd_font_variant = "mono",
  --     },
  --
  --     -- default list of enabled providers defined so that you can extend it
  --     -- elsewhere in your config, without redefining it, via `opts_extend`
  --     sources = {
  --       default = { "lsp", "path", "luasnip", "buffer", "crates", "lazydev", "nvim_lua" },
  --       -- optionally disable cmdline completions
  --       cmdline = {},
  --     },
  --     -- Controls how the completion items are rendered on the popup window
  --     draw = {
  --       -- Aligns the keyword you've typed to a component in the menu
  --       align_to_component = "label", -- or 'none' to disable
  --       -- Left and right padding, optionally { left, right } for different padding on each side
  --       padding = 1,
  --       -- Gap between columns
  --       gap = 1,
  --       -- Use treesitter to highlight the label text of completions from these sources
  --       -- treesitter = {},
  --       -- Recommended to enable it just for the LSP source
  --       treesitter = { "lsp" },
  --
  --       -- Components to render, grouped by column
  --       columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
  --       -- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
  --       -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
  --
  --       -- Definitions for possible components to render. Each component defines:
  --       --   ellipsis: whether to add an ellipsis when truncating the text
  --       --   width: control the min, max and fill behavior of the component
  --       --   text function: will be called for each item
  --       --   highlight function: will be called only when the line appears on screen
  --       components = {
  --         kind_icon = {
  --           ellipsis = false,
  --           text = function(ctx)
  --             return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
  --           end,
  --           highlight = function(ctx)
  --             return require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx) or "BlinkCmpKind" .. ctx.kind
  --           end,
  --         },
  --
  --         kind = {
  --           ellipsis = false,
  --           width = { fill = true },
  --           text = function(ctx)
  --             return ctx.kind
  --           end,
  --           highlight = function(ctx)
  --             return require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx) or "BlinkCmpKind" .. ctx.kind
  --           end,
  --         },
  --
  --         label = {
  --           width = { fill = true, max = 60 },
  --           text = function(ctx)
  --             return ctx.label .. ctx.label_detail
  --           end,
  --           highlight = function(ctx)
  --             -- label and label details
  --             local highlights = {
  --               { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
  --             }
  --             if ctx.label_detail then
  --               table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" })
  --             end
  --
  --             -- characters matched on the label by the fuzzy matcher
  --             for _, idx in ipairs(ctx.label_matched_indices) do
  --               table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
  --             end
  --
  --             return highlights
  --           end,
  --         },
  --
  --         label_description = {
  --           width = { max = 30 },
  --           text = function(ctx)
  --             return ctx.label_description
  --           end,
  --           highlight = "BlinkCmpLabelDescription",
  --         },
  --
  --         source_name = {
  --           width = { max = 30 },
  --           text = function(ctx)
  --             return ctx.source_name
  --           end,
  --           highlight = "BlinkCmpSource",
  --         },
  --       },
  --     },
  --     -- documentation = {
  --     --   ghost_text = {
  --     --     enabled = true,
  --     --   },
  --     -- },
  --     signature = {
  --       enabled = true,
  --     },
  --     snippets = {
  --       expand = function(snippet)
  --         require("luasnip").lsp_expand(snippet)
  --       end,
  --       active = function(filter)
  --         if filter and filter.direction then
  --           return require("luasnip").jumpable(filter.direction)
  --         end
  --         return require("luasnip").in_snippet()
  --       end,
  --       jump = function(direction)
  --         require("luasnip").jump(direction)
  --       end,
  --     },
  --
  --     -- experimental signature help support
  --     -- signature = { enabled = true }
  --   },
  --   -- allows extending the providers array elsewhere in your config
  --   -- without having to redefine it
  --   opts_extend = { "sources.default" },
  -- },
}
