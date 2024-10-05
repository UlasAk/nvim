return {
  {
    "NvChad/base46",
    branch = "v3.0",
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    branch = "v3.0",
    lazy = false,
    config = function()
      require "nvchad"
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = true, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
        virtualtext = "■",
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
      },
    },
    config = function(_, opts)
      -- require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      -- vim.defer_fn(function()
      --   require("colorizer").attach_to_buffer(0)
      -- end, 0)
    end,
  },
  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup {
        terminals = {
          type_opts = {
            horizontal = { location = "rightbelow", split_ratio = 0.3 },
            vertical = { location = "rightbelow", split_ratio = 0.3 },
          },
        },
      }
    end,
  },
  "nvchad/volt",
  "nvchad/minty",
  "nvchad/menu",
}
