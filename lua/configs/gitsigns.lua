dofile(vim.g.base46_cache .. "git")

local options = {
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },

  on_attach = function(_)
    if require("lazy.core.config").plugins["zen-mode.nvim"]._.loaded ~= nil and require("zen-mode.view").is_open() then
      return false
    end
  end,
}

return options
