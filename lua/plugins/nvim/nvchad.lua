return {
  {
    "nvchad/base46",
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "nvchad/ui",
    lazy = false,
    keys = {

      { "<leader>ch", "<cmd>NvCheatsheet<CR>", desc = "Cheatsheet Toggle" },
      {
        "<leader>tR",
        function()
          require("nvchad.term").runner {
            pos = "sp",
            id = "runner",
            clear_cmd = false,
            cmd = function()
              -- Specify commands for each filetype to run
              local filetype_cmds = {
                javascript = "node",
                python = "python3",
              }

              return function()
                local file = vim.fn.expand "%"
                return filetype_cmds[vim.bo.ft] .. " " .. file
              end
            end,
          }
        end,
        desc = "Runner Run Current File",
      },
    },
    config = function()
      require "nvchad"
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
      filetypes = { "*", "!dart" },
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
  },
  {
    "nvchad/volt",
    keys = {
      {
        "<leader>q",
        function()
          require("volt").close()
        end,
        desc = "Window Close all Volt windows",
      },
    },
  },
  {
    "nvchad/minty",
    keys = {
      {
        "<leader>cph",
        function()
          require("volt").close()
          require("minty.huefy").open()
        end,
        desc = "Colors Show Hue picker",
      },
      {
        "<leader>cps",
        function()
          require("volt").close()
          require("minty.shades").open()
        end,
        desc = "Colors Show Shades picker",
      },
    },
  },
}
