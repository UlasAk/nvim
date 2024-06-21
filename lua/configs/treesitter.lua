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
vim.filetype.add {
  pattern = {
    -- [".*%.component%.html"] = "angular.html", -- Sets the filetype to `angular.html` if it matches the pattern
    [".*%/hypr/.*%.conf"] = "hyprlang",
    [".*%.conf"] = "dosini",
  },
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.component.html",
  command = "set filetype=angular",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  pattern = "hyprlang",
  command = "set filetype=hyprlang",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  pattern = "dosini",
  command = "set filetype=dosini",
})

return options
