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

local pause_notifications = false

local options = {
  bigfile = {
    notify = true,
    size = 1.5 * 1024 * 1024,
    line_length = 1000,
    ---@param ctx {buf: number, ft:string}
    setup = function(ctx)
      if vim.fn.exists ":NoMatchParen" ~= 0 then
        vim.cmd [[NoMatchParen]]
      end
      Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
      vim.b.minianimate_disable = true
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ctx.buf) then
          vim.bo[ctx.buf].syntax = ctx.ft
        end
      end)
    end,
  },
  quickfile = { enabled = false },
  statuscolumn = { enabled = false },
  styles = {
    input = {
      backdrop = false,
      position = "float",
      border = "rounded",
      title_pos = "center",
      height = 1,
      width = 60,
      relative = "editor",
      noautocmd = true,
      row = 2,
      wo = {
        winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
        cursorline = false,
      },
      bo = {
        filetype = "snacks_input",
        buftype = "prompt",
      },
      b = {
        completion = false,
      },
      keys = {
        n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
        i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
        i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
        i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
        i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
        i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
        i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
        q = "cancel",
      },
    },
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
      bo = { filetype = "markdown" },
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
    timeout = 3000,
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    margin = { top = 0, right = 1, bottom = 3 },
    padding = true,
    sort = { "level", "added" },
    level = vim.log.levels.TRACE,
    icons = {
      error = " ",
      warn = " ",
      info = " ",
      debug = " ",
      trace = " ",
    },
    filter = function(notification)
      if pause_notifications then
        return false
      end

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

      -- Hide lsp_signature related messages
      if string.match(msg, "lsp_signatur") ~= nil then
        return false
      end

      return true
    end,
    style = "fancy",
    top_down = false,
    date_format = "%R",
    refresh = 50,
  },
  scroll = {
    enabled = false,
    animate = {
      duration = { step = 15, total = 200 },
      easing = "linear",
    },
    animate_repeat = {
      delay = 10,
      duration = { step = 1, total = 10 },
      easing = "linear",
    },
  },
  toggle = {},
  input = {
    enabled = false,
  },
  words = {
    debounce = 100,
    notify_jump = false,
    notify_end = true,
    foldopen = true,
    jumplist = true,
    modes = { "n", "i", "c" },
    filter = function(buf)
      return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
  },
  dashboard = {
    sections = {
      { section = "header" },
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
        "<leader>fms",
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
        "<leader>tS",
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
      {
        "<leader>tn",
        function()
          pause_notifications = not pause_notifications
        end,
        desc = "Toggle Notifications",
      },
    },
    opts = function()
      return options
    end,
    init = function()
      setup_colors()
    end,
  },
}
