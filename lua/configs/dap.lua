local M = {}
local dap = require "dap"

local dart = function()
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

local flutter = function()
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

M.setup_adapters = function()
  dart()
  flutter()
end

M.setup_colors = function()
  vim.schedule(function()
    vim.cmd "hi SignColumn guifg=#bbbbbb"
  end)
end

return M
