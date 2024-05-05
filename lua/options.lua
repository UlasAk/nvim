require "nvchad.options"

-- Syntax Highlighting for .conf files
vim.cmd [[
  au BufEnter,BufRead *.conf setf dosini
]]

-- Highlight current search item with different color than other search items
vim.cmd [[
  hi CurSearch guifg=#282737 guibg=#ff0000 
]]
