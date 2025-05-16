return {
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      { "<leader>fse", "<cmd>SessionSearch<CR>", desc = "Telescope Sessions" },
      { "<leader>sd", "<cmd>SessionDelete<CR>", desc = "Session Delete current session" },
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Downloads", "/" },
      cwd_change_handling = true,
      auto_restore_last_session = false,
      session_lens = {
        previewer = true,
      },
      pre_save_cmds = {
        -- "bw __FLUTTER_DEV_LOG__",
      },
    },
  },
}
