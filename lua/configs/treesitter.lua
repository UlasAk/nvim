local options = {
  ensure_installed = {
    -- "angular",
    "bash",
    "css",
    "javascript",
    "html",
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

-- Angular Setup
-- vim.filetype.add {
--   pattern = {
--     [".*%.component%.html"] = "angular.html", -- Sets the filetype to `angular.html` if it matches the pattern
--   },
-- }
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "angular.html",
--   callback = function()
--     vim.treesitter.language.register("angular", "angular.html") -- Register the filetype with treesitter for the `angular` language/parser
--   end,
-- })

return options
