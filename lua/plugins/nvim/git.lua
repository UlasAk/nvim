return {
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    keys = {
      { "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Git Reset Hunk" },
      { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git Preview Hunk" },
      { "<leader>ghn", "<cmd>Gitsigns next_hunk<CR>", desc = "Git Blame Next Hunk" },
      { "<leader>ghN", "<cmd>Gitsigns prev_hunk<CR>", desc = "Git Blame Previous Hunk" },
      { "<leader>gbl", "<cmd>Gitsigns blame_line<CR>", desc = "Git Blame Line" },
      { "<leader>gbc", "<cmd>Gitsigns blame<CR>", desc = "Git Blame Current Buffer" },
    },
    opts = function()
      dofile(vim.g.base46_cache .. "git")

      local options = {
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "󰍵" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "│" },
        },
        preview_config = {
          style = "minimal",
          relative = "cursor",
          border = "rounded",
        },

        on_attach = function(_)
          if
            require("lazy.core.config").plugins["zen-mode.nvim"]._.loaded ~= nil and require("zen-mode.view").is_open()
          then
            return false
          end
        end,
      }

      return options
    end,
    init = function()
      dofile(vim.g.base46_cache .. "git")
    end,
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
      default_mappings = false, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      list_opener = "copen", -- command or function to open the conflicts list
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lzg", "<cmd>LazyGit<cr>", desc = "Git LazyGit" },
    },
  },
  -- {
  --   "isakbm/gitgraph.nvim",
  --   dependencies = { "sindrets/diffview.nvim" },
  --   keys = {
  --     {
  --       "<leader>gg",
  --       function()
  --         require("gitgraph").draw({}, { all = true, max_count = 5000 })
  --       end,
  --       desc = "Git Graph",
  --     },
  --   },
  --   opts = {
  --     symbols = {
  --       merge_commit = "M",
  --       commit = "*",
  --     },
  --     format = {
  --       timestamp = "%H:%M:%S %d-%m-%Y",
  --       fields = { "hash", "timestamp", "author", "branch_name", "tag" },
  --     },
  --     hooks = {
  --       on_select_commit = function(commit)
  --         vim.notify("DiffviewOpen " .. commit.hash .. "^!")
  --         vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
  --       end,
  --       on_select_range_commit = function(from, to)
  --         vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
  --         vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
  --       end,
  --     },
  --   },
  -- },
}
