-- Specify commands for each filetype to run
local filetype_cmds = {
  javascript = "node",
  python = "python3",
}

return function()
  local file = vim.fn.expand "%"
  return filetype_cmds[vim.bo.ft] .. " " .. file
end
