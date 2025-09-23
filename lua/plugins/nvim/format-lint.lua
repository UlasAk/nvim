local filetype_map = {
  bash = { "shfmt" },
  bib = { "texlab" },
  cs = { "csharpier" },
  dart = { "dart_format" },
  html = { "prettier" },
  htmlangular = { "prettier" },
  javascript = { "prettier" },
  json = {},
  lua = { "stylua" },
  sh = { "shfmt" },
  -- tex = { "latexindent" },
  typescript = { "prettier" },
  yaml = { "yamlfmt" },
}

return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    ft = function()
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
      {
        "<leader>tf",
        function()
          if vim.g.disable_autoformat then
            vim.g.disable_autoformat = false
          else
            vim.g.disable_autoformat = true
          end
          Snacks.notify((vim.g.disable_autoformat and "Disabled" or "Enabled"), { title = "Format on save" })
        end,
        desc = "Toggle Format on save",
      },
    },
    opts = function()
      vim.g.disable_autoformat = false
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "General Format disable on save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "General Format enable on save",
      })

      return {
        formatters_by_ft = filetype_map,
        formatters = {
          dart_format = {
            args = function()
              local args_table = { "format", "$FILENAME" }

              if string.match(vim.fn.expand "%:p", "projects") then
                local additional_args = { "-l", "120" }

                for _, arg in pairs(additional_args) do
                  table.insert(args_table, arg)
                end
              end

              return args_table
            end,
          },
        },
        format_after_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { lsp_format = "fallback" }
        end,
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = {
      "rachartier/tiny-inline-diagnostic.nvim",
    },
    ft = function()
      return require("mason-opts").get_linter_filetypes()
    end,
    config = function()
      local lint = require "lint"
      local mason_config = require "mason-opts"
      lint.linters_by_ft = mason_config.get_filetype_linter_nvim_lint_map()

      vim.schedule(function()
        vim.diagnostic.config { virtual_text = false }
      end)

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
