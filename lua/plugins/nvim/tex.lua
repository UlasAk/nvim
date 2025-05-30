-- local au_group = vim.api.nvim_create_augroup("vimtex_events", {})
-- -- Cleanup on quit
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VimtexEventQuit",
--   group = au_group,
--   command = "VimtexClean",
-- })
--
-- -- Focus the terminal after inverse search
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VimtexEventViewReverse",
--   group = au_group,
--   command = "call b:vimtex.viewer.xdo_focus_vim()",
-- })
--
-- -- Help
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "help" },
--   callback = function(opts)
--     vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = opts.buf, desc = "Help Jump To Reference" })
--   end,
-- })
return {
  -- {
  --   "lervag/vimtex",
  --   lazy = false, -- we don't want to lazy load VimTeX
  --   -- tag = "v2.15", -- uncomment to pin to a specific release
  --   init = function()
  --     -- VimTeX configuration goes here
  --     if vim.fn.has "macunix" == 1 then
  --       vim.g.vimtex_view_method = "skim"
  --       vim.g.vimtex_view_skim_activate = 0
  --       vim.g.vimtex_view_skim_sync = 1
  --       vim.g.vimtex_view_skim_reading_bar = 1
  --       vim.g.vimtex_view_skim_no_select = 0
  --     else
  --       vim.g.vimtex_view_general_viewer = "okular"
  --       vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
  --       -- vim.g.vimtex_view_method = "zathura"
  --     end
  --   end,
  -- },
}
