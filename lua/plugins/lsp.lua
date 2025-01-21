return {
  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "saghen/blink.cmp" },
    event = "User FilePost",
    config = function()
      local lspconfig = require "configs.lsp"
      lspconfig.defaults()
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    -- ft = { "html", "lua", "javascript", "typescript", "yaml" },
    opts = function()
      return require "configs.conform"
    end,
    config = function(_, opts)
      require("conform").setup(opts)
      local map = vim.keymap.set

      map("n", "<leader>bf", function()
        require("conform").format { lsp_fallback = true }
      end, { desc = "General Format file" })
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = { "User NvimTreeSetup" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
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
    lazy = false,
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
    config = function()
      require("tsc").setup()
    end,
  },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    ft = { "typescript" },
    dependencies = { "MunifTanjim/nui.nvim" },
    config = {
      keymaps = {
        toggle = "<leader>lt", -- default '<leader>dd'
        go_to_definition = "<leader>lgtd", -- default '<leader>dx'
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- {
  --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   config = function()
  --     local lsp_lines = require "lsp_lines"
  --     lsp_lines.setup()
  --     lsp_lines.toggle()
  --
  --     local map = vim.keymap.set
  --     map("n", "<leader>ldt", function()
  --       local show_virtual_lines_now = require("lsp_lines").toggle()
  --       vim.diagnostic.config { virtual_text = not show_virtual_lines_now }
  --     end, { desc = "Diagnostics Toggle virtual text" })
  --   end,
  -- },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
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
      vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
      local map = vim.keymap.set
      local show_virtual_lines_now = true
      map("n", "<leader>ldt", function()
        require("tiny-inline-diagnostic").toggle()
        vim.diagnostic.config { virtual_text = show_virtual_lines_now }
        show_virtual_lines_now = not show_virtual_lines_now
      end, { desc = "Diagnostics Toggle virtual text" })
    end,
  },
}
