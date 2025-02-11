pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

local options = {
  ensure_installed = {
    "angular",
    "bash",
    "css",
    "dart",
    "dockerfile",
    "dosini",
    "javascript",
    "html",
    "hyprlang",
    "ini",
    "json",
    "json5",
    "kotlin",
    -- "latex",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "regex",
    "rust",
    "ssh_config",
    "tmux",
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

local function check_yaml_file(path)
  if path:match ".*docker.*compose.*$" and (path:match "%.yaml$" or path:match "%.yml$") then
    return "yaml.docker-compose"
  end
  return "yaml"
end

vim.filetype.add {
  pattern = {
    -- [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `angular` if it matches the pattern
    [".*%.yaml"] = function(path, _)
      return check_yaml_file(path)
    end,
    [".*%.yml"] = function(path, _)
      return check_yaml_file(path)
    end,
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
      vim.cmd "set filetype=htmlangular"
    end
  end,
  group = "AngularTemplates",
})

return options
