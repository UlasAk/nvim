return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      "<leader>",
      "<c-r>",
      "<c-w>",
      '"',
      "'",
      "`",
      "c",
      "v",
      "g",
      "\\",
      { "<leader>wka", "<cmd>WhichKey<CR>", desc = "Whichkey Keymaps (all)" },
      {
        "<leader>wkc",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Whichkey Keymaps (current buffer)",
      },
      {
        "<leader>wkq",
        function()
          vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
        end,
        desc = "Whichkey Query lookup",
      },
    },
    cmd = "WhichKey",
    opts = function()
      ---@class wk.Opts
      return {
        ---@type false | "classic" | "modern" | "helix"
        preset = "modern",
        ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
        delay = function(ctx)
          return ctx.plugin and 0 or 200
        end,
        ---@param mapping wk.Mapping
        filter = function(mapping)
          return true
        end,
        ---@type wk.Spec
        spec = {},
        notify = true,
        triggers = {
          { "<auto>", mode = "nixsotc" },
        },
        defer = function(ctx)
          return ctx.mode == "V" or ctx.mode == "<C-V>"
        end,
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        ---@type wk.Win
        win = {
          no_overlap = true,
          padding = { 1, 2 },
          title = true,
          title_pos = "center",
          zindex = 1000,
          bo = {},
          wo = {},
        },
        layout = {
          width = { min = 20 },
          spacing = 3,
          align = "left",
        },
        keys = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        ---@type (string|wk.Sorter)[]
        sort = { "local", "order", "group", "alphanum", "mod" },
        ---@type number|fun(node: wk.Node):boolean?
        expand = 0,
        ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
        replace = {
          key = {
            function(key)
              return require("which-key.view").format(key)
            end,
          },
          desc = {
            { "<Plug>%((.*)%)", "%1" },
            { "^%+", "" },
            { "<[cC]md>", "" },
            { "<[cC][rR]>", "" },
            { "<[sS]ilent>", "" },
            { "^lua%s+", "" },
            { "^call%s+", "" },
            { "^:%s*", "" },
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          ellipsis = "…",
          ---@type wk.IconRule[]|false
          rules = {},
          colors = true,
          keys = {
            Up = " ",
            Down = " ",
            Left = " ",
            Right = " ",
            C = "󰘴 ",
            M = "󰘵 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰌑 ",
            BS = "⌫",
            Space = "󱁐 ",
            Tab = "󰌒 ",
            F1 = "󱊫",
            F2 = "󱊬",
            F3 = "󱊭",
            F4 = "󱊮",
            F5 = "󱊯",
            F6 = "󱊰",
            F7 = "󱊱",
            F8 = "󱊲",
            F9 = "󱊳",
            F10 = "󱊴",
            F11 = "󱊵",
            F12 = "󱊶",
          },
        },
        show_help = true,
        show_keys = true,
        disable = {
          ft = {},
          bt = {},
        },
        debug = false,
      }
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>", desc = "Window Go to window left (with tmux)" },
      { "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>", desc = "Window Go to window down (with tmux)" },
      { "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>", desc = "Window Go to window up (with tmux)" },
      { "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>", desc = "Window Go to Window right (with tmux)" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>", desc = "Window Go to previous Window (with tmux)" },
    },
  },
}
