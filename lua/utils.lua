local M = {}

M.indexOf = function(table, value)
  for i, v in ipairs(table) do
    if v == value then
      return i
    end
  end
  return nil
end

-- Normalize Windows paths to Unix style
M.normalize = function(path)
  return path:gsub("\\", "/")
end

-- Current project root
M.project_root = function()
  local cwd = vim.loop.fs_realpath(vim.loop.cwd())
  return cwd and M.normalize(cwd) or ""
end

-- Build a path relative to the current root, if possible
M.relative_path = function(path)
  local root = M.project_root()
  local p = M.normalize(path)
  if root ~= "" and p:sub(1, #root + 1) == root .. "/" then
    return p:sub(#root + 2)
  end
  return p
end

M.get_visual_selection = function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  if #lines == 0 then
    return ""
  end

  if #lines == 1 then
    lines[1] = lines[1]:sub(start_pos[3], end_pos[3])
  else
    lines[1] = lines[1]:sub(start_pos[3])
    lines[#lines] = lines[#lines]:sub(1, end_pos[3])
  end

  return table.concat(lines, "\n")
end

M.get_file_extension = function(path)
  return path:match "^.+%.(.+)$"
end

return M
