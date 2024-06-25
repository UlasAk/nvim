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
  commands = {
    history = {
      filter = {},
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
        warning = true,
        find = "angularls",
      },
      opts = { skip = true },
    },
  },
}

return options
