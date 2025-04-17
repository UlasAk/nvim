return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<leader>th",
        function()
          local hardtime = require "hardtime"
          hardtime.toggle()
          Snacks.notify(hardtime.is_plugin_enabled and "Enabled" or "Disabled", { title = "Hardtime" })
        end,
        desc = "Toggle Hardtime",
      },
    },
    opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
    },
  },
}
