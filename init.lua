require "options"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local lazy_spec = {
  {
    import = "plugins.globals",
  },
  {
    import = "plugins.firenvim",
  },
}

local opened_by_firenvim = vim.g.started_by_firenvim == true

if not opened_by_firenvim then
  table.insert(lazy_spec, {
    import = "plugins.nvim",
  })
end

require("lazy").setup {
  spec = lazy_spec,
  defaults = { lazy = true },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  checker = { enabled = true },

  performance = {
    rtp = {
      disabled_plugins = {
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
  rocks = {
    enabled = true,
  },
}

require "autocmds"

require "commands"

require("colors").init_colors()

vim.schedule(function()
  require "mappings"
end)

require "fixes"
