return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = function()
          return {
            fps = 60,
            background_colour = "#FDFD9A",
          }
        end,
        config = function(_, opts)
          require("notify").setup(opts)
        end,
      },
    },
    config = function()
      require("noice").setup(require "configs.noice")
      -- Change Noice Mini Background Color (where LSP Progress is shown)
      vim.cmd "hi NoiceMini guifg=#282737 guibg=#1E1E2E"
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      return require "configs.snacks"
    end,
    init = function()
      -- Setup colors
      vim.cmd [[
        hi SnacksDashboardHeader guifg=#fdfd96
      ]]
      vim.cmd [[
        hi SnacksDashboardTitle guifg=#fdfd96
      ]]
      vim.cmd [[
        hi SnacksDashboardFooter guifg=#fdfd96
      ]]

      -- Setup LSP Progress autocmd
      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                  value.kind == "end" and 100 or value.percentage or 100,
                  value.title or "",
                  value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
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
  --     vim.cmd "hi DashboardHeader guifg=#FDFD9A"
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
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "xiyaowong/transparent.nvim" },
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
    config = function()
      require("scrollbar").setup()
    end,
  },
  -- {
  --   "willothy/nvim-cokeline",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for v0.4.0+
  --     "nvim-tree/nvim-web-devicons", -- If you want devicons
  --     "stevearc/resession.nvim", -- Optional, for persistent history
  --   },
  --   config = true,
  -- },
  -- {
  --   "giusgad/pets.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
  --   config = function()
  --     require("pets").setup {
  --       avoid_statusline = true,
  --       winblend = 0,
  --     }
  --   end,
  -- },
}
