local M = {}
local api = vim.api
local cur_buf = api.nvim_get_current_buf

local function buf_index(bufnr)
  for i, value in ipairs(vim.t.bufs) do
    if value == bufnr then
      return i
    end
  end
end

M.close_buffer = function(bufnr)
  bufnr = bufnr or cur_buf()

  if vim.bo[bufnr].buftype == "terminal" then
    vim.cmd(vim.bo.buflisted and "set nobl | enew" or "hide")
  else
    local curBufIndex = buf_index(bufnr)
    local bufhidden = vim.bo.bufhidden

    -- force close floating wins or nonbuflisted
    if api.nvim_win_get_config(0).zindex then
      vim.cmd "bw"
      return

      -- handle listed bufs
    elseif curBufIndex and #vim.t.bufs > 1 then
      local newBufIndex = curBufIndex == #vim.t.bufs and -1 or 1
      vim.cmd("b" .. vim.t.bufs[curBufIndex + newBufIndex])

      -- handle unlisted
    elseif not vim.bo.buflisted then
      local tmpbufnr = vim.t.bufs[1]
      api.nvim_set_current_win(vim.fn.bufwinid(bufnr))
      api.nvim_set_current_buf(tmpbufnr)
      vim.cmd("bw" .. bufnr)
      return
    else
      vim.cmd "enew"
    end

    if not (bufhidden == "delete") then
      vim.cmd("confirm bd" .. bufnr)
    end
  end

  vim.cmd "redrawtabline"
end

M.closeAllBufs = function(include_cur_buf)
  local bufs = vim.t.bufs

  if include_cur_buf ~= nil and not include_cur_buf then
    table.remove(bufs, buf_index(cur_buf()))
  end

  for _, buf in ipairs(bufs) do
    M.close_buffer(buf)
  end
end

return M
