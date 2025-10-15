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
      filters = {
        dotfiles = false,
      },
      disable_netrw = false,
      hijack_netrw = false,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      view = {
        adaptive_size = true,
        side = "left",
        width = 30,
        preserve_window_proportions = true,
        relativenumber = true,
      },
      git = {
        enable = true,
        ignore = false,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_opened_files = "name",
        highlight_diagnostics = true,

        indent_markers = {
          enable = true,
        },

        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },

          glyphs = {
            default = "󰈚",
            symlink = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = "",
              arrow_closed = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
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
