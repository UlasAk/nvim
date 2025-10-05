local map = vim.keymap.set

-- General
map("n", "<leader>q", "<cmd>q<CR>", { desc = "General Quit neovim" })
map("n", "<leader>Q", "<cmd>wqa<CR>", { desc = "General Save all and quit neovim" })

-- Lazy
map("n", "L", "<cmd>Lazy<CR>", { desc = "Lazy Open" })

-- Buffer
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })

-- Tabs
map("n", "<C-Tab>", "<cmd>tabnext<CR>", { desc = "Tab Next" })
map("n", "<C-S-Tab>", "<cmd>tabprevious<CR>", { desc = "Tab Previous" })

-- Jump
map("n", "<C-m>", "<C-i>zz", { desc = "Jump Backwards in Jumplist and center" })
map("n", "<C-o>", "<C-o>zz", { desc = "Jump Forwards in Jumplist and center" })
map("n", "<leader><leader>", "<cmd>e #<CR>", { desc = "Jump Last file" })
map("n", "<leader>S", "<cmd>vert sf #<CR>", { desc = "Jump Last file in split" })

-- Centering after scroll and search commands
map("n", "n", "nzz", { desc = "Search next and center" })
map("n", "N", "Nzz", { desc = "Search previous and center" })
map("n", "<c-d>", "<c-d>zz", { desc = "Scroll down and center" })
map("n", "<c-u>", "<c-u>zz", { desc = "Scroll up and center" })

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
map("n", "<leader>Wm", "<C-w>|<C-w>_", { desc = "Window Maximize" })
map("n", "<leader>We", "<C-w>=", { desc = "Window Equalize windows" })

-- File operations
map("n", "<leader>w", "<cmd>update<CR>", { desc = "General Copy whole file" })
map("n", "<leader>C", "<cmd>%y+<CR>", { desc = "General Copy whole file" })
map("n", "<leader>n", ":norm ", { desc = "General Start norm command" })
map("n", "<leader>r", ":%s///g<left><left><left>", { desc = "General Start substitute command" })

-- Line numbers
map("n", "<leader>tln", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>tlr", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Wrap
map("n", "<leader>tw", function()
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

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape terminal mode" })
