require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Tmux navigation
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "tmux Window left (with tmux)" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "tmux Window right (with tmux)" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "tmux Window up (with tmux)" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "tmux Window down (with tmux)" })

-- Window
map("n", "<leader>sh", "<cmd> split<CR>", { desc = "window Split Window horizontally" })
map("n", "<leader>sv", "<cmd> vsplit<CR>", { desc = "window Split Window vertically" })

--Move lines
map("n", "<M-Up>", "<cmd> m-2<CR>", { desc = "Editing Move line up" })
map("n", "<M-Down>", "<cmd> m+1<CR>", { desc = "Editing Move line down" })

-- M.dap = {
--   ["<leader>db"] = {
--     "<cmd> DapToggleBreakpoint <CR>",
--     "Toggle Breakpoint"
--   },
--   ["<leader>dus"] = {
--     function ()
--       local widgets = require('dap.ui.widgets');
--       local sidebar = widgets.sidebar(widgets.scopes);
--       sidebar.open();
--     end,
--     "Open debugging sidebar"
--   }
-- }

-- Crates
map("n", "<leader>rcu", function()
  require("crates").upgrade_all_crates()
end, { desc = "Update crates" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
