local M = {}
local map = vim.keymap.set
local conf = require("nvconfig").ui.lsp

-- basic lsp config
M.on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = desc }
  end

  map("n", "<leader>lgD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")
  map("n", "<leader>lgd", vim.lsp.buf.definition, opts "Lsp Go to definition")
  map("n", "<leader>lh", vim.lsp.buf.hover, opts "Lsp hover information")
  map("n", "<leader>lgi", vim.lsp.buf.implementation, opts "Lsp Go to implementation")
  map("n", "<leader>lsh", vim.lsp.buf.signature_help, opts "Lsp Show signature help")
  map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts "Lsp Add workspace folder")
  map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts "Lsp Remove workspace folder")

  map("n", "<leader>lw", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "Lsp List workspace folders")

  map("n", "<leader>lD", vim.lsp.buf.type_definition, opts "Lsp Go to type definition")

  map("n", "<leader>lr", function()
    require "nvchad.lsp.renamer"()
  end, opts "Lsp NvRenamer")

  map({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action, opts "Lsp Code action")
  -- map("n", "lsr", vim.lsp.buf.references, opts "Lsp Show references")
  map("n", "<leader>lsr", function()
    require("telescope.builtin").lsp_references()
  end, opts "Lsp Show references")

  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.defaults = function()
  -- enable inlay_hints
  vim.lsp.inlay_hint.enable(true)
  dofile(vim.g.base46_cache .. "lsp")
  require "nvchad.lsp"
  local lspconfig = require "lspconfig"
  -- LSPs without specific config
  local lsp_servers = { "cssls", "jsonls", "yamlls" }

  -- LSPs with default config
  for _, lsp in ipairs(lsp_servers) do
    lspconfig[lsp].setup {
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
    }
  end

  -- LSPs with specific config

  -- Bash
  lspconfig.bashls.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = { "sh", "bash" },
  }

  -- lua
  lspconfig.lua_ls.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }

  -- TypeScript
  lspconfig.tsserver.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
  }

  -- HTML
  lspconfig.html.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = {
      "angular",
      "html",
      "templ",
    },
  }

  -- Emmet Language Server
  lspconfig.emmet_language_server.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = {
      "angular",
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
  }

  -- Angular
  local ok, mason_registry = pcall(require, "mason-registry")
  if not ok then
    vim.notify "mason-registry could not be loaded"
    return
  end

  local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()
  local handle_angular_exit = function(code, signal, client_id)
    if code > 0 then
      vim.schedule(function()
        print "Restarting failed Angular LS.."
        vim.cmd "LspStart angularls"
      end)
    end
  end

  local cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    table.concat({
      angularls_path,
      vim.uv.cwd(),
    }, ","),
    "--ngProbeLocations",
    table.concat({
      angularls_path .. "/node_modules/@angular/language-server",
      vim.uv.cwd(),
    }, ","),
  }

  lspconfig.angularls.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    cmd = cmd,
    on_exit = handle_angular_exit,
    on_new_config = function(new_config, _)
      new_config.cmd = cmd
    end,
    filetypes = { "angular", "typescript", "html", "typescriptreact", "typescript.tsx" },
  }
end

return M
