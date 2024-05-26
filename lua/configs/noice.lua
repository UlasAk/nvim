local options = {
  cmdline = {
    enabled = true,
  },
  notify = {
    enabled = true,
  },
  popupmenu = {
    enabled = true,
    backend = "cmp",
  },
  lsp = {
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "Code actions:",
      },
      opts = { replace = false },
    },
    {
      filter = {
        event = "msg_show",
        warning = true,
        kind = "",
        find = "autotag",
      },
      opts = { skip = true },
    },
  },
}

return options
