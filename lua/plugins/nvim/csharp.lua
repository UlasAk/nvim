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
    },
  },
  {
    "nicholasmata/nvim-dap-cs",
    name = "dap-cs",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "cs",
    opts = {
      dap_configurations = {
        {
          type = "coreclr",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
      netcoredbg = {
        path = "netcoredbg",
      },
    },
  },
}
