local M = {
  transparent = true,
}

M.init_colors = function()
  vim.opt.termguicolors = true
  vim.schedule(function()
    -- Highlight current search item with different color than other search items
    vim.api.nvim_set_hl(0, "CurSearch", {
      fg = "#282737",
      bg = "#ff0000",
    })
    -- Change Visual Mode Background Color to see more on transparent background
    vim.api.nvim_set_hl(0, "Visual", {
      bg = "#76758a",
    })
    -- Text color of commented out text
    vim.api.nvim_set_hl(0, "Comment", {
      fg = "#8886a6",
    })
    vim.api.nvim_set_hl(0, "@comment", {
      fg = "#8886a6",
    })
    -- Line number color
    vim.api.nvim_set_hl(0, "LineNr", {
      fg = "#8886a6",
    })
    vim.api.nvim_set_hl(0, "CursorLineNr", {
      fg = "#fdfd96",
    })
    vim.api.nvim_set_hl(0, "gitCommitComment", {
      fg = "#8886a6",
    })

    -- Statusline Seperators
    vim.api.nvim_set_hl(0, "Record", {
      fg = "#222222",
      bg = "#f38ba8",
      ctermfg = 0,
      ctermbg = 11,
    })
    vim.api.nvim_set_hl(0, "RecordSepL", {
      fg = "#313244",
      bg = "#f38ba8",
      ctermfg = 0,
      ctermbg = 11,
    })
    vim.api.nvim_set_hl(0, "RecordSepR", {
      fg = "#f38ba8",
      bg = "#313244",
      ctermfg = 0,
      ctermbg = 11,
    })
  end)
end

M.toggle_transparency = function()
  M.transparent = not M.transparent
  require("chadrc").base46.transparency = M.transparent
end

return M
