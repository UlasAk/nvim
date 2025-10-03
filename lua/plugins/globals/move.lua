return {
  {
    "echasnovski/mini.move",
    version = false,
    event = "BufReadPost",
    opts = {
      mappings = {
        -- Visual Mode
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",
        -- Normal Mode
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
      options = {
        reindent_linewise = true,
      },
    },
  },
}
