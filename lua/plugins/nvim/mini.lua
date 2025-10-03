return {
  {
    "echasnovski/mini.ai",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      custom_textobjects = nil,
      mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
        goto_left = "gh",
        goto_right = "gl",
      },
      n_lines = 50,
      search_method = "cover_or_next",
      silent = false,
    },
  },
}
