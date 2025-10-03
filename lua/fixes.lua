if vim.fn.has "win32" then
  local ori_fnameescape = vim.fn.fnameescape
  vim.fn.fnameescape = function(...)
    local result = ori_fnameescape(...)
    return result:gsub("\\", "/")
  end
end
