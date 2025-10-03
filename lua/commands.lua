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

vim.api.nvim_create_user_command("RegDiff", function(ctx)
  local reg1, reg2

  if #ctx.fargs == 0 then
    reg1, reg2 = "+", "*"
  elseif #ctx.fargs < 2 then
    vim.notify("Inusfficient number of registers supplied! Needs two.", vim.log.levels.ERROR, {})
    return
  else
    reg1, reg2 = ctx.fargs[1], ctx.fargs[2]
  end

  local reg1_lines = vim.fn.getreg(reg1, 0, true)
  local reg2_lines = vim.fn.getreg(reg2, 0, true)

  vim.cmd "tabnew"
  local reg1_bufnr = vim.api.nvim_get_current_buf()
  local reg1_name = vim.fn.tempname() .. "/Register " .. reg1
  vim.api.nvim_buf_set_name(0, reg1_name)
  vim.bo.buftype = "nofile"
  vim.api.nvim_buf_set_lines(reg1_bufnr, 0, -1, false, reg1_lines)

  vim.cmd "enew"
  local reg2_bufnr = vim.api.nvim_get_current_buf()
  local reg2_name = vim.fn.tempname() .. "/Register " .. reg2
  vim.api.nvim_buf_set_name(0, reg2_name)
  vim.bo.buftype = "nofile"
  vim.api.nvim_buf_set_lines(reg2_bufnr, 0, -1, false, reg2_lines)

  vim.cmd("aboveleft diffsplit " .. vim.fn.fnameescape(reg1_name))
  vim.cmd "wincmd p"
end, { bar = true, nargs = "*" })
