local setup_colors = function()
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

local options = {
  bigfile = { enabled = false },
  quickfile = { enabled = false },
  statuscolumn = { enabled = false },
  styles = {
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
  },
  notifier = {
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
    style = "fancy",
    top_down = true, -- place notifications from top to bottom
    date_format = "%R", -- time format for notifications
    refresh = 50, -- refresh at most every 50ms
  },
  image = {},
  scroll = {
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
  },
  toggle = {},
  input = {
    enabled = false,
  },
  words = {
    debounce = 100, -- time in ms to wait before updating
    notify_jump = false, -- show a notification when jumping
    notify_end = true, -- show a notification when reaching the end
    foldopen = true, -- open folds after jumping
    jumplist = true, -- set jump point before jumping
    modes = { "n", "i", "c" }, -- modes to show references
    filter = function(buf) -- what buffers to enable `snacks.words`
      return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
  },
  dashboard = {
    sections = {
      { section = "header" },
      { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      { section = "startup" },
    },
  },
}

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>dn",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Notifications Dismiss notifications",
      },
      {
        "<leader>fn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notifications Show history",
      },
      {
        "<leader>x",
        function()
          Snacks.bufdelete()
        end,
        desc = "Buffer Close",
      },
      {
        "<leader>ba",
        function()
          Snacks.bufdelete.all()
        end,
        desc = "Buffer Close all",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Buffer Close others",
      },
      {
        "<leader>si",
        function()
          Snacks.image.hover()
        end,
        desc = "Image Show Image (Hover)",
      },
      {
        "<leader>ta",
        function()
          Snacks.toggle.animate()
        end,
        desc = "Toggle Animations",
      },
      {
        "<leader>tw",
        function()
          local is_enabled = Snacks.words.is_enabled()
          if is_enabled then
            Snacks.words.disable()
            Snacks.notify.info "  Snacks.words disabled"
          else
            Snacks.words.enable()
            Snacks.notify.info "  Snacks.words enabled"
          end
        end,
        desc = "Toggle Words (LSP reference highlighting)",
      },
      {
        "<leader>ts",
        function()
          local is_enabled = Snacks.scroll.enabled
          if is_enabled then
            Snacks.scroll.disable()
            Snacks.notify.info "  Scroll animations disabled"
          else
            Snacks.scroll.enable()
            Snacks.notify.info "  Scroll animations enabled"
          end
        end,
        desc = "Toggle Scroll Animations",
      },
    },
    opts = function()
      return options
    end,
    init = function()
      setup_colors()

      -- Setup LSP Progress autocmd
      -- -@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      -- local progress = vim.defaulttable()
      -- vim.api.nvim_create_autocmd("LspProgress", {
      --   ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      --   callback = function(ev)
      --     local client = vim.lsp.get_client_by_id(ev.data.client_id)
      --     local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
      --     if not client or type(value) ~= "table" then
      --       return
      --     end
      --     local p = progress[client.id]
      --
      --     for i = 1, #p + 1 do
      --       if i == #p + 1 or p[i].token == ev.data.params.token then
      --         p[i] = {
      --           token = ev.data.params.token,
      --           msg = ("[%3d%%] %s%s"):format(
      --             value.kind == "end" and 100 or value.percentage or 100,
      --             value.title or "",
      --             value.message and (" **%s**"):format(value.message) or ""
      --           ),
      --           done = value.kind == "end",
      --         }
      --         break
      --       end
      --     end
      --
      --     local msg = {} ---@type string[]
      --     progress[client.id] = vim.tbl_filter(function(v)
      --       return table.insert(msg, v.msg) or not v.done
      --     end, p)
      --
      --     local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      --     vim.notify(table.concat(msg, "\n"), "info", {
      --       id = "lsp_progress",
      --       title = client.name,
      --       opts = function(notif)
      --         notif.icon = #progress[client.id] == 0 and " "
      --           or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      --       end,
      --     })
      --   end,
      -- })
    end,
  },
}
