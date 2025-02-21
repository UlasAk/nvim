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
  enabled = true,
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
  filter = function(notification)
    local msg = notification.msg
    -- Hide Dart file close error notifications
    if string.match(msg, "LspDetach") ~= nil then
      return false
    end

    -- Hide package.json Fetching Packages message
    if string.match(msg, "| 󰇚 Fetching latest versions") ~= nil then
      return false
    end

    -- Hide OctoEditable related messages
    if string.match(msg, "OctoEditable") ~= nil then
      return false
    end
    return true
  end,
  keep = function(notif)
    if string.match(notif.msg, "Fetching latest versions") ~= nil then
      return false
    end
    return vim.fn.getcmdpos() > 0
  end,
  ---@type snacks.notifier.style
  style = "compact",
  top_down = true, -- place notifications from top to bottom
  date_format = "%R", -- time format for notifications
  refresh = 50, -- refresh at most every 50ms
}

---@class snacks.dashboard.Config
---@field sections snacks.dashboard.Section
---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
M.dashboard = {
  sections = {
    { section = "header" },
    { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    { section = "startup" },
  },
}

return M
