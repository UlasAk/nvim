return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      config = {},
      exe = {
        "dotnet",
        vim.fs.joinpath(
          vim.fn.stdpath "data",
          "mason",
          "packages",
          "roslyn",
          "libexec",
          "Microsoft.CodeAnalysis.LanguageServer.dll"
        ),
      },
      args = {
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
      },
      filewatching = true,
      choose_target = nil,
      ignore_target = nil,
      broad_search = false,
      lock_target = false,
    },
  },
}
