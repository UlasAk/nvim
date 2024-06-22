-- require("nvchad.mappings")
local map = vim.keymap.set

-- NVCHAD mappings =====================================================================
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "file save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format files" })

-- global lsp mappings
map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "lsp floating diagnostics" })
map("n", "<leader>[d", vim.diagnostic.goto_prev, { desc = "lsp prev diagnostic" })
map("n", "<leader>]d", vim.diagnostic.goto_next, { desc = "lsp next diagnostic" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "comment toggle" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "comment toggle" }
)

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal new horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })
-- ===============================================================================================

-- CUSTOM mappings ===============================================================================

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- Tmux navigation
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "tmux Window left (with tmux)" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "tmux Window right (with tmux)" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "tmux Window up (with tmux)" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "tmux Window down (with tmux)" })

-- Window
map("n", "<leader>sh", "<cmd> split<CR>", { desc = "window Split Window horizontally" })
map("n", "<leader>sv", "<cmd> vsplit<CR>", { desc = "window Split Window vertically" })

--Move lines
map({ "n", "i" }, "<M-Up>", "<cmd> m-2<CR>", { desc = "Editing Move line up" })
map({ "n", "i" }, "<M-Down>", "<cmd> m+1<CR>", { desc = "Editing Move line down" })
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", { desc = "Editing Move lines up", noremap = true, silent = true })
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", { desc = "Editing Move lines down", noremap = true, silent = true })

-- Highlighting
map("n", "<C-a>", "ggVG<CR>", { desc = "Highlight Highlight all" })

-- Undotree
map("n", "<leader>u", "<cmd> UndotreeToggle<CR>", { desc = "Undotree Toggle" })

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

-- Telescope
map({ "n", "i" }, "<C-v>", function()
  require("telescope.builtin").registers()
end, { desc = "Telescope Registers" })
map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Telescope Find TODOs" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Telescope Commands" })
map("n", "<leader>fv", "<cmd>Telescope vim_options<CR>", { desc = "Telescope Vim Options" })
map("n", "<leader>fs", "<cmd>Telescope treesitter<CR>", { desc = "Telescope Symbols" })
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Telescope Resume last search" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Telescope Keymaps: Normal" })
map({ "n", "v" }, "<leader>fg", "<cmd>Telescope grep_string<CR>", { desc = "Telescope Grep String" })
map("n", "<leader>fp", "<cmd>Telescope media_files<CR>", { desc = "Telescope Find Media" })

-- Yazi
map("n", "<leader>o", function()
  require("yazi").yazi()
end, { desc = "Yazi Open" })
map("n", "<leader>cw", function()
  require("yazi").yazi(nil, vim.fn.getcwd())
end, { desc = "Yazi Open CWD" })

-- LSP
map("n", "<leader>lad", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Lsp All Diagnostics" })

-- Crates
map("n", "<leader>rcu", function()
  require("crates").upgrade_all_crates()
end, { desc = "Update crates" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Zen Mode
map("n", "<leader>Z", "<cmd>ZenMode<CR>", { desc = "Zen Toggle Zen Mode" })
