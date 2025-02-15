local M = {
  adapters = {
    require "neotest-dart" {
      -- change it to `dart` for Dart only tests
      -- Command being used to run tests. Defaults to `flutter`
      command = "flutter",
      -- When set Flutter outline information is used when constructing test name.
      use_lsp = true,
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
