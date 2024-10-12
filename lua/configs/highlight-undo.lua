return {
  duration = 700,
  keymaps = {
    undo = {
      desc = "undo",
      hlgroup = "HighlightUndo",
      mode = "n",
      lhs = "u",
      opts = {},
    },
    redo = {
      desc = "redo",
      hlgroup = "HighlightRedo",
      mode = "n",
      lhs = "<C-r>",
      opts = {},
    },
    paste = {
      desc = "paste",
      hlgroup = "HighlightUndo",
      mode = "n",
      lhs = "p",
      rhs = "p",
      opts = {},
    },
    Paste = {
      desc = "Paste",
      hlgroup = "HighlightUndo",
      mode = "n",
      lhs = "P",
      rhs = "P",
      opts = {},
    },
  },
}
