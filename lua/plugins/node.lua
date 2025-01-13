return {
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    opts = {
      colors = {
        up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
        outdated = "#d19a66", -- Text color for outdated dependency virtual text
        invalid = "#ee4b2b", -- Text color for invalid dependency virtual text
      },
      icons = {
        enable = true, -- Whether to display icons
        style = {
          up_to_date = "|  ", -- Icon for up to date dependencies
          outdated = "|  ", -- Icon for outdated dependencies
          invalid = "|  ", -- Icon for invalid dependencies
        },
      },
      autostart = true, -- Whether to autostart when `package.json` is opened
      hide_up_to_date = true, -- It hides up to date versions when displaying virtual text
      hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
      -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
      -- The plugin will try to auto-detect the package manager based on
      -- `yarn.lock` or `package-lock.json`. If none are found it will use the
      -- provided one, if nothing is provided it will use `yarn`
      package_manager = "npm",
    },
    config = function(_, opts)
      require("package-info").setup(opts)
      require("telescope").load_extension "package_info"
      vim.cmd "hi PackageInfoUpToDateVersion guifg=#abe9b3"
      vim.cmd "hi PackageInfoOutdatedVersion guifg=#d19a66"
      vim.cmd "hi PackageInfoInvalidVersion guifg=#ee4b2b"
      vim.keymap.set(
        "n",
        "<leader>pi",
        "<cmd>Telescope package_info<CR>",
        { desc = "Telescope NPM Package Info", silent = true, noremap = true }
      )
    end,
  },
}
