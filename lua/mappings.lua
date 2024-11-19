local map = vim.keymap.set

-- Jump
map("i", "<C-b>", "<ESC>^i", { desc = "Jump Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Jump End of line" })
map("i", "<C-h>", "<Left>", { desc = "Jump Left" })
map("i", "<C-l>", "<Right>", { desc = "Jump Right" })
map("i", "<C-j>", "<Down>", { desc = "Jump Down" })
map("i", "<C-k>", "<Up>", { desc = "Jump Up" })
map("n", "<C-i>", "<C-i>", { desc = "Jump Forward in Jumplist" })

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
map("n", "<C-h>", "<C-w>h", { desc = "Window Go to window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window Go to window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window Go to window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window Go to window up" })
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Window Go to window left (with tmux)" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Window Go to window right (with tmux)" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Window Go to window up (with tmux)" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Window Go to Window down (with tmux)" })
map("n", "<leader>sh", "<cmd> split<CR>", { desc = "Window Split Window horizontally" })
map("n", "<leader>sv", "<cmd> vsplit<CR>", { desc = "Window Split Window vertically" })
map("n", "<leader>q", function()
  require("volt").close()
end, { desc = "Window Close all Volt windows" })

-- File operations
map("n", "<C-s>", "<cmd>w<CR>", { desc = "General Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "General Copy whole file" })
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "General Format file" })

-- Line numbers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Cheatsheet
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "Toggle Cheatsheet" })

-- Folds
map("n", "zR", require("ufo").openAllFolds, { desc = "Folds Open all folds" })
map("n", "zM", require("ufo").closeAllFolds, { desc = "Folds Close all folds" })
map("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Folds Open all folds" })
map("n", "zp", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  -- if not winid then
  --   -- vim.lsp.buf.hover()
  --   vim.cmd [[ Lspsaga hover_doc ]]
  -- end
end, { desc = "Folds Peek into fold" })

-- Diagnostics
map("n", "<leader>lda", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Diagnostics All Diagnostics" })
map("n", "<leader>ldc", function()
  require("telescope.builtin").diagnostics { bufnr = 0 }
end, { desc = "Diagnostics Diagnostics Current Buf" })
map("n", "<leader>ldf", vim.diagnostic.open_float, { desc = "Diagnostics Floating diagnostics" })
map("n", "<leader>ldp", vim.diagnostic.goto_prev, { desc = "Diagnostics Prev diagnostic" })
map("n", "<leader>ldn", vim.diagnostic.goto_next, { desc = "Diagnostics Next diagnostic" })
map("n", "<leader>ldl", vim.diagnostic.setloclist, { desc = "Diagnostics Diagnostic loclist" })
map("n", "<leader>ldt", function()
  local show_virtual_lines_now = require("lsp_lines").toggle()
  vim.diagnostic.config { virtual_text = not show_virtual_lines_now }
end, { desc = "Diagnostics Toggle virtual text" })

-- Goto-Preview
map("n", "<leader>lgpd", function()
  require("goto-preview").goto_preview_definition()
end, { desc = "Goto-Preview Go to definition (via popup)" })

-- Buffer
-- map("n", "<C-K>", "<C-y>", { desc = "Buffer Scroll up one line", noremap = true })
-- map("n", "<C-J>", "<C-e>", { desc = "Buffer Scroll down one line", noremap = true })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })
map("n", "<leader>ba", function()
  -- require("nvchad.tabufline").closeAllBufs(false)
  require("bufferline").close_others()
end, { desc = "Buffer Close all except for current" })
map("n", "<leader>bcl", function()
  -- require("nvchad.tabufline").closeBufs_at_direction "left"
  require("bufferline").close_in_direction "left"
end, { desc = "Buffer Close buffers to the left" })
map("n", "<leader>bcr", function()
  -- require("nvchad.tabufline").closeBufs_at_direction "right"
  require("bufferline").close_in_direction "right"
end, { desc = "Buffer Close buffers to the right" })
map("n", "<leader>bl", function()
  -- require("nvchad.tabufline").move_buf(-1)
  require("bufferline").move(-1)
end, { desc = "Buffer Move buffer to left" })
map("n", "<leader>br", function()
  -- require("nvchad.tabufline").move_buf(1)
  require("bufferline").move(1)
end, { desc = "Buffer Move buffer to right" })
-- map("n", "<tab>", function()
--   require("nvchad.tabufline").next()
--   -- require("bufferline").cycle(1)
-- end, { desc = "Buffer Goto next" })
-- map("n", "<S-tab>", function()
--   require("nvchad.tabufline").prev()
--   -- require("bufferline").cycle(-1)
-- end, { desc = "Buffer Goto prev" })
map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Buffer Goto next", noremap = true })
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Buffer Goto prev" })
map("n", "<leader>x", function()
  -- require("nvchad.tabufline").close_buffer()
  require("utils").close_buffer()
  require("bufferline.ui").refresh()
end, { desc = "Buffer Close" })

