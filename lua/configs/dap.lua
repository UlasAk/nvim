local M = {}
local dap = require "dap"

-- Adapters
local dartAdapter = function()
  dap.adapters.dart = {
    type = "executable",
    command = "dart", -- if you're using fvm, you'll need to provide the full path to dart (dart.exe for windows users), or you could prepend the fvm command
    args = { "debug_adapter" },
    -- windows users will need to set 'detached' to false
    options = {
      detached = false,
    },
  }
end

local flutterAdapter = function()
  dap.adapters.flutter = {
    type = "executable",
    command = "flutter", -- if you're using fvm, you'll need to provide the full path to flutter (flutter.bat for windows users), or you could prepend the fvm command
    args = { "debug_adapter" },
    -- windows users will need to set 'detached' to false
    options = {
      detached = false,
    },
  }
end

local javascriptAdapter = function()
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = { os.getenv "HOME" .. "/Developer/debuggers/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }
end

-- Configurations
local javascriptConfigurations = function()
  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }
end

local typescriptConfigurations = function()
  dap.configurations.typescript = {
    {
      name = "Launch Node",
      type = "pwa-node",
      request = "launch",
      runtimeExecutable = "tsx",
      args = { "--inspect", "${file}" },
      skipFiles = { "node_modules/**" },
      console = "integratedTerminal",
      cwd = "${workspaceFolder}",
      sourceMap = true,
    },
    {
      name = "Attach to Node",
      type = "pwa-node",
      request = "attach",
      processId = require("dap.utils").pick_process,
      sourceMap = true,
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
    },
  }
end

M.setup_adapters = function()
  dartAdapter()
  flutterAdapter()
  javascriptAdapter()
end

M.setup_configurations = function()
  javascriptConfigurations()
  typescriptConfigurations()
end

M.setup_colors = function()
  vim.api.nvim_set_hl(0, "SignColumn", {
    fg = "#bbbbbb",
  })
end

return M
