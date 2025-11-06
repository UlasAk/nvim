return {
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    opts = {},
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-telescope/telescope.nvim" },
    event = "BufEnter *package.json",
    keys = {
      {
        "<leader>pi",
        "<CMD>Telescope package_info<CR>",
        desc = "Telescope NPM Package Info",
        silent = true,
        noremap = true,
      },
    },
    opts = {
      hide_up_to_date = true,
      package_manager = "npm",
    },
    config = function(_, opts)
      require("package-info").setup(opts)
      require("telescope").load_extension "package_info"
      require("colors").add_and_set_color_module("package-info", function()
        vim.api.nvim_set_hl(0, "PackageInfoUpToDateVersion", {
          fg = "#abe9b3",
        })
        vim.api.nvim_set_hl(0, "PackageInfoOutdatedVersion", {
          fg = "#d19a66",
        })
        vim.api.nvim_set_hl(0, "PackageInfoInvalidVersion", {
          fg = "#ee4b2b",
        })
      end)
    end,
  },
}