-- Comment
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })
map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment Toggle" }
)

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree Toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "NvimTree Focus window" })

-- oil
map("n", "-", "<cmd>Oil<CR>", { desc = "Oil Open parent directory" })

-- Telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Buffers" })
map("n", "<leader>fhe", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Help page" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Oldfiles" })
map("n", "<leader><leader>", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Current Buffer" })
-- map("n", "<leader><leader>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Current Buffer" })
map("n", "<leader>fgc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
map("n", "<leader>fgt", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
map("n", "<leader>fte", "<cmd>Telescope terms<CR>", { desc = "Telescope Terminals" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope Files (all)" }
)
map("n", "<leader>fth", function()
  require("nvchad.themes").open { style = "flat", border = false }
end, { desc = "Telescope Themes (NVChad)" })
map("n", '<leader>f"', function()
  require("telescope.builtin").registers()
end, { desc = "Telescope Registers" })
map("n", "<leader>fmsg", "<cmd>Noice telescope<CR>", { desc = "Telescope Messages" })
map("n", "<leader>fto", "<cmd>TodoTelescope<CR>", { desc = "Telescope TODOs" })
map("n", "<leader>fco", "<cmd>Telescope commands<CR>", { desc = "Telescope Commands" })
map("n", "<leader>fch", "<cmd>Telescope command_history<CR>", { desc = "Telescope Command history" })
map("n", "<leader>fv", "<cmd>Telescope vim_options<CR>", { desc = "Telescope Vim Options" })
map("n", "<leader>fs", "<cmd>Telescope treesitter<CR>", { desc = "Telescope Symbols" })
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Telescope Resume last search" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Telescope Mappings" })
map("n", "<leader>fma", "<cmd>Telescope marks<CR>", { desc = "Telescope Marks" })
map({ "n", "v" }, "<leader>fgs", "<cmd>Telescope grep_string<CR>", { desc = "Telescope Grep String" })
map("n", "<leader>fme", "<cmd>Telescope media_files<CR>", { desc = "Telescope Media" })
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
end, { desc = "Telescope Current Buffer" })
map("n", "<leader>fhi", "<cmd>Telescope highlights<CR>", { desc = "Telescope Highlights" })

-- Search and Replace
map("n", "<leader>S", function()
  require("spectre").toggle()
end, { desc = "Spectre Toggle" })
map("n", "<leader>sw", function()
  require("spectre").open_visual { select_word = true }
end, { desc = "Spectre Search current word" })
map("v", "<leader>sw", function()
  require("spectre").open_visual {}
end, { desc = "Spectre Search current word" })
map("n", "<leader>sof", function()
  require("spectre").open_file_search { select_word = true }
end, { desc = "Spectre Search on current file" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape terminal mode" })
map("n", "<leader>th", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "Terminal New horizontal term" })
map("n", "<leader>tv", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "Terminal New vertical window" })
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "Terminal Toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Terminal New horizontal term" })

map({ "n", "t" }, "<A-f>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle floating term" })

-- Whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey All keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "Whichkey Query lookup" })

-- Blankline
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
end, { desc = "Blankline Jump to current context" })

