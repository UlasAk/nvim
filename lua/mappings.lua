local map = vim.keymap.set

-- General
map("n", "<leader>q", "<CMD>q<CR>", { desc = "General Close window" })
map("n", "<leader>Q", "<CMD>wqa<CR>", { desc = "General Save all and quit neovim" })

-- Lazy
map("n", "L", "<CMD>Lazy<CR>", { desc = "Lazy Open" })

-- Buffer
map("n", "<leader>bn", "<CMD>enew<CR>", { desc = "Buffer New" })

-- Tabs
map("n", "<C-Tab>", "<CMD>tabnext<CR>", { desc = "Tab Next" })
map("n", "<C-S-Tab>", "<CMD>tabprevious<CR>", { desc = "Tab Previous" })

-- Jump
map("n", "<C-i>", "<C-i>zz", { desc = "Jump Backwards in Jumplist and center" })
map("n", "<C-o>", "<C-o>zz", { desc = "Jump Forwards in Jumplist and center" })
map("n", "<leader>S", "<CMD>vert sf #<CR>", { desc = "Jump Last file in split" })

-- Centering after scroll and search commands
map("n", "n", "nzz", { desc = "Search next and center" })
map("n", "N", "Nzz", { desc = "Search previous and center" })
map("n", "<c-d>", "<c-d>zz", { desc = "Scroll down and center" })
map("n", "<c-u>", "<c-u>zz", { desc = "Scroll up and center" })

-- Move lines
map("i", "<M-k>", "<CMD> m-2<CR>", { desc = "Move Move line up" })
map("i", "<M-j>", "<CMD> m+1<CR>", { desc = "Move Move line down" })
map("i", "<M-h>", "<CMD><<CR>", { desc = "Move Move line left" })
map("i", "<M-l>", "<CMD>><CR>", { desc = "Move Move line right" })

-- Highlights
map("n", "<Esc>", "<CMD>noh<CR>", { desc = "General Clear all highlights" })
map("n", "<leader>a", "ggVG<CR>", { desc = "Highlight Highlight all" })

-- Window operations
map("n", "<leader>sh", "<CMD> split<CR>", { desc = "Window Split Window horizontally" })
map("n", "<leader>sv", "<CMD> vsplit<CR>", { desc = "Window Split Window vertically" })
map("n", "<leader>Wm", "<C-w>|<C-w>_", { desc = "Window Maximize" })
map("n", "<leader>We", "<C-w>=", { desc = "Window Equalize windows" })

-- File operations
map("n", "<leader>w", "<CMD>update<CR>", { desc = "General Copy whole file" })
map("n", "<leader>C", "<CMD>%y+<CR>", { desc = "General Copy whole file" })
map("n", "<leader>n", ":norm ", { desc = "General Start norm command" })
map("n", "<leader>r", ":%s///g<left><left><left>", { desc = "General Start substitute command" })

-- Line numbers
map("n", "<leader>tln", "<CMD>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>tlr", "<CMD>set rnu!<CR>", { desc = "Toggle Relative number" })

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
