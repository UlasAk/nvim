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

local chromeAdapter = function()
  dap.adapters["pwa-chrome"] = {
    type = "executable",
    command = "node",
    args = { os.getenv "HOME" .. "/Developer/debuggers/js-debug/src/dapDebugServer.js" },
  }
end

-- Configurations
local javascriptConfigurations = function()
  dap.configurations.javascript = {
    {
      name = "Launch file",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      sourceMaps = true,
    },
    {
      name = "Attach to Node",
      type = "pwa-node",
      request = "attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch & Debug Chrome",
      url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({
            prompt = "Enter URL: ",
            default = "http://localhost:3000",
          }, function(url)
            if url == nil or url == "" then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end,
      webRoot = vim.fn.getcwd(),
      protocol = "inspector",
      sourceMaps = true,
      userDataDir = false,
    },
    -- Divider for the launch.json derived configs
    {
      name = "----- ↓ launch.json configs ↓ -----",
      type = "",
      request = "launch",
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
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      sourceMaps = true,
    },
    {
      name = "Launch Nodemon",
      type = "pwa-node",
      request = "launch",
      runtimeExecutable = "nodemon",
      args = { "--watch", "src/**/*.ts", "--exec", "npx", "ts-node", "${file}" },
      skipFiles = { "node_modules/**" },
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      sourceMaps = true,
    },
    {
      name = "Attach to Node",
      type = "pwa-node",
      request = "attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch & Debug Chrome",
      url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({
            prompt = "Enter URL: ",
            default = "http://localhost:3000",
          }, function(url)
            if url == nil or url == "" then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end,
      webRoot = vim.fn.getcwd(),
      protocol = "inspector",
      sourceMaps = true,
      userDataDir = false,
    },
    -- Divider for the launch.json derived configs
    {
      name = "----- ↓ launch.json configs ↓ -----",
      type = "",
      request = "launch",
    },
  }
end

M.setup_adapters = function()
  dartAdapter()
  flutterAdapter()
  javascriptAdapter()
  chromeAdapter()
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
