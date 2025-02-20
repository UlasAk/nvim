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

-- Change Noice Mini Background Color (where LSP Progress is shown)
vim.cmd "hi NoiceMini guifg=#282737 guibg=#1E1E2E"
vim.cmd "hi NoiceVirtualText guifg=#fdfd96"

return options
