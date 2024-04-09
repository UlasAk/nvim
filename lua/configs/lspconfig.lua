local M = {}
local map = vim.keymap.set
local conf = require("nvconfig").ui.lsp

-- basic lsp config
local on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = desc }
  end

  map("n", "lgD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")
  map("n", "lgd", vim.lsp.buf.definition, opts "Lsp Go to definition")
  map("n", "lh", vim.lsp.buf.hover, opts "Lsp hover information")
  map("n", "lgi", vim.lsp.buf.implementation, opts "Lsp Go to implementation")
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
  map("n", "lsr", vim.lsp.buf.references, opts "Lsp Show references")

  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local on_init = require("nvchad.configs.lspconfig").on_init

local lspconfig = require "lspconfig"
local servers = { "html", "cssls" }



-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

local cmp = require("cmp")

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
-- `:` cmdline setup.
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' }
        }
      }
    })
  })


-- build lspconfig object
M.on_attach = on_attach
M.capabilities = capabilities

return M;
