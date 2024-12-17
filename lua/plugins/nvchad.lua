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
    config = function()
      require "nvchad"
      local map = vim.keymap.set
      map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "Toggle Cheatsheet" })
      -- map("n", "<leader>ba", function()
      --   require("nvchad.tabufline").closeAllBufs(false)
      -- end, { desc = "Buffer Close all except for current" })
      -- map("n", "<leader>bcl", function()
      --   require("nvchad.tabufline").closeBufs_at_direction "left"
      -- end, { desc = "Buffer Close buffers to the left" })
      -- map("n", "<leader>bcr", function()
      --   require("nvchad.tabufline").closeBufs_at_direction "right"
      -- end, { desc = "Buffer Close buffers to the right" })
      -- map("n", "<leader>bl", function()
      --   require("nvchad.tabufline").move_buf(-1)
      -- end, { desc = "Buffer Move buffer to left" })
      -- map("n", "<leader>br", function()
      --   require("nvchad.tabufline").move_buf(1)
      -- end, { desc = "Buffer Move buffer to right" })
      -- map("n", "<tab>", function()
      --   require("nvchad.tabufline").next()
      -- end, { desc = "Buffer Goto next" })
      -- map("n", "<S-tab>", function()
      --   require("nvchad.tabufline").prev()
      -- end, { desc = "Buffer Goto prev" })
      -- map("n", "<leader>x", function()
      --   require("nvchad.tabufline").close_buffer()
      -- end, { desc = "Buffer Close" })
      map("n", "<leader>th", function()
        require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
      end, { desc = "Terminal New horizontal term" })
      map("n", "<leader>tv", function()
        require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
      end, { desc = "Terminal Toggleable vertical term" })

      map("n", "<leader>tf", function()
        require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
      end, { desc = "Terminal Toggle floating term" })
      -- Code runner
      map("n", "<leader>rr", function()
        require("nvchad.term").runner {
          pos = "sp",
          id = "runner",
          clear_cmd = false,
          cmd = function()
            return require "configs.runner"()
          end,
        }
      end, { desc = "Runner Run Current File" })
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
  {
    "nvchad/volt",
    config = function()
      local map = vim.keymap.set
      map("n", "<leader>q", function()
        require("volt").close()
      end, { desc = "Window Close all Volt windows" })
    end,
  },
  {
    "nvchad/minty",
    config = function()
      local map = vim.keymap.set
      -- Color pickers Hue and Shades
      map("n", "<leader>cph", function()
        require("volt").close()
        require("minty.huefy").open()
      end, { desc = "Colors Show Hue picker" })
      map("n", "<leader>cps", function()
        require("volt").close()
        require("minty.shades").open()
      end, { desc = "Colors Show Shades picker" })
    end,
  },
  {
    "nvchad/menu",
    config = function()
      local map = vim.keymap.set
      map("n", "<RightMouse>", function()
        vim.cmd.exec '"normal! \\<RightMouse>"'

        local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
        require("menu").open(options, { mouse = true })
      end, { desc = "Menu Open Context menu" })
    end,
  },
}
