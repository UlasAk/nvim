local map = vim.keymap.set

-- Lazy
map("n", "L", "<cmd>Lazy<CR>", { desc = "Lazy Open" })

-- Buffer
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })

-- Tabs
map("n", "<C-Tab>", "<cmd>tabnext<CR>", { desc = "Tab Next" })
map("n", "<C-S-Tab>", "<cmd>tabprevious<CR>", { desc = "Tab Previous" })

-- Jump
-- map("n", "<C-o>", "<C-i>", { desc = "Jump Forward in Jumplist" })
map("n", "<C-m>", "<C-i>", { desc = "Jump Backwards in Jumplist" })

-- Move lines
map("i", "<M-k>", "<cmd> m-2<CR>", { desc = "Move Move line up" })
map("i", "<M-j>", "<cmd> m+1<CR>", { desc = "Move Move line down" })
map("i", "<M-h>", "<cmd><<CR>", { desc = "Move Move line left" })
map("i", "<M-l>", "<cmd>><CR>", { desc = "Move Move line right" })

-- Highlights
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear all highlights" })
map("n", "<leader>a", "ggVG<CR>", { desc = "Highlight Highlight all" })

-- Window operations
map("n", "<leader>sh", "<cmd> split<CR>", { desc = "Window Split Window horizontally" })
map("n", "<leader>sv", "<cmd> vsplit<CR>", { desc = "Window Split Window vertically" })
map("n", "<leader>wm", "<C-w>|<C-w>_", { desc = "Window Maximize" })
map("n", "<leader>we", "<C-w>=", { desc = "Window Equalize windows" })

-- File operations
map("n", "<leader>C", "<cmd>%y+<CR>", { desc = "General Copy whole file" })

-- Line numbers
map("n", "<leader>tln", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>tlr", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Wrap
map("n", "<leader>W", function()
  local wrap = vim.o.wrap
  if wrap then
    vim.o.wrap = false
    vim.o.linebreak = false
    map("n", "j", "j", { buffer = 0 })
    map("n", "k", "k", { buffer = 0 })
  else
    vim.o.wrap = true
    vim.o.linebreak = true
    map("n", "j", "gj", { buffer = 0 })
    map("n", "k", "gk", { buffer = 0 })
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