-- Undotree
map("n", "<leader>u", "<cmd> UndotreeToggle<CR>", { desc = "Undotree Toggle" })

-- Debugger
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

-- Noice
-- map("n", "<leader>dm", "<cmd>Noice dismiss<CR>", { desc = "Noice Dismiss messages" })

-- Snacks/Notifications
map("n", "<leader>dm", function()
  Snacks.notifier.hide()
end, { desc = "Notifications Dismiss messages" })
map("n", "<leader>fn", function()
  Snacks.notifier.show_history()
end, { desc = "Notifications Show history" })

-- Yazi
map("n", "<leader>o", function()
  require("yazi").yazi()
end, { desc = "Yazi Open" })
map("n", "<leader>cw", function()
  require("yazi").yazi(nil, vim.fn.getcwd())
end, { desc = "Yazi Open CWD" })

-- Crates
map("n", "<leader>rcu", function()
  require("crates").upgrade_all_crates()
end, { desc = "Update Crates" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Zen Mode
map("n", "<leader>Z", "<cmd>ZenMode<CR>", { desc = "Zen Toggle Zen Mode" })

-- Menu
map("n", "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'

  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { mouse = true })
end, { desc = "Menu Open Context menu" })

-- Color pickers Hue and Shades
map("n", "<leader>pch", function()
  require("volt").close()
  require("minty.huefy").open()
end, { desc = "Colors Show Hue picker" })
map("n", "<leader>pcs", function()
  require("volt").close()
  require("minty.shades").open()
end, { desc = "Colors Show Shades picker" })

-- Code runner
map("n", "<leader>rr", function()
  require("nvchad.term").runner {
    pos = "sp",
    id = "runner",
    clear_cmd = false,
    cmd = function()
      return require "configs.runner"()
    end,
  }
end, { desc = "Runner Run Current File" })

-- Harpoon
map("n", "<leader>ha", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon Add" })
-- map("n", "<C-h>", function()
--   require("harpoon"):list():select(1)
-- end)
-- map("n", "<C-t>", function()
--   require("harpoon"):list():select(2)
-- end)
-- map("n", "<C-n>", function()
--   require("harpoon"):list():select(3)
-- end)
-- map("n", "<C-s>", function()
--   require("harpoon"):list():select(4)
-- end)
map("n", "<leader>hp", function()
  require("harpoon"):list():prev()
end, { desc = "Harpoon Previous" })
map("n", "<leader>hn", function()
  require("harpoon"):list():next()
end, { desc = "Harpoon Next" })
map("n", "<leader>hl", function()
  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon List" })
map("n", "<leader>fha", function()
  local conf = require("telescope.config").values
  local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(file_paths, item.value)
    end

    local make_finder = function()
      local paths = {}

      for _, item in ipairs(harpoon_files.items) do
        table.insert(paths, item.value)
      end

      return require("telescope.finders").new_table {
        results = paths,
      }
    end

    require("telescope.pickers")
      .new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table {
          results = file_paths,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
        attach_mappings = function(prompt_buffer_number, local_map)
          -- The keymap you need
          local_map("i", "<c-d>", function()
            local state = require "telescope.actions.state"
            local selected_entry = state.get_selected_entry()
            local current_picker = state.get_current_picker(prompt_buffer_number)

            -- This is the line you need to remove the entry
            require("harpoon"):list():remove(selected_entry)
            current_picker:refresh(make_finder())
          end)

          return true
        end,
      })
      :find()
  end
  toggle_telescope(require("harpoon"):list())
end, { desc = "Telescope Harpoon" })

-- Persistence / Session
map("n", "<leader>ps", function()
  require("persistence").select()
end, { desc = "Persistence Select session" })
map("n", "<leader>pc", function()
  require("persistence").load()
end, { desc = "Persistence Load session for current directory" })
map("n", "<leader>pl", function()
  require("persistence").load { last = true }
end, { desc = "Persistence Load last session" })
map("n", "<leader>pq", function()
  require("persistence").stop()
end, { desc = "Persistence Stop persistence" })
