local M = {}

vim.g.disable_autoformat = false

M.filetypes = {
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

M.options = {
  formatters_by_ft = M.filetypes,
  formatters = {
    dart_format = {
      args = function()
        local args_table = { "format" }
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
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { lsp_fallback = true }
  end,
}

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

return M
