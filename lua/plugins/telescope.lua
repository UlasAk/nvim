return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)
      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end

      -- Change Noice Mini Background Color (where LSP Progress is shown)
      vim.cmd "hi TelescopeMatching guifg=#89b4fa guibg=#76758a"
      vim.cmd "hi TelescopeSelection guifg=#d9e0ee guibg=#5c5a82"
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = { "nvim-lua/popup.nvim" },
    cmd = "Telescope media_files",
    config = function()
      require("telescope").load_extension "media_files"
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "TodoTelescope",
    config = function()
      require("todo-comments").setup()
    end,
  },
}
