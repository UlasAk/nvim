local map = vim.keymap.set

-- Lazy
map("n", "L", "<cmd>Lazy<CR>", { desc = "Lazy Open" })

-- Buffer
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })

-- Jump
map("n", "<C-o>", "<C-i>", { desc = "Jump Forward in Jumplist" })
map("n", "<C-m>", "<C-o>", { desc = "Jump Backwards in Jumplist" })

-- Move lines
map("i", "<M-Up>", "<cmd> m-2<CR>", { desc = "Move Move line up" })
map("i", "<M-Down>", "<cmd> m+1<CR>", { desc = "Move Move line down" })
map("i", "<M-Left>", "<cmd><<CR>", { desc = "Move Move line left" })
map("i", "<M-Right>", "<cmd>><CR>", { desc = "Move Move line left" })

-- Highlights
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear all highlights" })
map("n", "<leader>a", "ggVG<CR>", { desc = "Highlight Highlight all" })

-- Window operations
map("n", "<leader>sh", "<cmd> split<CR>", { desc = "Window Split Window horizontally" })
map("n", "<leader>sv", "<cmd> vsplit<CR>", { desc = "Window Split Window vertically" })
map("n", "<C-M-Right>", "<cmd> vertical resize +10<CR>", { desc = "Window Increase width" })
map("n", "<C-M-Left>", "<cmd> vertical resize -10<CR>", { desc = "Window Decrease width" })
map("n", "<C-M-Up>", "<cmd> resize +5<CR>", { desc = "Window Increase height" })
map("n", "<C-M-Down>", "<cmd> resize -5<CR>", { desc = "Window Decrease height" })
map("n", "<leader>wm", "<C-w>|<C-w>_", { desc = "Window Maximize" })
map("n", "<leader>we", "<C-w>=", { desc = "Window Equalize windows" })

-- File operations
map("n", "<leader>C", "<cmd>%y+<CR>", { desc = "General Copy whole file" })

-- Line numbers
map("n", "<leader>tln", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>tlr", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Wrap
local wrap = true
map("n", "<leader>W", function()
  wrap = not wrap
  if wrap then
    vim.cmd "set wrap"
  else
    vim.cmd "set nowrap"
  end
end, { desc = "Toggle Wrap" })

-- Diagnostics
map("n", "<leader>ldf", vim.diagnostic.open_float, { desc = "Diagnostics Floating diagnostics" })
map("n", "<leader>ldp", function()
  vim.diagnostic.jump { count = -1 }
end, { desc = "Diagnostics Prev diagnostic" })
map("n", "<leader>ldn", function()
  vim.diagnostic.jump { count = 1 }
end, { desc = "Diagnostics Next diagnostic" })
map("n", "<leader>ldl", vim.diagnostic.setloclist, { desc = "Diagnostics Diagnostic loclist" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape terminal mode" })

-- Transparency
map("n", "<leader>tt", function()
  require("colors").toggle_transparency()
end, { desc = "Toggle Transparency" })
