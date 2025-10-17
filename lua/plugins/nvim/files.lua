return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTree Toggle window" },
      { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "NvimTree Focus window" },
    },
    opts = {
      hijack_netrw = false,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = {
          enable = false,
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      view = {
        adaptive_size = true,
        preserve_window_proportions = true,
        relativenumber = true,
      },
      git = {
        enable = true,
        ignore = false,
      },
      renderer = {
        highlight_git = "name",
        highlight_opened_files = "name",
        highlight_diagnostics = "name",
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      require("colors").add_and_set_color_module("nvim-tree", function()
        vim.api.nvim_set_hl(0, "NvimTreeCursorLine", {
          bg = "#474656",
        })
        if vim.g.transparent_enabled then
          vim.api.nvim_set_hl(0, "NvimTreeNormal", {
            bg = "NONE",
          })
          vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", {
            bg = "NONE",
          })
        end
      end)
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    cmd = "Oil",
    keys = {
      {
        "-",
        function()
          local oil = require "oil"
          local oil_util = require "oil.util"
          oil.open_float()
          oil_util.run_after_load(0, function()
            oil.open_preview()
          end)
        end,
        desc = "Oil Open parent directory",
      },
    },
    opts = {
      win_options = {
        wrap = true,
        signcolumn = "yes:2",
      },
      delete_to_trash = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name)
          return vim.startswith(name, ".")
        end,
      },
      float = {
        border = "rounded",
        win_options = {
          winblend = 0,
          signcolumn = "yes:2",
        },
        preview_split = "right",
        override = function(conf)
          local new_conf = vim.tbl_deep_extend(
            "force",
            conf,
            { relative = "editor", anchor = "SW", row = 1000, col = 2, width = 200, height = 50 }
          )
          return new_conf
        end,
      },
      confirmation = {
        border = "rounded",
      },
      preview_win = {
        update_on_cursor_moved = true,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      progress = {
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },
      ssh = {
        border = "rounded",
      },
      keymaps_help = {
        border = "rounded",
      },
    },
  },
}
