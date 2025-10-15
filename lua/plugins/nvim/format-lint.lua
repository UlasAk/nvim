local formatter_filetype_map = {
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
  typescript = { "prettier" },
  yaml = { "yamlfmt" },
}

local linter_filetype_map = {
  lua = "luacheck",
  markdown = "markdownlint",
  sh = "shellcheck",
  dart = "trivy",
}

local get_linter_filetypes = function()
  local filetypes = {}
  for filetype, _ in pairs(linter_filetype_map) do
    table.insert(filetypes, filetype)
  end
  return filetypes
end

local get_filetype_linter_nvim_lint_map = function()
  local result = {}
  for filetype, linter_name_or_table in pairs(linter_filetype_map) do
    if type(linter_name_or_table) == "table" then
      local linters = {}
      for _, linter in pairs(linter_name_or_table) do
        table.insert(linters, linter)
      end
      result[filetype] = linters
    else
      result[filetype] = { linter_name_or_table }
    end
  end
  return result
end

return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    ft = function()
      local filetypes = {}
      for key, _ in pairs(formatter_filetype_map) do
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
        formatters_by_ft = formatter_filetype_map,
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
    ft = get_linter_filetypes(),
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = get_filetype_linter_nvim_lint_map()

      -- Linter configs
      lint.linters.luacheck = {
        cmd = "luacheck",
        stdin = true,
        args = {
          "--globals",
          "vim",
          "lvim",
          "reload",
          "Snacks",
          "--",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
          source = "luacheck",
        }),
      }

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
