return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    -- cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    lazy = false,
    opts = function()
      return require "configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts.options)
      opts.setup_colors()

      local map = vim.keymap.set
      map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree Toggle window" })
      map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "NvimTree Focus window" })
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    ---@type YaziConfig
    opts = {
      open_for_directories = false,
    },
    config = function()
      local map = vim.keymap.set
      map("n", "<leader>o", function()
        require("yazi").yazi()
      end, { desc = "Yazi Open" })
      map("n", "<leader>cw", function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end, { desc = "Yazi Open CWD" })
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return require "configs.oil"
    end,
    config = function(_, opts)
      require("oil").setup(opts)

      local map = vim.keymap.set
      map("n", "-", "<cmd>Oil<CR>", { desc = "Oil Open parent directory" })
    end,
  },
}
