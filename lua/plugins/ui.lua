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
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>dn",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Notifications Dismiss notifications",
      },
      {
        "<leader>fn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notifications Show history",
      },
    },
    opts = require "configs.snacks",
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
      vim.cmd [[
        hi SnacksDashboardDir guifg=#8886a6
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
    lazy = false,
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "xiyaowong/transparent.nvim" },
    keys = {
      {
        "<leader>ba",
        function()
          require("bufferline").close_others()
        end,
        desc = "Buffer Close all except for current",
      },
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
      {
        "<leader>x",
        function()
          require("utils").close_buffer()
          require("bufferline.ui").refresh()
        end,
        desc = "Buffer Close",
      },
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
