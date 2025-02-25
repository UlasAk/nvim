return {
  {
    "folke/noice.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          fps = 60,
          background_colour = "#FDFD9A",
        },
      },
    },
    event = "VeryLazy",
    keys = {
      { "<leader>fmsg", "<cmd>Noice telescope<CR>", desc = "Telescope Messages" },
      -- { "<leader>dm", "<cmd>Noice dismiss<CR>", desc = "Noice Dismiss messages" },
    },
    opts = require "configs.noice",
    config = function(_, opts)
      local noice = require "noice"
      noice.setup(opts)

      -- Statusline Recording
      local statusline = require("chadrc").ui.statusline
      local separator_style = statusline.separator_style
      local separators = require("utils").statusline_separators[separator_style]
      statusline.modules.recording = function()
        if noice.api.statusline.mode.has() then
          local status = noice.api.statusline.mode.get()
          return "%#RecordSepl#"
            .. separators["right"]
            .. "%#Record# "
            .. status
            .. " %#RecordSepr#"
            .. separators["right"]
        end
        return ""
      end
      local function indexOf(table, value)
        for i, v in ipairs(table) do
          if v == value then
            return i
          end
        end
        return nil
      end
      local pos = indexOf(statusline.order, "mode")
      if pos then
        table.insert(statusline.order, pos + 1, "recording")
      end
    end,
  },
  -- {
  --   "nvimdev/dashboard-nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require("dashboard").setup {
  --       theme = "hyper",
  --       shortcut_type = "number",
  --       config = {
  --         week_header = {
  --           enable = true,
  --         },
  --         shortcut = {},
  --         footer = {},
  --       },
  --     }
  -- vim.api.nvim_set_hl(0, "DashboardHeader", {
  --   fg = "#fdfd96",
  -- })
  --   end,
  --   dependencies = { { "nvim-tree/nvim-web-devicons" } },
  -- },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "xiyaowong/transparent.nvim" },
    keys = {
      {
        "<leader>bcl",
        function()
          require("bufferline").close_in_direction "left"
        end,
        desc = "Buffer Close buffers to the left",
      },
      {
        "<leader>bcr",
        function()
          require("bufferline").close_in_direction "right"
        end,
        desc = "Buffer Close buffers to the right",
      },
      {
        "<leader>bl",
        function()
          require("bufferline").move(-1)
        end,
        desc = "Buffer Move buffer to left",
      },
      {
        "<leader>br",
        function()
          require("bufferline").move(1)
        end,
        desc = "Buffer Move buffer to right",
      },
      -- {"<tab>", function()
      --   require("bufferline").cycle(1)
      -- end, desc = "Buffer Goto next" },
      -- {"<S-tab>", function()
      --   require("bufferline").cycle(-1)
      -- end, desc = "Buffer Goto prev" },
      { "<tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer Goto next", noremap = true },
      { "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer Goto prev" },
      { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Buffer Pick" },
    },
    opts = function()
      return require "configs.bufferline"
    end,
    config = function(_, opts)
      require("bufferline").setup { options = opts.options }
      if require("colors").transparent then
        local bufferline_highlights = require "bufferline.highlights"
        bufferline_highlights.set_icon_highlight = opts.set_icon_highlight_func
        bufferline_highlights.reset_icon_hl_cache = opts.reset_icon_hl_cache_func
        require("transparent").clear_prefix "BufferLine"
      end
      opts.setup_custom_colors()
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    opts = {},
  },
  {
    "tamton-aquib/duck.nvim",
    keys = {
      {
        "<leader>dun",
        function()
          require("duck").hatch()
        end,
        desc = "Duck Hatch duck",
      },
      {
        "<leader>duk",
        function()
          require("duck").cook()
        end,
        desc = "Duck Kill duck",
      },
      {
        "<leader>dua",
        function()
          require("duck").cook_all()
        end,
        desc = "Duck Kill all ducks",
      },
    },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = function()
      local indent_chunk_enabled = false
      local indent_line_num_enabled = false
      return {
        {
          "<leader>its",
          function()
            vim.cmd "IBLToggleScope"
          end,
          { desc = "Indent Toggle Line Number" },
          { "<leader>itc", desc = "Indent Toggle Chunks" },
          { "<leader>itl", desc = "Indent Toggle Line Number" },
        },
        {
          "<leader>itl",
          function()
            if indent_line_num_enabled then
              vim.cmd "DisableHLChunk"
              vim.cmd "DisableHLLineNum"
            else
              vim.cmd "EnableHLChunk"
              vim.cmd "EnableHLLineNum"
            end
            indent_line_num_enabled = not indent_line_num_enabled
          end,
          desc = "Indent Toggle Line Number",
        },
        {
          "<leader>itc",
          function()
            if indent_chunk_enabled then
              vim.cmd "DisableHLChunk"
            else
              vim.cmd "EnableHLChunk"
            end
            indent_chunk_enabled = not indent_chunk_enabled
          end,
          desc = "Indent Toggle Chunks",
        },
      }
    end,
    opts = {
      chunk = {
        enable = true,
        style = "#fdfd96",
      },
      indent = {
        enable = false,
      },
      line_num = {
        enable = true,
        style = "#fdfd96",
      },
      blank = {
        enable = false,
      },
    },
    config = function(_, opts)
      require("hlchunk").setup(opts)
      vim.cmd "DisableHLChunk"
      vim.cmd "DisableHLLineNum"
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    keys = { { "u" }, { "<C-r>" } },
    opts = {
      duration = 1000,
      keymaps = {
        paste = {
          disabled = true,
        },
        Paste = {
          disabled = true,
        },
      },
    },
    config = function(_, opts)
      require("highlight-undo").setup(opts)
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    keys = {
      { "<leader>Z", "<cmd>ZenMode<CR>", mode = "n", desc = "Zen Toggle Zen Mode" },
    },
    opts = {
      plugins = {
        gitsigns = { enabled = false },
        twilight = { enabled = false },
      },
      on_open = function()
        require("gitsigns").detach()
      end,
      on_close = function()
        require("gitsigns").attach()
      end,
    },
  },
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
  },
}
