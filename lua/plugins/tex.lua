return {
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here
      if vim.fn.has "macunix" == 1 then
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_activate = 0
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_reading_bar = 1
        vim.g.vimtex_view_skim_no_select = 0
      else
        vim.g.vimtex_view_general_viewer = "okular"
        vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
        -- vim.g.vimtex_view_method = "zathura"
      end
    end,
  },
}
