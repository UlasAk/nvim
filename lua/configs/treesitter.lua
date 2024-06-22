local options = {
  ensure_installed = {
    "angular",
    "bash",
    "css",
    "javascript",
    "html",
    "hyprlang",
    "ini",
    "json",
    "json5",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "regex",
    "rust",
    "ssh_config",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

-- Add Custom Filetypes
local function is_hypr_conf(path)
  return path:match "/hypr/" and path:match "%.conf$"
end

local function is_tmux_conf(path)
  return path:match "%tmux.conf$"
end

vim.filetype.add {
  pattern = {
    -- [".*%.component%.html"] = "angular.html", -- Sets the filetype to `angular.html` if it matches the pattern
    [".*%.conf"] = function(path, _)
      if is_hypr_conf(path) then
        return "hyprlang"
      elseif is_tmux_conf(path) then
        return "tmux"
      else
        return "dosini"
      end
    end,
  },
}

-- Angular
local function is_angular_template(path)
  return path:match "%.component%.html$"
end
vim.api.nvim_create_augroup("AngularTemplates", {})
vim.api.nvim_create_autocmd({ "BufRead", "BufEnter", "BufNewFile" }, {
  pattern = "*.component.html",
  callback = function()
    -- Setze den Dateityp auf HTML, damit HTML-Plugins funktionieren
    vim.bo.filetype = "html"

    -- Speziell für Treesitter auf Angular setzen
    if is_angular_template(vim.fn.expand "<afile>:p") then
      vim.cmd "set filetype=angular"
    end
  end,
  group = "AngularTemplates",
})

return options
