return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g", "\\" },
    cmd = "WhichKey",
    config = function()
      dofile(vim.g.base46_cache .. "whichkey")
      local opts = require "configs.which-key"
      require("which-key").setup(opts)

      local map = vim.keymap.set
      map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey All keymaps" })
      map("n", "<leader>wk", function()
        vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
      end, { desc = "Whichkey Query lookup" })
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
    config = function()
      local map = vim.keymap.set
      map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Window Go to window left (with tmux)" })
      map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Window Go to window right (with tmux)" })
      map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Window Go to window up (with tmux)" })
      map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Window Go to Window down (with tmux)" })
    end,
  },
  {
    "abecodes/tabout.nvim",
    lazy = false,
    config = function()
      require("tabout").setup {
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = false, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          -- { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      }
    end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip",
      "hrsh7th/nvim-cmp",
    },
    opt = true, -- Set this to true if the plugin is optional
    event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },
  {
    "kwkarlwang/bufjump.nvim",
    config = function()
      require("bufjump").setup {
        forward_key = "<C-n>",
        backward_key = "<C-p>",
        forward_same_buf_key = "<M-i>",
        backward_same_buf_key = "<M-o>",
        on_success = nil,
      }
    end,
  },
}
