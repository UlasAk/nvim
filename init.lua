vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- load options
require "options"

-- load plugins
require("lazy").setup({
  -- {
  --   "NvChad/NvChad",
  --   lazy = false,
  --   branch = "v2.5",
  --   import = "nvchad.plugins",
  --   config = function()
  --     require "options"
  --   end,
  -- },
  {
    import = "plugins",
    config = function()
      require "options"
    end,
  },
}, require "configs.lazy")

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- load autocmds
require "autocmds"

-- load key bindings
vim.schedule(function()
  require "mappings"
end)

-- vim window options
vim.opt.colorcolumn = "160"
vim.g.nvim_terminal_default_window_settings = {
  window = {
    width = 80,
  },
}
