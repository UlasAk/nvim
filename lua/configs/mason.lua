local options = {
  ensure_installed_mason_names = {
    "angular-language-server",
    "bash-language-server",
    "csharp-language-server",
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
  ensure_installed = {
    "angularls",
    "bashls",
    "csharp_ls",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "emmet_language_server",
    "jsonls",
    "lua_ls",
    "rust_analyzer",
    "terraformls",
    "ts_ls",
    "yamlls",
  },

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
}

return options
