local options = {

  base46 = {
    theme = "catppuccin",
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = true,
    theme_toggle = { "catppuccin", "everforest_light" },
  },

  ui = {
    cmp = {
      icons = true,
      icons_left = true,
      lspkind_text = true,
      style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
      format_colors = {
        tailwind = true, -- will work for css lsp too
        icon = "󱓻",
      },
    },

    telescope = { style = "bordered" }, -- borderless / bordered

    statusline = {
      enabled = true,
      theme = "default", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "round",
      order = nil,
      modules = nil,
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
      modules = nil,
    },
  },

  nvdash = {
    load_on_startup = false,
    header = {
      "                            ",
      "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
      "   ▄▀███▄     ▄██ █████▀    ",
      "   ██▄▀███▄   ███           ",
      "   ███  ▀███▄ ███           ",
      "   ███    ▀██ ███           ",
      "   ███      ▀ ███           ",
      "   ▀██ █████▄▀█▀▄██████▄    ",
      "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
      "                            ",
      "     Powered By  eovim    ",
      "                            ",
    },

    buttons = {
      { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
      { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
      { txt = "󱥚  Themes", keys = "Spc t h", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "NvDashLazy",
        no_gap = true,
      },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
    },
  },

  term = {
    winopts = { winhl = "Normal:term,WinSeparator:WinSeparator", number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
    excluded_groups = {}, -- can add group name or with mode
  },

  mason = { cmd = true, pkgs = {} },

  colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
  },
}

local sep_style = options.ui.statusline.separator_style

sep_style = (sep_style ~= "round" and sep_style ~= "block") and "block" or sep_style

local default_sep_icons = {
  round = { left = "", right = "" },
  block = { left = "█", right = "█" },
}

local separators = (type(sep_style) == "table" and sep_style) or default_sep_icons[sep_style]

local sep_l = separators["left"]

options.ui.statusline.modules = {
  cursor = function()
    return "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon# %#St_pos_text# %l/%c %p%% "
  end,
  filetype = function()
    local ok, devicons = pcall(require, "nvim-web-devicons")
    local icon, icon_highlight_group
    if ok then
      icon, icon_highlight_group = devicons.get_icon(vim.fn.expand "%:t")
      if icon == nil then
        icon, icon_highlight_group = devicons.get_icon_by_filetype(vim.bo.filetype)
      end
      if icon == nil and icon_highlight_group == nil then
        icon = ""
        icon_highlight_group = "DevIconDefault"
      end
    end
    return "%#" .. icon_highlight_group .. "#" .. icon .. " " .. vim.bo.filetype .. " "
  end,
}

options.ui.statusline.order = {
  "mode",
  "file",
  "git",
  "%=",
  "lsp_msg",
  "%=",
  "diagnostics",
  "lsp",
  "filetype",
  "cwd",
  "cursor",
}

-- return vim.tbl_deep_extend("force", options, require "chadrc")
return options
