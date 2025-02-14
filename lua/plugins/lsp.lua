local map = vim.keymap.set

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    config = function()
      local lspconfig = require "configs.lsp"
      lspconfig.defaults()
      lspconfig.setup_keymaps()
    end,
  },
  {
    "stevearc/conform.nvim",
    ft = function()
      local filetype_map = require("configs.conform").filetypes
      local filetypes = {}
      for key, _ in pairs(filetype_map) do
        table.insert(filetypes, key)
      end
      return filetypes
    end,
    keys = {
      {
        "<leader>bf",
        function()
          require("conform").format { lsp_fallback = true }
        end,
        desc = "General Format file",
      },
    },
    opts = function()
      return require("configs.conform").options
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
      "neovim/nvim-lspconfig",
    },
    event = { "User NvimTreeSetup" },
    config = function()
      local lsp_file_operations = require "lsp-file-operations"
      lsp_file_operations.setup()

      -- Set global defaults for all servers
      local lspconfig = require "lspconfig"
      local custom_lspconfig = require "configs.lsp"
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = vim.tbl_deep_extend(
          "force",
          custom_lspconfig.capabilities,
          lsp_file_operations.default_capabilities()
        ),
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "LiadOz/nvim-dap-repl-highlights" },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
              ["]o"] = "@loop.*",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            },
          },
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed_mason_names and opts.ensure_installed_mason_names > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed_mason_names, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function()
      local mason_opts = require "configs.mason"
      return {
        ensure_installed = mason_opts.ensure_installed,
        automatic_installation = true,
      }
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    opts = {},
  },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    ft = { "typescript" },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      keymaps = {
        toggle = "<leader>lt", -- default '<leader>dd'
        go_to_definition = "<leader>lgtd", -- default '<leader>dx'
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config { virtual_text = require("lsp_lines").toggle() }
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    dependencies = { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    priority = 1000, -- needs to be loaded in first
    event = "VeryLazy", -- Or `LspAttach`
    keys = function()
      --tiny-inline-diagnostic and lsp_lines toggle through
      local show_lsp_lines = vim.diagnostic.config().virtual_text
      return {
        {
          "<leader>ldt",
          function()
            show_lsp_lines = require("lsp_lines").toggle()
            if show_lsp_lines then
              require("tiny-inline-diagnostic").disable()
            else
              require("tiny-inline-diagnostic").enable()
            end
          end,
          desc = "Diagnostics Toggle virtual text",
        },
      }
    end,
    opts = {
      options = {
        use_icons_from_diagnostic = false,
        multilines = {
          enabled = true,
          always_show = true,
        },
        show_all_diags_on_cursorline = true,
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
    end,
  },
  {
    "rmagatti/goto-preview",
    keys = {
      {
        "<leader>lgpd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Goto-Preview Go to definition (via popup)",
      },
    },
    opts = {
      width = 120, -- Width of the floating window
      height = 15, -- Height of the floating window
      border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
      default_mappings = false, -- Bind default mappings
      debug = false, -- Print debug information
      opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
      resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
      post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
      post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
      references = { -- Configure the telescope UI for slowing the references cycling window.
        telescope = require("telescope.themes").get_dropdown { hide_preview = false },
      },
      -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
      focus_on_open = true, -- Focus the floating window when opening it.
      dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
      force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
      bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
      stack_floating_preview_windows = true, -- Whether to nest floating windows
      preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
      zindex = 1, -- Starting zindex for the stack of floating windows
    },
  },
}
