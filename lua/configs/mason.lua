local M = {}

local filetype_map = {
  angularls = "htmlangular",
  bashls = "sh",
  cssls = "css",
  docker_compose_language_service = "yaml.docker-compose",
  dockerls = "docker",
  emmet_language_server = {
    "htmlangular",
    "htcss",
    "eruby",
    "html",
    "htmldjango",
    "javascriptreact",
    "less",
    "pug",
    "sass",
    "scss",
    "typescriptreactml",
  },
  jsonls = "json",
  rust_analyzer = "rust",
  terraformls = "tf",
  ts_ls = "typescript",
  yamlls = "yaml",
}

M.get_language_server_names = function()
  local names = {}
  for k, _ in pairs(filetype_map) do
    table.insert(names, k)
  end
  return names
end

M.get_filetypes = function()
  local filetypes = {}
  for _, entry in pairs(filetype_map) do
    if type(entry) == "table" then
      for _, filetype in pairs(entry) do
        table.insert(filetypes, filetype)
      end
    else
      table.insert(filetypes, entry)
    end
  end
  return filetypes
end

M.options = {
  ensure_installed_mason_names = {
    "angular-language-server",
    "bash-language-server",
    "css-lsp",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "emmet-language-server",
    "json-lsp",
    -- "latexindent",
    -- "ltex-ls",
    "lua-language-server",
    "prettier",
    "rust-analyzer",
    "shellcheck",
    "shfmt",
    "stylua",
    -- "texlab",
    "terraform-ls",
    "typescript-language-server",
    "yaml-language-server",
    "yamlfmt",
  },
  ensure_installed = M.get_language_server_names(),

  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
}

return M
