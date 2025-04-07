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

local function apply_rename(curr, win)
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
    apply_rename(currName, win)
    vim.cmd.stopinsert()
  end, { buffer = 0 })
end

-- basic lsp config
M.on_attach = function(client, bufnr)
  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    signature_help.setup(client, bufnr)
  end

  -- inlay hints
  vim.lsp.inlay_hint.enable(true)
end

local make_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem = {
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
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  -- capabilities = require("blink.cmp").get_lsp_capabilities(M.capabilities)
  return capabilities
end

local function is_terminal_window(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal"
end

local function count_terminal_buffers_in_tabpage(windows)
  local terminal_count = 0

  for _, win in ipairs(windows) do
    if is_terminal_window(win) then
      terminal_count = terminal_count + 1
    end
  end

  return terminal_count
end

local gotoDefinitionInSplit = function()
  -- Check how many windows are open
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local first_buffer = vim.api.nvim_win_get_buf(wins[1])

  local nvim_tree_open = vim.api.nvim_get_option_value("filetype", { buf = first_buffer }) == "NvimTree"

  local current_cursor_pos = vim.api.nvim_win_get_cursor(0)

  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  local target_win

  local relevant_win_count = #wins - count_terminal_buffers_in_tabpage(wins)

  -- If there are already splits, then take the next one and set buffer to current buffer
  if nvim_tree_open then
    if relevant_win_count == 1 then
      print "Cannot open definition from NvimTree window"
    -- only nvim and one window is open
    elseif relevant_win_count == 2 then
      vim.cmd "vsplit"
      target_win = current_win
    else
      for _, win_num in pairs(wins) do
        if win_num ~= current_win and win_num ~= wins[1] and not is_terminal_window(win_num) then
          target_win = win_num
          break
        end
      end
    end
  else
    if relevant_win_count >= 2 then
      for _, win_num in pairs(wins) do
        if win_num ~= current_win and not is_terminal_window(win_num) then
          target_win = win_num
          break
        end
      end
    else
      vim.cmd "vsplit"
      target_win = current_win
    end
  end

  -- Set buffer for new window
  vim.api.nvim_win_set_buf(target_win, current_buf)

  -- Copy cursor position to new window for lsp defintion
  vim.api.nvim_win_set_cursor(target_win, current_cursor_pos)

  -- Focus new window
  vim.api.nvim_set_current_win(target_win)

  -- Call lsp
  vim.lsp.buf.definition()
end

M.capabilities = make_capabilities()
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.setup_keymaps = function()
  local function opts(desc)
    return { desc = desc }
  end

  map("n", "<leader>lgD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")
  map("n", "<leader>lgd", function()
    require("telescope.builtin").lsp_definitions {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Go to definition")
  map("n", "<leader>lgvd", function()
    gotoDefinitionInSplit()
  end, opts "Lsp Go to definition")
  map("n", "<leader>lh", vim.lsp.buf.hover, opts "Lsp hover information")
  map("n", "<leader>lgi", function()
    require("telescope.builtin").lsp_implementations {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Go to implementation")
  map("n", "<leader>lgci", function()
    require("telescope.builtin").lsp_incoming_calls {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Go to incoming calls")
  map("n", "<leader>lgco", function()
    require("telescope.builtin").lsp_outgoing_calls {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Go to outgoing calls")
  map("n", "<leader>lsh", vim.lsp.buf.signature_help, opts "Lsp Show signature help")
  map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts "Lsp Add workspace folder")
  map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts "Lsp Remove workspace folder")

  map("n", "<leader>lw", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "Lsp List workspace folders")

  map("n", "<leader>lD", function()
    require("telescope.builtin").lsp_type_definitions {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Go to type definition")

  map("n", "<leader>lr", function()
    rename()
  end, opts "Lsp Rename")

  map("n", "<leader>lgr", function()
    require("telescope.builtin").lsp_references {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Show references")
end

M.defaults = function()
  dofile(vim.g.base46_cache .. "lsp")
  local lspconfig = require "lspconfig"
  -- Diagnostic Signs
  local x = vim.diagnostic.severity

  vim.diagnostic.config {
    virtual_text = { prefix = "" },
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
    underline = true,
    float = { border = "single" },
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
  local lsp_servers =
    { "cssls", "docker_compose_language_service", "hyprls", "jsonls", "kotlin_language_server", "terraformls" }

  -- LSPs with default config
  for _, lsp in ipairs(lsp_servers) do
    if lspconfig[lsp] ~= nil then
      lspconfig[lsp].setup {
        on_attach = M.on_attach,
        on_init = M.on_init,
        capabilities = M.capabilities,
      }
    end
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
