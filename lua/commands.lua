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

vim.api.nvim_create_user_command("CopySelectionAsMarkdown", function()
  local utils = require "utils"
  local sel = utils.get_visual_selection()
  if sel == "" then
    return vim.notify("No visual selection detected", vim.log.levels.WARN)
  end
  local path = vim.fn.expand "%:."

  local prefix = utils.get_file_extension(path) or ""
  local formatted = "# " .. utils.relative_path(path) .. "\n\n```" .. prefix .. "\n" .. sel .. "\n```\n"
  vim.fn.setreg("+", formatted)
  vim.notify("Copied visual selection from: " .. path, vim.log.levels.INFO)
end, { range = true })
