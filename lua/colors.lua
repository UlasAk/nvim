local M = {
  transparent = true,
}

M.init_colors = function()
  vim.opt.termguicolors = true
  vim.schedule(function()
    -- Highlight current search item with different color than other search items
    vim.cmd [[
  hi CurSearch guifg=#282737 guibg=#ff0000 
]]
    -- Change Visual Mode Background Color to see more on transparent background
    vim.cmd [[
  hi Visual guibg=#76758a
]]
    -- Text color of commented out text
    vim.cmd [[
  hi Comment guifg=#8886a6
]]
    vim.cmd [[
  hi @comment guifg=#8886a6
]]
  end)
end

M.toggle_transparency = function()
  M.transparent = not M.transparent
  require("chadrc").base46.transparency = M.transparent
end

return M
