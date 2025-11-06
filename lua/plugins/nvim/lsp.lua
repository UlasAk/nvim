return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "BufEnter",
    config = function()
      local lspconfig = require "lsp-opts"
      lspconfig.defaults()
      lspconfig.setup_keymaps()
      lspconfig.setup_colors()
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    name = "lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
      "stevearc/oil.nvim",
    },
    event = { "User NvimTreeSetup" },
    ft = { "oil" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "LiadOz/nvim-dap-repl-highlights" },
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ensure_installed = {
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
      }

      local already_installed = require("nvim-treesitter.config").get_installed()
      local parsers_to_install = vim
        .iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(already_installed, parser)
        end)
        :totable()
      require("nvim-treesitter").install(parsers_to_install)
      require("nvim-treesitter").update()

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
          -- Set filetype to HTML in order for html related plugins to work
          vim.bo.filetype = "html"

          -- Set filetype to angular for treesitter specifically
          if is_angular_template(vim.fn.expand "<afile>:p") then
            vim.cmd "set filetype=htmlangular"
          end
        end,
        group = "AngularTemplates",
      })

      -- auto-start highlights & indentation
      vim.api.nvim_create_autocmd("FileType", {
        desc = "User: enable treesitter highlighting",
        callback = function(ctx)
          -- highlights
          local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

          -- folds
          local bufnr = ctx.buf
          vim.bo[bufnr].syntax = "on"
          vim.wo.foldlevel = 99
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

          -- indent
          local noIndent = {}
          if hasStarted and not vim.list_contains(noIndent, ctx.match) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        mode = { "x", "o" },
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end,
        desc = "Select around function",
      },
      {
        mode = { "x", "o" },
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end,
        desc = "Select inner function",
      },
      {
        mode = { "x", "o" },
        "ac",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end,
        desc = "Select around class",
      },
      {
        mode = { "x", "o" },
        "ic",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end,
        desc = "Select inner class",
      },
      {
        mode = { "x", "o" },
        "as",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
        end,
        desc = "Select scope",
      },
      {
        mode = "n",
        "<leader>ps",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
        end,
        desc = "Parameter swap with next",
      },
      {
        mode = "n",
        "<leader>pS",
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
        end,
        desc = "Parameter swap with previous",
      },
      {
        mode = { "n", "x", "o" },
        "]m",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        desc = "Jump Next function start",
      },
      {
        mode = { "n", "x", "o" },
        "]]",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        desc = "Jump Next class start",
      },
      {
        mode = { "n", "x", "o" },
        "]o",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
        end,
        desc = "Jump Next loop",
      },
      {
        mode = { "n", "x", "o" },
        "]s",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
        end,
        desc = "Jump Next scope",
      },
      {
        mode = { "n", "x", "o" },
        "]z",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
        end,
        desc = "Jump Next fold",
      },
      {
        mode = { "n", "x", "o" },
        "]M",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        desc = "Jump Next function end",
      },
      {
        mode = { "n", "x", "o" },
        "][",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end,
        desc = "Jump Next class end",
      },
      {
        mode = { "n", "x", "o" },
        "[m",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        desc = "Jump Previous function start",
      },
      {
        mode = { "n", "x", "o" },
        "[[",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        desc = "Jump Previous class start",
      },
      {
        mode = { "n", "x", "o" },
        "[M",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        desc = "Jump Previous function end",
      },
      {
        mode = { "n", "x", "o" },
        "[]",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
        end,
        desc = "Jump Previous class end",
      },
      {
        mode = { "n", "x", "o" },
        "]d",
        function()
          require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
        end,
        desc = "Jump Next condition",
      },
      {
        mode = { "n", "x", "o" },
        "[d",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
        end,
        desc = "Jump Previous condition",
      },
    },
    opts = {
      select = {
        disable = { "dart" },
        lookahead = true,
        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
          ["@class.outer"] = "<c-v>",
        },
        include_surrounding_whitespace = true,
      },
      swap = {
        disable = { "dart" },
      },
      move = {
        disable = { "dart" },
        set_jumps = true,
      },
    },
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
      multiwindow = true,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      require("colors").add_and_set_color_module("treesitter-context", function()
        vim.api.nvim_set_hl(0, "TreesitterContext", {
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
          sp = "#f9e2af",
          underline = true,
        })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
          fg = "#8886a6",
          bg = "NONE",
        })
      end)
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    keys = {
      { "M", "<CMD>Mason<CR>", desc = "Mason Open" },
    },
    opts = function()
      local M = {}

      M.get_all_ensure_installed_mason_names = function()
        local name_table = {
          "angular-language-server",
          "bash-language-server",
          "css-lsp",
          "dart-debug-adapter",
          "docker-compose-language-service",
          "dockerfile-language-server",
          "emmet-language-server",
          "eslint-lsp",
          "js-debug-adapter",
          "json-lsp",
          "lua-language-server",
          "luacheck",
          "markdownlint",
          "netcoredbg",
          "prettier",
          "pyright",
          "qmlls",
          "roslyn",
          "rust-analyzer",
          "shellcheck",
          "shfmt",
          "stylua",
          "terraform-ls",
          "trivy",
          "typescript-language-server",
          "yaml-language-server",
          "yamlfmt",
        }
        if vim.fn.executable "go" == 1 then
          table.insert(name_table, "hyprls")
        end
        return name_table
      end

      M.ensure_installed_mason_names = M.get_all_ensure_installed_mason_names()

      M.options = {
        PATH = "skip",
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = " ",
          },
        },
        max_concurrent_installers = 10,
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      }

      return M
    end,
    config = function(_, opts)
      require("mason").setup(opts.options)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed_mason_names and #opts.ensure_installed_mason_names > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed_mason_names, " "))
        end
      end, {})
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    priority = 1000,
    event = "VeryLazy",
    keys = function()
      local show_diagnostics = true
      return {
        {
          "<leader>ldt",
          function()
            show_diagnostics = not show_diagnostics
            if show_diagnostics then
              require("tiny-inline-diagnostic").enable()
            else
              require("tiny-inline-diagnostic").disable()
            end
          end,
          desc = "Diagnostics Toggle virtual text",
        },
        {
          "<leader>ldd",
          function()
            vim.diagnostic.config { virtual_text = false }
          end,
          desc = "Diagnostics Force disable virtual text diagnostics",
        },
      }
    end,
    opts = {
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        multilines = {
          enabled = true,
          always_show = true,
        },
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      vim.schedule(function()
        vim.diagnostic.config { virtual_text = false }
      end)
      require("colors").add_and_set_color_module("tiny-inline-diagnostic", function()
        local config = require("tiny-inline-diagnostic").config
        require("tiny-inline-diagnostic.highlights").setup_highlights(
          config.blend,
          config.hi,
          config.transparent_bg,
          config.transparent_cursorline
        )
        vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextHint", {
          fg = "#94e2d5",
          bg = "#384953",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextHint", {
          fg = "#384953",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextHintNoBg", {
          fg = "#384953",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextInfo", {
          fg = "#89dceb",
          bg = "#364858",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextInfo", {
          fg = "#364858",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextInfoNoBg", {
          fg = "#364858",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextWarn", {
          fg = "#f9e2af",
          bg = "#4e494a",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextWarn", {
          fg = "#4e494a",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextWarnNoBg", {
          fg = "#4e494a",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextError", {
          fg = "#f38ba8",
          bg = "#4d3649",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextError", {
          fg = "#4d3649",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineInvDiagnosticVirtualTextErrorNoBg", {
          fg = "#4d3649",
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextArrow", {
          fg = "#6c7086",
          bg = "NONE",
        })
      end)
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    keys = {
      {
        "<leader>lsh",
        function()
          require("lsp_signature").toggle_float_win()
        end,
        desc = "Lsp Toggle signature help",
      },
      {
        "<C-h>",
        function()
          require("lsp_signature").toggle_float_win()
        end,
        mode = "i",
        desc = "Lsp Toggle signature help (i)",
      },
    },
    opts = {
      bind = true,
      hint_prefix = "",
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
      require("colors").add_and_set_color_module("lsp_signature", function()
        vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
          bg = "#45475a",
          bold = true,
        })
      end)
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>lR",
        ":IncRename ",
        desc = "Lsp IncRename",
      },
    },
    opts = {
      save_in_cmdline_history = false,
    },
  },
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    ft = { "oil" },
    opts = {},
  },
}
