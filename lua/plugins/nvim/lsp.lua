return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    config = function()
      local lspconfig = require "lsp-opts"
      lspconfig.defaults()
      lspconfig.setup_keymaps()
      lspconfig.setup_colors()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    ft = function()
      return require("mason-opts").get_linter_filetypes()
    end,
    config = function()
      local lint = require "lint"
      local mason_config = require "mason-opts"
      lint.linters_by_ft = mason_config.get_filetype_linter_nvim_lint_map()

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
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
      local custom_lspconfig = require "lsp-opts"
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
    branch = "main",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "angular",
        "bash",
        "c_sharp",
        "css",
        "dart",
        "dap_repl",
        "dockerfile",
        "javascript",
        "html",
        "hyprlang",
        "ini",
        "json",
        "json5",
        "kotlin",
        -- "latex",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "regex",
        "rust",
        "ssh_config",
        "swift",
        "terraform",
        "tmux",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },

      highlight = {
        enable = true,
        use_languagetree = true,
      },

      indent = { enable = true },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
      require("nvim-treesitter").setup(opts)
      -- Add Custom Filetypes
      local function is_hypr_conf(path)
        return path:match "/hypr/" and path:match "%.conf$"
      end

      local function is_tmux_conf(path)
        return path:match "%tmux.conf$"
      end

      local function check_yaml_file(path)
        if path:match ".*docker.*compose.*$" and (path:match "%.yaml$" or path:match "%.yml$") then
          return "yaml.docker-compose"
        end
        return "yaml"
      end

      vim.filetype.add {
        pattern = {
          -- [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `angular` if it matches the pattern
          [".*%.yaml"] = function(path, _)
            return check_yaml_file(path)
          end,
          [".*%.yml"] = function(path, _)
            return check_yaml_file(path)
          end,
          [".*%.conf"] = function(path, _)
            if is_hypr_conf(path) then
              return "hyprlang"
            elseif is_tmux_conf(path) then
              return "tmux"
            else
              return "dosini"
            end
          end,
        },
      }

      -- Angular
      local function is_angular_template(path)
        return path:match "%.component%.html$"
      end
      vim.api.nvim_create_augroup("AngularTemplates", {})
      vim.api.nvim_create_autocmd({ "BufRead", "BufEnter", "BufNewFile" }, {
        pattern = "*.component.html",
        callback = function()
          -- Setze den Dateityp auf HTML, damit HTML-Plugins funktionieren
          vim.bo.filetype = "html"

          -- Speziell für Treesitter auf Angular setzen
          if is_angular_template(vim.fn.expand "<afile>:p") then
            vim.cmd "set filetype=htmlangular"
          end
        end,
        group = "AngularTemplates",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          enable = true,
          disable = { "dart" },

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
          disable = { "dart" },
          swap_next = {
            ["<leader>ps"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>pS"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          disable = { "dart" },
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
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>gC",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        silent = true,
        desc = "Goto Context",
      },
    },
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false, -- Enable multiwindow support.
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.api.nvim_set_hl(0, "TreesitterContext", {
        bg = "#444151",
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "mason-opts"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts.options)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.options.ensure_installed_mason_names and #opts.options.ensure_installed_mason_names > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.options.ensure_installed_mason_names, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.options.ensure_installed
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    ft = function()
      return require("mason-opts").get_lsp_filetypes()
    end,
    opts = function()
      local mason_opts = require "mason-opts"
      return {
        ensure_installed = mason_opts.options.ensure_installed,
        automatic_installation = true,
        automatic_enable = false,
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
      vim.schedule(function()
        vim.diagnostic.config { virtual_text = false }
      end)
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
      local show_diagnostics = true
      return {
        {
          "<leader>ldt",
          function()
            if (not show_diagnostics and show_lsp_lines) or show_diagnostics then
              show_lsp_lines = require("lsp_lines").toggle()
            end
            show_diagnostics = true
            if show_lsp_lines then
              require("tiny-inline-diagnostic").disable()
            else
              require("tiny-inline-diagnostic").enable()
            end
          end,
          desc = "Diagnostics Toggle virtual text type",
        },
        {
          "<leader>ldT",
          function()
            show_diagnostics = not show_diagnostics
            if show_diagnostics then
              if show_lsp_lines then
                require("lsp_lines").toggle()
              else
                require("tiny-inline-diagnostic").enable()
              end
            else
              if show_lsp_lines then
                require("lsp_lines").toggle()
              end
              require("tiny-inline-diagnostic").disable()
            end
          end,
          desc = "Diagnostics Toggle virtual text",
        },
      }
    end,
    opts = {
      options = {
        use_icons_from_diagnostic = false,
        show_source = true,
        add_messages = true,
        multilines = {
          enabled = true,
          always_show = true,
        },
        show_all_diags_on_cursorline = true,
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      vim.schedule(function()
        vim.diagnostic.config { virtual_text = false }
      end)
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
  {
    "boltlessengineer/sense.nvim",
    event = "LspAttach",
    keys = function()
      local enabled = true
      return {
        {
          "<leader>se",
          function()
            enabled = not enabled
            vim.g.sense_nvim = {
              presets = {
                virtualtext = {
                  enabled = enabled,
                },
                statuscolumn = {
                  enabled = enabled,
                },
              },
            }
            require("sense.api").redraw {}
          end,
          desc = "Toggle Sense",
        },
      }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
      hint_prefix = "",
    },
  },
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>ts", "<cmd>AerialToggle!<CR>", desc = "Toggle Symbols outline" },
    },
    opts = {},
  },
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>;",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Pick Symbol from top bar",
      },
    },
    opts = {},
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },
}
