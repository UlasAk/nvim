local M = {
  adapters = {
    require "neotest-dart" {
      command = "flutter", -- Command being used to run tests. Defaults to `flutter`
      -- Change it to `fvm flutter` if using FVM
      -- change it to `dart` for Dart only tests
      use_lsp = true, -- When set Flutter outline information is used when constructing test name.
      -- Useful when using custom test names with @isTest annotation
      custom_test_method_names = {},
    },
    require "neotest-gradle",
    require "neotest-jest" {
      jestCommand = "npm test --",
      jestConfigFile = "custom.jest.config.ts",
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    },
  },
}

return M
