local M = {}
local map = vim.keymap.set
local spinner = require "spinner"

local should_show_spinner = function()
  return string.match(vim.fn.expand "%:p", "projects") ~= nil
end

local function apply_rename(currName, win)
  local newName = vim.trim(vim.fn.getline ".")
  vim.api.nvim_win_close(win, true)

  if string.len(newName) > 0 and newName ~= currName then
    local params = vim.lsp.util.make_position_params(0, "utf-8")
    params = vim.tbl_extend("force", params, { newName = newName })

    if should_show_spinner() then
      local stripped_current_name = string.sub(currName, 1, #currName - 1)
      spinner.show("Renaming " .. "'" .. stripped_current_name .. "'" .. " to " .. "'" .. newName .. "'", "LSP")
    end
    -- Angular specific check to prevent double renaming
    if
      #vim.lsp.get_clients { bufnr = 0, name = "angularls" } > 0
      and (vim.bo.filetype == "typescript" or vim.bo.filetype == "htmlangular" or vim.bo.filetype == "html")
    then
      vim.lsp.buf.rename(newName, { name = "angularls" })
    else
      vim.lsp.buf_request(0, "textDocument/rename", params)
    end
  end
end

local function rename()
  if #vim.lsp.get_clients { bufnr = 0 } then
    Snacks.notify.warn("No LSP attached to this buffer", { title = "LSP" })
    return
  end

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

  map({ "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

  map({ "i", "n" }, "<CR>", function()
    apply_rename(currName, win)
    vim.cmd.stopinsert()
  end, { buffer = 0 })
end

-- basic lsp config
M.on_attach = function(client, bufnr)
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

local function send_lsp_notification(message)
  -- only send notifications, if the folder path includes "projects"
  if should_show_spinner() then
    local current_word = vim.call("expand", "<cword>")
    spinner.show(message .. current_word, "LSP")
    -- Snacks.notify(message .. current_word, { title = "LSP" })
  end
end

-- Stop spinner, if request is completed or canceled
vim.api.nvim_create_autocmd("LspRequest", {
  callback = function(args)
    local request = args.data.request
    local relevant_methods = {
      "textDocument/declaration",
      "textDocument/definition",
      "textDocument/implementation",
      "callHierarchy/incomingCalls",
      "callHierarchy/outgoingCalls",
      "textDocument/typeDefinition",
      "textDocument/documentSymbol",
      "textDocument/references",
      "workspace/symbol",
      "textDocument/rename",
    }
    local is_relevant = false
    for i = 1, #relevant_methods do
      if relevant_methods[i] == request.method then
        is_relevant = true
        break
      end
    end
    if is_relevant and (request.type == "cancel" or request.type == "complete") then
      spinner.hide()
    end
  end,
})
M.setup_keymaps = function()
  local function opts(desc)
    return { desc = desc }
  end

  map("n", "<leader>lR", function()
    M.defaults()
    M.setup_keymaps()
    M.setup_colors()
  end, opts "Lsp Reload Lsp config")

  map("n", "<leader>lgD", function()
    send_lsp_notification "Go to declaration: "
    vim.lsp.buf.declaration()
  end, opts "Lsp Go to declaration")
  map("n", "<leader>lgd", function()
    send_lsp_notification "Go to definition: "
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
    send_lsp_notification "Go to definition in split: "
    gotoDefinitionInSplit()
  end, opts "Lsp Go to definition in split view")
  map("n", "<leader>lh", function()
    vim.lsp.buf.hover {
      border = "rounded",
    }
  end, opts "Lsp hover information")
  map("n", "<leader>lgi", function()
    send_lsp_notification "Go to implementation: "
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
    send_lsp_notification "Go to incoming callers: "
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
    send_lsp_notification "Go to outgoing callers: "
    require("telescope.builtin").lsp_outgoing_calls {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Go to outgoing calls")
  map("n", "<leader>lsh", function()
    require("lsp_signature").toggle_float_win()
  end, opts "Lsp Show signature help")
  map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts "Lsp Add workspace folder")
  map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts "Lsp Remove workspace folder")

  map("n", "<leader>lw", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "Lsp List workspace folders")

  map("n", "<leader>lD", function()
    send_lsp_notification "Go to type definitions: "
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
    send_lsp_notification "Go to references: "
    require("telescope.builtin").lsp_references {
      initial_mode = "normal",
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    }
  end, opts "Lsp Show references")

  map("n", "<leader>lcl", function()
    vim.lsp.codelens.run()
  end, opts "Lsp Codelens")

  map("n", "<leader>li", function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled)
  end, opts "Lsp Toggle inlay hints")

  map("n", "<leader>lls", function()
    spinner.hide()
  end, opts "Lsp Hide lsp loading spinner")
end

M.setup_colors = function()
  vim.api.nvim_set_hl(0, "FloatBorder", {
    fg = "#fdfd96",
  })
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
    { "cssls", "docker_compose_language_service", "jsonls", "kotlin_language_server", "pyright", "terraformls" }

  if vim.fn.executable "hyprls" == 1 then
    table.insert(lsp_servers, "hyprls")
  end

  -- LSPs with default config
  for _, lsp in ipairs(lsp_servers) do
    if lspconfig[lsp] ~= nil then
      vim.lsp.config(lsp, {
        on_attach = M.on_attach,
        on_init = M.on_init,
        capabilities = M.capabilities,
      })
      vim.lsp.enable(lsp)
    end
  end

  -- LSPs with specific config

  -- Angular
  local angular_json_path = vim.fs.dirname(vim.fs.find({ "angular.json" }, {
    path = vim.loop.cwd(),
    upward = true,
  })[1])
  if angular_json_path ~= nil then
    local ok, mason_registry = pcall(require, "mason-registry")
    if not ok then
      vim.notify "mason-registry could not be loaded"
      return
    end

    local angularls_path = vim.fn.expand "$MASON/packages/angular-language-server"
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

    vim.lsp.config("angularls", {
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
      cmd = cmd,
      on_exit = handle_angular_exit,
      on_new_config = function(new_config, _)
        new_config.cmd = cmd
      end,
      filetypes = { "htmlangular", "typescript", "html", "typescriptreact", "typescript.tsx" },
    })
    vim.lsp.enable "angularls"
  end

  -- Bash
  vim.lsp.config("bashls", {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = { "sh", "bash" },
  })
  vim.lsp.enable "bashls"

  -- Dockerfile Language Server
  vim.lsp.config("dockerls", {
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
  })
  vim.lsp.enable "dockerls"

  -- Emmet Language Server
  vim.lsp.config("emmet_language_server", {
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
  })
  vim.lsp.enable "emmet_language_server"

  -- HTML
  vim.lsp.config("html", {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = {
      "htmlangular",
      "html",
      "templ",
    },
  })
  vim.lsp.enable "html"

  -- lua
  vim.lsp.config("lua_ls", {
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
  })
  vim.lsp.enable "lua_ls"

  -- TypeScript
  vim.lsp.config("ts_ls", {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    init_options = {
      preferences = {
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayVariableTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        disableSuggestions = true,
      },
    },
  })
  vim.lsp.enable "ts_ls"

  vim.lsp.config("yamlls", {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = { "yaml", "yaml.gitlab" },
  })
  vim.lsp.enable "yamlls"

  -- Latex
  -- vim.lps.config("ltex", {
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
  -- })
  -- vim.lsp.enable("ltex")
  -- vim.lsp.config("texlab", {
  --   on_attach = M.on_attach,
  --   on_init = M.on_init,
  --   capabilities = M.capabilities,
  -- })
  -- vim.lsp.enable("texlab")
end

return M
