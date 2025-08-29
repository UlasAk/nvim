return {
  -- {
  --   "echasnovski/mini.move",
  --   version = false,
  --   event = "BufReadPost",
  --   opts = {
  --     -- Module mappings. Use `''` (empty string) to disable one.
  --     mappings = {
  --       -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
  --       left = "<M-h>",
  --       right = "<M-l>",
  --       down = "<M-j>",
  --       up = "<M-k>",
  --
  --       -- Move current line in Normal mode
  --       line_left = "<M-h>",
  --       line_right = "<M-l>",
  --       line_down = "<M-j>",
  --       line_up = "<M-k>",
  --     },
  --
  --     -- Options which control moving behavior
  --     options = {
  --       -- Automatically reindent selection during linewise vertical move
  --       reindent_linewise = true,
  --     },
  --   },
  -- },
  {
    "fedepujol/move.nvim",
    keys = {
      -- Normal Mode
      { "<M-j>", "<cmd>MoveLine(1)<CR>", desc = "Move Line Up" },
      { "<M-k>", "<cmd>MoveLine(-1)<CR>", desc = "Move Line Down" },
      -- { "<A-h>", "<cmd>MoveHChar(-1)<CR>", desc = "Move Character Left" },
      -- { "<A-l>", "<cmd>MoveHChar(1)<CR>", desc = "Move Character Right" },
      { "<M-h>", "<cmd>MoveWord(-1)<CR>", mode = { "n" }, desc = "Move Word Left" },
      { "<M-l>", "<cmd>MoveWord(1)<CR>", mode = { "n" }, desc = "Move Word Right" },
      -- Visual Mode
      { "<M-j>", "<cmd>MoveBlock(1)<CR>", mode = { "v" }, desc = "Move Block Up" },
      { "<M-k>", "<cmd>MoveBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Down" },
      { "<M-h>", "<cmd>MoveHBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Left" },
      { "<M-l>", "<cmd>MoveHBlock(1)<CR>", mode = { "v" }, desc = "Move Block Right" },
    },
    opts = {
      line = {
        enable = true, -- Enables line movement
        indent = true, -- Toggles indentation
      },
      block = {
        enable = true, -- Enables block movement
        indent = true, -- Toggles indentation
      },
      word = {
        enable = true, -- Enables word movement
      },
      char = {
        enable = false, -- Enables char movement
      },
    },
  },
}
