return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      "<leader>",
      "<c-r>",
      "<c-w>",
      '"',
      "'",
      "`",
      "c",
      "v",
      "g",
      "\\",
      { "<leader>WK", "<cmd>WhichKey<CR>", desc = "Whichkey All keymaps" },
      {
        "<leader>Wk",
        function()
          vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
        end,
        desc = "Whichkey Query lookup",
      },
    },
    cmd = "WhichKey",
    opts = require "configs.which-key",
    init = function()
      dofile(vim.g.base46_cache .. "whichkey")
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
      { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>", desc = "Window Go to window left (with tmux)" },
      { "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>", desc = "Window Go to window down (with tmux)" },
      { "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>", desc = "Window Go to window up (with tmux)" },
      { "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>", desc = "Window Go to Window right (with tmux)" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>", desc = "Window Go to previous Window (with tmux)" },
    },
  },
  -- {
  --   "abecodes/tabout.nvim",
  --   dependencies = { -- These are optional
  --     "nvim-treesitter/nvim-treesitter",
  --     "L3MON4D3/LuaSnip",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
  --   opt = {
  --     tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
  --     backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
  --     act_as_tab = true, -- shift content if tab out is not possible
  --     act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
  --     default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
  --     default_shift_tab = "<C-d>", -- reverse shift default action,
  --     enable_backwards = true, -- well ...
  --     completion = false, -- if the tabkey is used in a completion pum
  --     tabouts = {
  --       { open = "'", close = "'" },
  --       { open = '"', close = '"' },
  --       { open = "`", close = "`" },
  --       { open = "(", close = ")" },
  --       { open = "[", close = "]" },
  --       -- { open = "{", close = "}" },
  --     },
  --     ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
  --     exclude = {}, -- tabout will ignore these filetypes
  --   }, -- Set this to true if the plugin is optional
  --   priority = 1000,
  -- },
  -- {
  --   "kwkarlwang/bufjump.nvim",
  --   config = function()
  --     require("bufjump").setup {
  --       forward_key = "<C-n>",
  --       backward_key = "<C-p>",
  --       forward_same_buf_key = "<M-i>",
  --       backward_same_buf_key = "<M-o>",
  --       on_success = nil,
  --     }
  --   end,
  -- },
}
