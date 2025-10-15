return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    keys = {
      { "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Git Reset Hunk" },
      { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git Preview Hunk" },
      { "<leader>ghn", "<cmd>Gitsigns next_hunk<CR>", desc = "Git Blame Next Hunk" },
      { "<leader>ghN", "<cmd>Gitsigns prev_hunk<CR>", desc = "Git Blame Previous Hunk" },
      { "<leader>gbl", "<cmd>Gitsigns blame_line<CR>", desc = "Git Blame Line" },
      { "<leader>gbc", "<cmd>Gitsigns blame<CR>", desc = "Git Blame Current Buffer" },
    },
    opts = {
      preview_config = {
        border = "rounded",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFocusFiles", "DiffviewToggleFiles", "DiffviewFileHistory" },
    config = function()
      vim.opt.fillchars:append { diff = "╱" }
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPost",
    keys = {
      { "<leader>cn", "<cmd>GitConflictNextConflict<CR>", desc = "Git Conflict Next" },
      { "<leader>cp", "<cmd>GitConflictPrevConflict<CR>", desc = "Git Conflict Prev" },
      { "<leader>co", "<cmd>GitConflictChooseOurs<CR>", desc = "Git Conflict Choose Ours" },
      { "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", desc = "Git Conflict Choose Theirs" },
      { "<leader>cb", "<cmd>GitConflictChooseBoth<CR>", desc = "Git Conflict Choose Both" },
      { "<leader>cl", "<cmd>GitConflictListQf<CR>", desc = "Git Conflict List" },
    },
    opts = {
      default_mappings = false,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    ft = { "oil" },
    opts = {},
  },
  {
    "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    keys = {
      { "<leader>Oa", "<cmd>Octo actions<CR>", desc = "Octo Actions" },
      { "<leader>Opl", "<cmd>Octo pr list<CR>", desc = "Octo PR list" },
      { "<leader>Opc", "<cmd>Octo pr checkout<CR>", desc = "Octo PR checkout" },
      { "<leader>Opo", "<cmd>Octo pr browse<CR>", desc = "Octo PR open for current branch" },
      { "<leader>OpO", "<cmd>Octo pr browser<CR>", desc = "Octo PR open for current branch in browser" },
      { "<leader>Ors", "<cmd>Octo review start<CR>", desc = "Octo Review start" },
      { "<leader>Orr", "<cmd>Octo review resume<CR>", desc = "Octo Review resume" },
      { "<leader>Orq", "<cmd>Octo review close<CR>", desc = "Octo Review quit/close" },
      { "<leader>Orc", "<cmd>Octo review commit<CR>", desc = "Octo Review commit" },
      { "<leader>Ord", "<cmd>Octo review discard<CR>", desc = "Octo Review discard" },
    },
    opts = {
      mappings_disable_default = false,
      mappings = {
        review_diff = {
          next_thread = { lhs = "]T", desc = "Octo Review move to next thread" },
          prev_thread = { lhs = "[T", desc = "Octo Review move to previous thread" },
        },
      },
    },
    config = function(_, opts)
      require("octo").setup(opts)
      require("colors").add_and_set_color_module("octo", function()
        vim.api.nvim_set_hl(0, "OctoFilePanelSelectedFile", {
          fg = "#f9e2b0",
          bg = "#45475b",
        })
      end)
    end,
  },
}
