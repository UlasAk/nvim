local M = {}

M.get_all_ensure_installed_mason_names = function()
  local name_table = {
    "angular-language-server",
    "bash-language-server",
    "csharp-language-server",
    "css-lsp",
    "dart-debug-adapter",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "emmet-language-server",
    "eslint-lsp",
    "js-debug-adapter",
    "json-lsp",
    "lua-language-server",
    "luacheck",
    "markdownlint",
    "prettier",
    "pyright",
    "qmlls",
    "roslyn",
    "rust-analyzer",
    "shellcheck",
    "shfmt",
    "stylua",
    "terraform-ls",
    "trivy",
    "typescript-language-server",
    "yaml-language-server",
    "yamlfmt",
  }
  if vim.fn.executable "go" == 1 then
    table.insert(name_table, "hyprls")
  end
  return name_table
end

M.ensure_installed_mason_names = M.get_all_ensure_installed_mason_names()

M.options = {
  PATH = "skip",
  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " ",
    },
  },
  max_concurrent_installers = 10,
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
}

return M
