-- require("nvchad.mappings")
local map = vim.keymap.set

-- NVCHAD mappings =====================================================================
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "General Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "General Copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "Toggle nvcheatsheet" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "General Format file" })

-- global lsp mappings
map("n", "<leader>ldf", vim.diagnostic.open_float, { desc = "LSP floating diagnostics" })
map("n", "<leader>ldp", vim.diagnostic.goto_prev, { desc = "LSP prev diagnostic" })
map("n", "<leader>ldn", vim.diagnostic.goto_next, { desc = "LSP next diagnostic" })
map("n", "<leader>ldl", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "Buffer New" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })

-- Comment
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment toggle" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "comment toggle" }
)

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Nvimtree Focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help page" })
-- map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Telescope pick hidden term" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "Telescope Nvchad themes" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "Terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "Terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "Terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Terminal new horizontal term" })

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

-- Buffer
-- map("n", "<C-K>", "<C-y>", { desc = "Buffer Scroll up one line", noremap = true })
-- map("n", "<C-J>", "<C-e>", { desc = "Buffer Scroll down one line", noremap = true })

-- Tmux navigation
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "tmux Window left (with tmux)" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "tmux Window right (with tmux)" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "tmux Window up (with tmux)" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "tmux Window down (with tmux)" })

-- Window
map("n", "<leader>sh", "<cmd> split<CR>", { desc = "Window Split Window horizontally" })
map("n", "<leader>sv", "<cmd> vsplit<CR>", { desc = "Window Split Window vertically" })
map("n", "<leader>q", function()
  require("volt").close()
end, { desc = "Window Close Volt windows" })

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
map("n", "<leader>fmsg", "<cmd>Noice telescope<CR>", { desc = "Telescope Find Messages" })
map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Telescope Find TODOs" })
map("n", "<leader>fco", "<cmd>Telescope commands<CR>", { desc = "Telescope Commands" })
map("n", "<leader>fch", "<cmd>Telescope command_history<CR>", { desc = "Telescope Command history" })
map("n", "<leader>fv", "<cmd>Telescope vim_options<CR>", { desc = "Telescope Vim Options" })
map("n", "<leader>fs", "<cmd>Telescope treesitter<CR>", { desc = "Telescope Symbols" })
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Telescope Resume last search" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Telescope Keymaps: Normal" })
map("n", "<leader>fma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
map({ "n", "v" }, "<leader>fg", "<cmd>Telescope grep_string<CR>", { desc = "Telescope Grep String" })
map("n", "<leader>fme", "<cmd>Telescope media_files<CR>", { desc = "Telescope Find Media" })
map("v", "<leader>fz", function()
  local saved_reg = vim.fn.getreg "v"
  vim.cmd [[noautocmd sil norm! "vy]]
  local selection = vim.fn.getreg "v"
  vim.fn.setreg("v", saved_reg)
  if selection == nil then
    return nil
  end
  require("telescope.builtin").current_buffer_fuzzy_find {
    default_text = selection,
  }
end, { desc = "telescope find in current buffer" })

-- Noice
map("n", "<leader>dm", "<cmd>Noice dismiss<CR>", { desc = "Noice Dismiss messages" })

-- Yazi
map("n", "<leader>o", function()
  require("yazi").yazi()
end, { desc = "Yazi Open" })
map("n", "<leader>cw", function()
  require("yazi").yazi(nil, vim.fn.getcwd())
end, { desc = "Yazi Open CWD" })

-- LSP
map("n", "<leader>lda", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Lsp All Diagnostics" })
map("n", "<leader>ldc", function()
  require("telescope.builtin").diagnostics { bufnr = 0 }
end, { desc = "Lsp Diagnostics Current Buf" })

-- Crates
map("n", "<leader>rcu", function()
  require("crates").upgrade_all_crates()
end, { desc = "Update crates" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Zen Mode
map("n", "<leader>Z", "<cmd>ZenMode<CR>", { desc = "Zen Toggle Zen Mode" })

-- Menu
map("n", "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'

  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { mouse = true })
end, {})

-- Color pickers Hue and Shades
map("n", "<leader>pch", function()
  require("volt").close()
  require("minty.huefy").open()
end, { desc = "Colors Show Hue picker" })
map("n", "<leader>pcs", function()
  require("volt").close()
  require("minty.shades").open()
end, { desc = "Colors Show Shades picker" })
