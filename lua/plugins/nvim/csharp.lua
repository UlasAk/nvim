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
    config = function(_, opts)
      require("roslyn").setup(opts)
      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
      vim.lsp.enable "roslyn"
    end,
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
