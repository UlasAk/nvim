local setup_colors = function()
  require("colors").add_and_set_color_module("snacks", function()
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
  end)
end

local pause_notifications = false

local options = {
  bigfile = {
    enabled = true,
  },
  quickfile = { enabled = false },
  statuscolumn = { enabled = false },
  styles = {
    input = {
      relative = "cursor",
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
      bo = { filetype = "markdown" },
    },
  },
  notifier = {
    enabled = true,
    margin = { top = 0, right = 1, bottom = 3 },
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
  },
  input = {
    enabled = true,
  },
  words = {
    enabled = true,
    debounce = 100,
  },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "startup" },
    },
  },
}

return {
  {
    "folke/snacks.nvim",
    dependencies = { "OXY2DEV/markview.nvim" },
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>N",
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
          Snacks.bufdelete.delete {
            filter = function(bufnr)
              local is_buf_visible = function(nr)
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  if vim.api.nvim_win_get_buf(win) == nr then
                    return true
                  end
                end
                return false
              end

              return not is_buf_visible(bufnr)
            end,
          }
        end,
        desc = "Buffer Close others (respecting open buffers in splits)",
      },
      {
        "<leader>bO",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Buffer Close others (all others)",
      },
      {
        "<leader>si",
        function()
          Snacks.image.hover()
        end,
        desc = "Image Show Image (Hover)",
      },
      {
        "<leader>tW",
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
        "<leader>tn",
        function()
          pause_notifications = not pause_notifications
        end,
        desc = "Toggle Notifications",
      },
    },
    opts = options,
    init = function()
      setup_colors()
    end,
  },
}
