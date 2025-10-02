local M = {}
local api = vim.api

M.indexOf = function(table, value)
  for i, v in ipairs(table) do
    if v == value then
      return i
    end
  end
  return nil
end

return M
