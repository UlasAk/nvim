-- Highlight current search item with different color than other search items
vim.cmd [[
  hi CurSearch guifg=#282737 guibg=#ff0000 
]]
-- Change Visual Mode Background Color to see more on transparent background
vim.schedule(function()
  vim.cmd [[
  hi Visual guibg=#76758a
]]
end)
-- Text color of commented out text
vim.cmd [[
  hi Comment guifg=#8886a6
]]
vim.cmd [[
  hi @comment guifg=#8886a6
]]
