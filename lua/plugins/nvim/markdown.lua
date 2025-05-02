return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    cmd = { "RenderMarkdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
    },
  },
  {
    "OXY2DEV/markview.nvim",
    -- lazy = false,
    ft = "markdown",
    opts = {
      markdown = { code_blocks = {
        label_direction = "left",
      } },
    },
    config = function(_, opts)
      require("markview").setup(opts)
      require("markview.extras.checkboxes").setup {
        --- Default checkbox state(used when adding checkboxes).
        ---@type string
        default = "X",

        --- Changes how checkboxes are removed.
        ---@type
        ---| "disable" Disables the checkbox.
        ---| "checkbox" Removes the checkbox.
        ---| "list_item" Removes the list item markers too.
        remove_style = "disable",

        --- Various checkbox states.
        ---
        --- States are in sets to quickly change between them
        --- when there are a lot of states.
        ---@type string[][]
        states = {
          { " ", "/", "X" },
          { "<", ">" },
          { "?", "!", "*" },
          { '"' },
          { "l", "b", "i" },
          { "S", "I" },
          { "p", "c" },
          { "f", "k", "w" },
          { "u", "d" },
        },
      }
      require("markview.extras.headings").setup()
      require("markview.extras.editor").setup()
    end,
  },
}
