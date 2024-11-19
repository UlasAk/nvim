local M = {
  bigfile = { enabled = false },
  quickfile = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
}

M.styles = {
  notification = {
    border = "rounded",
    zindex = 100,
    ft = "markdown",
    wo = {
      winblend = 5,
      wrap = false,
      conceallevel = 2,
      colorcolumn = "",
    },
    bo = { filetype = "snacks_notif" },
    history = {
      border = "rounded",
      zindex = 100,
      width = 0.6,
      height = 0.6,
      minimal = false,
      title = "Notification History",
      title_pos = "center",
      ft = "markdown",
      bo = { filetype = "snacks_notif_history" },
      wo = { winhighlight = "Normal:SnacksNotifierHistory" },
      keys = { q = "close" },
    },
  },
}

---@class snacks.notifier.Config
---@field keep? fun(notif: snacks.notifier.Notif): boolean # global keep function
M.notifier = {
  {
    timeout = 3000, -- default timeout in ms
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    -- editor margin to keep free. tabline and statusline are taken into account automatically
    margin = { top = 0, right = 1, bottom = 0 },
    padding = true, -- add 1 cell of left/right padding to the notification window
    sort = { "level", "added" }, -- sort by level and time
    -- minimum log level to display. TRACE is the lowest
    -- all notifications are stored in history
    level = vim.log.levels.TRACE,
    icons = {
      error = " ",
      warn = " ",
      info = " ",
      debug = " ",
      trace = " ",
    },
    keep = function(notif)
      return vim.fn.getcmdpos() > 0
    end,
    ---@type snacks.notifier.style
    style = "compact",
    top_down = true, -- place notifications from top to bottom
    date_format = "%R", -- time format for notifications
    refresh = 50, -- refresh at most every 50ms
  },
}

---@class snacks.dashboard.Config
---@field sections snacks.dashboard.Section
---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
-- M.dashboard = {
--   width = 60,
--   row = nil, -- dashboard position. nil for center
--   col = nil, -- dashboard position. nil for center
--   pane_gap = 4, -- empty columns between vertical panes
--   autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
--   -- These settings are used by some built-in sections
--   preset = {
--     -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
--     ---@type fun(cmd:string, opts:table)|nil
--     pick = nil,
--     -- Used by the `keys` section to show keymaps.
--     -- Set your curstom keymaps here.
--     -- When using a function, the `items` argument are the default keymaps.
--     ---@type snacks.dashboard.Item[]
--     keys = {
--       { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
--       { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
--       { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
--       { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
--       {
--         icon = " ",
--         key = "c",
--         desc = "Config",
--         action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
--       },
--       { icon = " ", key = "s", desc = "Restore Session", section = "session" },
--       { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
--       { icon = " ", key = "q", desc = "Quit", action = ":qa" },
--     },
--     -- Used by the `header` section
--     header = [[
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
--   },
--   -- item field formatters
--   formats = {
--     icon = function(item)
--       if item.file and item.icon == "file" or item.icon == "directory" then
--         return M.icon(item.file, item.icon)
--       end
--       return { item.icon, width = 2, hl = "icon" }
--     end,
--     footer = { "%s", align = "center" },
--     header = { "%s", align = "center" },
--     file = function(item, ctx)
--       local fname = vim.fn.fnamemodify(item.file, ":~")
--       fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
--       local dir, file = fname:match "^(.*)/(.+)$"
--       return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
--     end,
--   },
--   sections = {
--     { section = "header" },
--     { section = "keys", gap = 1, padding = 1 },
--     { section = "startup" },
--   },
-- }

M.dashboard = {
  sections = {
    { section = "header" },
    { section = "keys", gap = 1 },
    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
    { section = "startup" },
  },
}

-- M.dashboard = {
--   sections = {
--     { section = "header" },
--     { section = "keys", gap = 1, padding = 1 },
--     { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
--     { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
--     {
--       pane = 1,
--       icon = " ",
--       title = "Git Status",
--       section = "terminal",
--       enabled = vim.fn.isdirectory ".git" == 1,
--       -- cmd = "hub status --short --branch --renames",
--       height = 5,
--       padding = 1,
--       ttl = 5 * 60,
--       indent = 3,
--     },
--     { section = "startup" },
--   },
-- }

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

return M
