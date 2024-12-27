local map = vim.keymap.set

-- Jump
map("i", "<C-b>", "<ESC>^i", { desc = "Jump Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Jump End of line" })
map("i", "<C-h>", "<Left>", { desc = "Jump Left" })
map("i", "<C-l>", "<Right>", { desc = "Jump Right" })
map("i", "<C-j>", "<Down>", { desc = "Jump Down" })
map("i", "<C-k>", "<Up>", { desc = "Jump Up" })
map("n", "<C-o>", "<C-i>", { desc = "Jump Forward in Jumplist" })
map("n", "<C-m>", "<C-o>", { desc = "Jump Backwards in Jumplist" })

--Move lines
map({ "n", "i" }, "<M-Up>", "<cmd> m-2<CR>", { desc = "Editing Move line up" })
map({ "n", "i" }, "<M-Down>", "<cmd> m+1<CR>", { desc = "Editing Move line down" })
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", { desc = "Editing Move lines up", noremap = true, silent = true })
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", { desc = "Editing Move lines down", noremap = true, silent = true })
map({ "n", "i" }, "<M-k>", "<cmd> m-2<CR>", { desc = "Editing Move line up" })
map({ "n", "i" }, "<M-j>", "<cmd> m+1<CR>", { desc = "Editing Move line down" })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Editing Move lines up", noremap = true, silent = true })
map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Editing Move lines down", noremap = true, silent = true })

-- Highlights
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<C-a>", "ggVG<CR>", { desc = "Highlight Highlight all" })

-- Window operations
map("n", "<leader>sh", "<cmd> split<CR>", { desc = "Window Split Window horizontally" })
map("n", "<leader>sv", "<cmd> vsplit<CR>", { desc = "Window Split Window vertically" })
map("n", "<C-#>", "<cmd> vertical resize +1<CR>", { desc = "Window Increase width" })
map("n", "<C-ö>", "<cmd> vertical resize -1<CR>", { desc = "Window Decrease width" })
map("n", "<C-ü>", "<cmd> resize +1<CR>", { desc = "Window Increase height" })
map("n", "<C-ä>", "<cmd> resize -1<CR>", { desc = "Window Decrease height" })

-- File operations
map("n", "<C-s>", "<cmd>w<CR>", { desc = "General Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "General Copy whole file" })

-- Line numbers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Diagnostics
map("n", "<leader>ldf", vim.diagnostic.open_float, { desc = "Diagnostics Floating diagnostics" })
map("n", "<leader>ldp", vim.diagnostic.goto_prev, { desc = "Diagnostics Prev diagnostic" })
map("n", "<leader>ldn", vim.diagnostic.goto_next, { desc = "Diagnostics Next diagnostic" })
map("n", "<leader>ldl", vim.diagnostic.setloclist, { desc = "Diagnostics Diagnostic loclist" })

-- Buffer
-- map("n", "<C-K>", "<C-y>", { desc = "Buffer Scroll up one line", noremap = true })
-- map("n", "<C-J>", "<C-e>", { desc = "Buffer Scroll down one line", noremap = true })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape terminal mode" })
