return {
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-telescope/telescope.nvim" },
    event = "BufEnter *package.json",
    keys = {
      {
        "<leader>pi",
        "<cmd>Telescope package_info<CR>",
        desc = "Telescope NPM Package Info",
        silent = true,
        noremap = true,
      },
    },
    opts = {
      highlights = {
        up_to_date = {
          fg = "#3C4048",
        },
        outdated = {
          fg = "#d19a66",
        },
        invalid = {
          fg = "#ee4b2b",
        },
      },
      icons = {
        enable = true,
        style = {
          up_to_date = "|  ",
          outdated = "|  ",
          invalid = "|  ",
        },
      },
      autostart = true,
      hide_up_to_date = true,
      hide_unstable_versions = false,
      package_manager = "npm",
    },
    config = function(_, opts)
      require("package-info").setup(opts)
      require("telescope").load_extension "package_info"
      vim.api.nvim_set_hl(0, "PackageInfoUpToDateVersion", {
        fg = "#abe9b3",
      })
      vim.api.nvim_set_hl(0, "PackageInfoOutdatedVersion", {
        fg = "#d19a66",
      })
      vim.api.nvim_set_hl(0, "PackageInfoInvalidVersion", {
        fg = "#ee4b2b",
      })
    end,
  },
}
