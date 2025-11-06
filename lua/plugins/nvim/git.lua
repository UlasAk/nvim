return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    keys = {
      { "<leader>ghr", "<CMD>Gitsigns reset_hunk<CR>", desc = "Git Reset Hunk" },
      { "<leader>ghp", "<CMD>Gitsigns preview_hunk<CR>", desc = "Git Preview Hunk" },
      { "<leader>ghn", "<CMD>Gitsigns next_hunk<CR>", desc = "Git Blame Next Hunk" },
      { "<leader>ghN", "<CMD>Gitsigns prev_hunk<CR>", desc = "Git Blame Previous Hunk" },
      { "<leader>gbl", "<CMD>Gitsigns blame_line<CR>", desc = "Git Blame Line" },
      { "<leader>gbc", "<CMD>Gitsigns blame<CR>", desc = "Git Blame Current Buffer" },
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
      { "<leader>cn", "<CMD>GitConflictNextConflict<CR>", desc = "Git Conflict Next" },
      { "<leader>cp", "<CMD>GitConflictPrevConflict<CR>", desc = "Git Conflict Prev" },
      { "<leader>co", "<CMD>GitConflictChooseOurs<CR>", desc = "Git Conflict Choose Ours" },
      { "<leader>ct", "<CMD>GitConflictChooseTheirs<CR>", desc = "Git Conflict Choose Theirs" },
      { "<leader>cb", "<CMD>GitConflictChooseBoth<CR>", desc = "Git Conflict Choose Both" },
      { "<leader>cl", "<CMD>GitConflictListQf<CR>", desc = "Git Conflict List" },
    },
    opts = {
      default_mappings = false,
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
      { "<leader>Oa", "<CMD>Octo actions<CR>", desc = "Octo Actions" },
      { "<leader>Opl", "<CMD>Octo pr list<CR>", desc = "Octo PR list" },
      { "<leader>Opc", "<CMD>Octo pr checkout<CR>", desc = "Octo PR checkout" },
      { "<leader>Opo", "<CMD>Octo pr browse<CR>", desc = "Octo PR open for current branch" },
      { "<leader>OpO", "<CMD>Octo pr browser<CR>", desc = "Octo PR open for current branch in browser" },
      { "<leader>Ors", "<CMD>Octo review start<CR>", desc = "Octo Review start" },
      { "<leader>Orr", "<CMD>Octo review resume<CR>", desc = "Octo Review resume" },
      { "<leader>Orq", "<CMD>Octo review close<CR>", desc = "Octo Review quit/close" },
      { "<leader>Orc", "<CMD>Octo review commit<CR>", desc = "Octo Review commit" },
      { "<leader>Ord", "<CMD>Octo review discard<CR>", desc = "Octo Review discard" },
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
        vim.api.nvim_set_hl(0, "OctoDiffstatAdditions", {
          link = "OctoGreen",
        })
        vim.api.nvim_set_hl(0, "OctoDiffstatDeletions", {
          link = "OctoRed",
        })
        vim.api.nvim_set_hl(0, "OctoDiffstatNeutral", {
          link = "OctoGrey",
        })
        vim.api.nvim_set_hl(0, "OctoStatusAdded", {
          link = "OctoGreen",
        })
        vim.api.nvim_set_hl(0, "OctoStatusUntracked", {
          link = "OctoGreen",
        })
        vim.api.nvim_set_hl(0, "OctoStatusModified", {
          link = "OctoBlue",
        })
        vim.api.nvim_set_hl(0, "OctoStatusRenamed", {
          link = "OctoBlue",
        })
        vim.api.nvim_set_hl(0, "OctoStatusCopied", {
          link = "OctoBlue",
        })
        vim.api.nvim_set_hl(0, "OctoStatusTypeChange", {
          link = "OctoBlue",
        })
        vim.api.nvim_set_hl(0, "OctoStatusUnmerged", {
          link = "OctoBlue",
        })
        vim.api.nvim_set_hl(0, "OctoStatusUnknown", {
          link = "OctoYellow",
        })
        vim.api.nvim_set_hl(0, "OctoStatusDeleted", {
          link = "OctoRed",
        })
        vim.api.nvim_set_hl(0, "OctoStatusBroken", {
          link = "OctoRed",
        })
      end)
    end,
  },
}
