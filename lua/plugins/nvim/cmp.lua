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
      local cmp = require "cmp"

      dofile(vim.g.base46_cache .. "cmp")

      local cmp_ui = require("nvconfig").ui.cmp
      local cmp_style = cmp_ui.style

      local field_arrangement = {
        atom = { "kind", "abbr", "menu" },
        atom_colored = { "kind", "abbr", "menu" },
      }

      local formatting_style = {
        -- default fields order i.e completion word + item.kind + item.kind icons
        fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

        format = function(_, item)
          local icons = require "nvchad.icons.lspkind"
          local icon = (cmp_ui.icons and icons[item.kind]) or ""

          if cmp_style == "atom" or cmp_style == "atom_colored" then
            icon = " " .. icon .. " "
            item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
            item.kind = icon
          else
            icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
            item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
          end

          return item
        end,
      }

      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      local options = {
        completion = {
          completeopt = "menu,menuone,noselect",
        },

        window = {
          completion = {
            side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
            scrollbar = false,
          },
          documentation = {
            border = border "CmpDocBorder",
            winhighlight = "Normal:CmpDoc",
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        formatting = formatting_style,

        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),

          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          },

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
          {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          },
          { name = "npm" },
          { name = "git" },
          { name = "html-css" },
        },
      }

      if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
        options.window.completion.border = border "CmpBorder"
      end

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })

      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      vim.tbl_deep_extend("force", options, require "nvchad.cmp")

      return options
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
