return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    init = function()
      dofile(vim.g.base46_cache .. "devicons")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTree Toggle window" },
      { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "NvimTree Focus window" },
    },
    opts = function()
      return require "configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts.options)
      opts.setup_colors()
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>o",
        function()
          require("yazi").yazi()
        end,
        desc = "Yazi Open",
      },
      {
        "<leader>cw",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Yazi Open CWD",
      },
      {
        "<c-Up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Yazi Resume last session",
      },
    },
    ---@type YaziConfig
    opts = {
      open_for_directories = false,
      open_multiple_tabs = true,
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Oil Open parent directory" },
    },
    opts = function()
      return require "configs.oil"
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      {
        "<leader>S",
        function()
          require("spectre").toggle()
        end,
        desc = "Spectre Toggle",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual { select_word = true }
        end,
        desc = "Spectre Search current word",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual {}
        end,
        mode = "v",
        desc = "Spectre Search current word",
      },
      {
        "<leader>sof",
        function()
          require("spectre").open_file_search { select_word = true }
        end,
        desc = "Spectre Search on current file",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>G",
        "<cmd>GrugFar<CR>",
        desc = "Open GrugFar",
      },
    },
    opts = {
      keymaps = {
        close = { n = "q" },
      },
    },
  },
}
