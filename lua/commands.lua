vim.api.nvim_create_user_command("ToggleTransparency", function()
  require("colors").toggle_transparency()
end, {})

vim.api.nvim_create_user_command("CopyRelativePath", function()
  local path = vim.fn.expand "%"
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '"')
end, {})

vim.api.nvim_create_user_command("CopyAbsolutePath", function()
  local path = vim.fn.expand "%:p"
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '"')
end, {})
