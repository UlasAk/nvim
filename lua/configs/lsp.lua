local M = {}
local map = vim.keymap.set
local conf = require("nvconfig").lsp

-- Signature help
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
  focusable = false,
  relative = "cursor",
  silent = true,
})

local signature_help = {}

signature_help.check_triggeredChars = function(triggerChars)
  local cur_line = vim.api.nvim_get_current_line()
  local pos = vim.api.nvim_win_get_cursor(0)[2]

  cur_line = cur_line:gsub("%s+$", "") -- rm trailing spaces

  for _, char in ipairs(triggerChars) do
    if cur_line:sub(pos, pos) == char then
      return true
    end
  end
end

signature_help.setup = function(client, bufnr)
  local group = vim.api.nvim_create_augroup("LspSignature", { clear = false })
  vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }

  local triggerChars = client.server_capabilities.signatureHelpProvider.triggerCharacters

  vim.api.nvim_create_autocmd("TextChangedI", {
    group = group,
    buffer = bufnr,
    callback = function()
      if signature_help.check_triggeredChars(triggerChars) then
        vim.lsp.buf.signature_help()
      end
    end,
  })
end

local function apply(curr, win)
  local newName = vim.trim(vim.fn.getline ".")
  vim.api.nvim_win_close(win, true)

  if string.len(newName) > 0 and newName ~= curr then
    local params = vim.lsp.util.make_position_params()
    params.newName = newName

    -- Angular specific check to prevent double renaming
    if
      vim.lsp.get_clients { bufnr = 0, name = "angularls" } == 1
      and vim.lsp.get_clients { bufnr = 0, name = "ts_ls" } == 1
    then
      vim.lsp.buf.rename(newName, { name = "angularls" })
    else
      vim.lsp.buf_request(0, "textDocument/rename", params)
    end
  end
end

local function rename()
  local currName = vim.fn.expand "<cword>" .. " "

  local win = require("plenary.popup").create(currName, {
    title = "Rename",
    style = "minimal",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    relative = "cursor",
    borderhighlight = "RenamerBorder",
    titlehighlight = "RenamerTitle",
    focusable = true,
    width = 25,
    height = 1,
    line = "cursor+2",
    col = "cursor-1",
  })

  vim.cmd "normal A"
  vim.cmd "startinsert"

  map({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

  map({ "i", "n" }, "<CR>", function()
    apply(currName, win)
    vim.cmd.stopinsert()
  end, { buffer = 0 })
end

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
    rename()
  end, opts "Lsp Rename")

  map({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action, opts "Lsp Code action")
  -- map("n", "lsr", vim.lsp.buf.references, opts "Lsp Show references")
  map("n", "<leader>lsr", function()
    require("telescope.builtin").lsp_references()
  end, opts "Lsp Show references")

  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    signature_help.setup(client, bufnr)
  end

  -- inlay hints
  vim.lsp.inlay_hint.enable(true)
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
  dofile(vim.g.base46_cache .. "lsp")
  local lspconfig = require "lspconfig"
  -- Diagnostic Signs
  local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end
  lspSymbol("Error", "󰅙")
  lspSymbol("Info", "󰋼")
  lspSymbol("Hint", "󰌵")
  lspSymbol("Warn", "")
  vim.diagnostic.config {
    virtual_text = {
      prefix = "",
    },
    signs = true,
    underline = true,
    -- update_in_insert = false,
    float = {
      border = "single",
    },
  }

  --  LspInfo window borders
  local win = require "lspconfig.ui.windows"
  local _default_opts = win.default_opts

  win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
  end

  -- LSPs without specific config
  local lsp_servers = { "cssls", "docker_compose_language_service", "jsonls" }

  -- LSPs with default config
  for _, lsp in ipairs(lsp_servers) do
    lspconfig[lsp].setup {
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
    }
  end

  -- LSPs with specific config

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
        -- print "Restarting failed Angular LS.."
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
    filetypes = { "htmlangular", "typescript", "html", "typescriptreact", "typescript.tsx" },
  }

  -- Bash
  lspconfig.bashls.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = { "sh", "bash" },
  }

  -- Dockerfile Language Server
  lspconfig.dockerls.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    settings = {
      docker = {
        languageserver = {
          formatter = {
            ignoreMultilineInstructions = true,
          },
        },
      },
    },
  }

  -- Emmet Language Server
  lspconfig.emmet_language_server.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = {
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
  }

  -- HTML
  lspconfig.html.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = {
      "htmlangular",
      "html",
      "templ",
    },
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
  lspconfig.ts_ls.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
  }

  lspconfig.yamlls.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = { "yaml", "yaml.gitlab" },
  }

  -- Latex
  -- lspconfig.ltex.setup {
  --   on_attach = M.on_attach,
  --   on_init = M.on_init,
  --   capabilities = M.capabilities,
  --   filetypes = {
  --     "bib",
  --     "gitcommit",
  --     "org",
  --     "plaintex",
  --     "rst",
  --     "rnoweb",
  --     "tex",
  --     "pandoc",
  --     "quarto",
  --     "rmd",
  --     "context",
  --     "mail",
  --     "text",
  --   },
  --   settings = {
  --     ltex = {
  --       language = "de-DE",
  --       checkFrequency = "save",
  --     },
  --   },
  -- }
  -- lspconfig.texlab.setup {
  --   on_attach = M.on_attach,
  --   on_init = M.on_init,
  --   capabilities = M.capabilities,
  -- }
end

return M
