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
