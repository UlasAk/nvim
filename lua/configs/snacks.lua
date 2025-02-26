local M = {}

M.setup_colors = function()
  vim.api.nvim_set_hl(0, "SnacksDashboardHeader", {
    fg = "#fdfd96",
  })
  vim.api.nvim_set_hl(0, "SnacksDashboardTitle", {
    fg = "#fdfd96",
  })
  vim.api.nvim_set_hl(0, "SnacksDashboardFooter", {
    fg = "#fdfd96",
  })
  vim.api.nvim_set_hl(0, "SnacksDashboardDir", {
    fg = "#8886a6",
  })
end

M.options = {
  bigfile = { enabled = false },
  quickfile = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
}

M.options.styles = {
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

M.options.notifier = {
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
  style = "compact",
  top_down = true, -- place notifications from top to bottom
  date_format = "%R", -- time format for notifications
  refresh = 50, -- refresh at most every 50ms
}

M.options.image = {}

M.options.scroll = {
  enabled = false,
  animate = {
    duration = { step = 15, total = 200 },
    easing = "linear",
  },
  -- faster animation when repeating scroll after delay
  animate_repeat = {
    delay = 10, -- delay in ms before using the repeat animation
    duration = { step = 1, total = 10 },
    easing = "linear",
  },
}

M.options.toggle = {}

M.options.input = {}

M.options.words = {
  debounce = 100, -- time in ms to wait before updating
  notify_jump = false, -- show a notification when jumping
  notify_end = true, -- show a notification when reaching the end
  foldopen = true, -- open folds after jumping
  jumplist = true, -- set jump point before jumping
  modes = { "n", "i", "c" }, -- modes to show references
  filter = function(buf) -- what buffers to enable `snacks.words`
    return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
  end,
}

M.options.dashboard = {
  sections = {
    { section = "header" },
    { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    { section = "startup" },
  },
}

return M
