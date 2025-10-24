return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        transparent_background = vim.g.transparent_enabled,
        float = {
          transparent = true,
        },
        custom_highlights = function(colors)
          return {
            Pmenu = { bg = "NONE" },
            TabLineFill = { bg = "NONE" },
            SnacksDashboardHeader = { fg = colors.yellow },
            NoiceVirtualText = { fg = colors.yellow, bg = "#45475a" },
            NoiceCmdlinePrompt = { fg = colors.yellow },
            NoiceCmdlinePopupBorder = { fg = colors.yellow },
            NoiceFormatProgressDone = { fg = "#282737", bg = colors.yellow },
            DevIconDart = { fg = "#5fc9f8" },
            LineNr = { fg = "#8886a6" },
            CursorLineNr = { fg = colors.yellow },
            gitCommitComment = { fg = "#8886a6" },
            Record = {
              fg = "#222222",
              bg = "#f38ba8",
              ctermfg = 0,
              ctermbg = 11,
            },
            RecordSepL = {
              fg = "#313244",
              bg = "#f38ba8",
              ctermfg = 0,
              ctermbg = 11,
            },
            RecordSepR = {
              fg = "#f38ba8",
              bg = "#313244",
              ctermfg = 0,
              ctermbg = 11,
            },
            LspReferenceRead = { bg = "#666666" },
            LspReferenceWrite = { bg = "#666666" },
            LspReferenceText = { bg = "#666666" },
          }
        end,
        auto_integrations = true,
        integrations = {
          blink_cmp = {
            style = "bordered",
          },
          dap = true,
          diffview = true,
          dropbar = {
            enabled = true,
            color_mode = true,
          },
          fidget = true,
          flash = true,
          gitsigns = true,
          grug_far = true,
          indent_blankline = {
            enabled = true,
            scope_color = "lavender",
            colored_indent_levels = true,
          },
          lsp_trouble = true,
          mason = true,
          markview = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
              ok = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
              ok = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          neotest = true,
          noice = true,
          nvim_surround = true,
          nvimtree = true,
          octo = true,
          rainbow_delimiters = true,
          snacks = {
            enabled = true,
            indent_scope_color = "lavender",
          },
          treesitter = true,
          treesitter_context = true,
          telescope = {
            enabled = true,
          },
          which_key = true,
        },
      }

      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "xiyaowong/transparent.nvim" },
    event = { "UIEnter" },
    config = function()
      local function workspace()
        return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end
      local function flutterStatusLine()
        local decorations = vim.g.flutter_tools_decorations
        if not decorations then
          return ""
        end

        local information_table = {}

        local device = decorations.device
        if device then
          table.insert(information_table, device.name)
        end

        local project_config = decorations.project_config
        if project_config and project_config.name then
          table.insert(information_table, project_config.name)
        end

        local app_version = decorations.app_version
        if app_version then
          local comment_pos, _ = string.find(app_version, "#")
          if comment_pos then
            app_version = string.gsub(string.sub(app_version, 0, comment_pos - 1), "%s+", "")
          end
          table.insert(information_table, app_version)
        end

        return table.concat(information_table, " - ")
      end
      local function node_package_info()
        local ok, package_info = pcall(require, "package-info")
        if ok then
          return package_info.get_status()
        end
        return ""
      end
      local function recording()
        local ok, noice = pcall(require, "noice")
        if ok then
          if noice.api.statusline.mode.has() then
            local status = noice.api.statusline.mode.get()
            return status
          end
          return ""
        end
        return ""
      end
      local function custom_separator()
        return "|"
      end
      local separators = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      }
      local catppuccin_colors = require "catppuccin.palettes.mocha"
      local sections = {
        lualine_a = {
          { "mode", separator = { right = separators.section_separators.left } },
          {
            recording,
            color = { bg = catppuccin_colors.red },
            separator = { right = separators.section_separators.left },
          },
        },
        lualine_b = {
          {
            "filename",
            color = { fg = "lavender" },
            file_status = true,
            newfile_status = true,
            symbols = {
              modified = "●",
              readonly = "󰏯",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_c = { "branch", "diff" },
        lualine_x = {
          "searchcount",
          "selectioncount",
          node_package_info,
          flutterStatusLine,
          {
            "lsp_status",
            icon = "",
            symbols = {
              spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
              done = "✓",
              separator = " ",
            },
            ignore_lsp = {},
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic", "nvim_lsp" },
            sections = { "error", "warn", "info", "hint" },
          },
        },
        lualine_y = {
          {
            "filetype",
            color = { fg = catppuccin_colors.blue },
            separator = { left = separators.section_separators.right, right = "" },
          },
          {
            custom_separator,
            color = { fg = catppuccin_colors.blue },
            separator = { left = "", right = "" },
            padding = 0,
          },
          { workspace, color = { fg = catppuccin_colors.blue }, separator = { left = "", right = "" } },
        },
        lualine_z = {
          {
            "location",
            color = { bg = catppuccin_colors.yellow },
            separator = { left = separators.section_separators.right, right = "" },
            padding = 1,
          },
          {
            custom_separator,
            color = { fg = catppuccin_colors.crust, bg = catppuccin_colors.yellow },
            separator = { left = "", right = "" },
            padding = 0,
          },
          { "progress", color = { bg = catppuccin_colors.yellow }, separator = { left = "", right = "" }, padding = 1 },
        },
      }
      local opts = {
        options = {
          theme = "catppuccin",
          section_separators = separators.section_separators,
          component_separators = separators.component_separators,
          globalstatus = true,
          refresh = {
            statusline = 32,
          },
        },
        sections = sections,
        inactive_sections = sections,
        extensions = { "trouble", "mason", "lazy" },
      }
      require("lualine").setup(opts)
      require("colors").add_and_set_color_module("lualine", function()
        if vim.g.transparent_enabled then
          vim.api.nvim_set_hl(0, "lualine_c_normal", {
            bg = "NONE",
          })
          vim.api.nvim_set_hl(0, "lualine_c_transparent", {
            bg = "NONE",
          })
          require("transparent").clear_prefix "lualine_x"
          require("transparent").clear_prefix "lualine_transitional_lualine_b"
          require("transparent").clear_prefix "lualine_transitional_lualine_y"
        end
        vim.api.nvim_set_hl(0, "lualine_c_diff_added_normal", {
          fg = "#a6e3a1",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_modified_normal", {
          fg = "#f9e2af",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_removed_normal", {
          fg = "#f38ba8",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_added_insert", {
          fg = "#a6e3a1",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_modified_insert", {
          fg = "#f9e2af",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_removed_insert", {
          fg = "#f38ba8",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_added_command", {
          fg = "#a6e3a1",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_modified_command", {
          fg = "#f9e2af",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_removed_command", {
          fg = "#f38ba8",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_added_replace", {
          fg = "#a6e3a1",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_modified_replace", {
          fg = "#f9e2af",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_removed_replace", {
          fg = "#f38ba8",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_added_terminal", {
          fg = "#a6e3a1",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_modified_terminal", {
          fg = "#f9e2af",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_removed_terminal", {
          fg = "#f38ba8",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_added_inactive", {
          fg = "#a6e3a1",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_modified_inactive", {
          fg = "#f9e2af",
        })
        vim.api.nvim_set_hl(0, "lualine_c_diff_removed_inactive", {
          fg = "#f38ba8",
        })
      end)
    end,
  },
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
      { "<leader>fn", "<cmd>Noice telescope<CR>", desc = "Notifications Show history" },
    },
    opts = {
      presets = {
        bottom_search = true,
        inc_rename = {
          cmdline = {
            format = {
              IncRename = {
                pattern = "^:%s*IncRename%s+",
                icon = " ",
                conceal = true,
                opts = {
                  relative = "cursor",
                  size = { min_width = 20 },
                  position = { row = -3, col = 0 },
                },
              },
            },
          },
        },
      },
      cmdline = {
        format = {
          input = { view = "cmdline" },
        },
      },
      popupmenu = {
        backend = "cmp",
      },
      lsp = {
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
      commands = {
        history = {
          filter = {},
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "Code actions:",
          },
          opts = { replace = false },
        },
        {
          filter = {
            warning = true,
            find = "angularls",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      extra_groups = {
        "NormalFloat",
      },
      exclude_groups = {
        "IndentBlanklineChar",
        "IndentBlanklineContextChar",
        "IndentBlanklineContextStart",
        "IblIndent",
        "IblChar",
        "IblScope",
      },
    },
    keys = {
      { "<leader>tt", "<CMD>ToggleTransparency<CR>", desc = "toggle transparency" },
    },
    config = function(_, opts)
      local transparent = require "transparent"
      transparent.setup(opts)
      local toggle_transparency = function()
        transparent.toggle()
        require("colors").set_all_colors()
        require("utils").run_global_function "ibl_setup"
      end
      vim.api.nvim_create_user_command("ToggleTransparency", toggle_transparency, {})
    end,
  },
  {
    "y3owk1n/undo-glow.nvim",
    event = { "VeryLazy" },
    keys = {
      {
        "u",
        function()
          local unde_glow = require "undo-glow"
          pcall(unde_glow.undo)
        end,
        mode = "n",
        desc = "Undo with highlight",
        noremap = true,
      },
      {
        "<C-r>",
        function()
          local unde_glow = require "undo-glow"
          pcall(unde_glow.redo)
        end,
        mode = "n",
        desc = "Redo with highlight",
        noremap = true,
      },
      {
        "p",
        function()
          local unde_glow = require "undo-glow"
          pcall(unde_glow.paste_below)
        end,
        mode = "n",
        desc = "Paste below with highlight",
        noremap = true,
      },
      {
        "P",
        function()
          local unde_glow = require "undo-glow"
          pcall(unde_glow.paste_above)
        end,
        mode = "n",
        desc = "Paste above with highlight",
        noremap = true,
      },
    },
    opts = {
      animation = {
        enabled = true,
        duration = 300,
      },
      highlights = {
        undo = {
          hl_color = { bg = "#693232" },
        },
        redo = {
          hl_color = { bg = "#2F4640" },
        },
        yank = {
          hl_color = { bg = "#7A683A" },
        },
        paste = {
          hl_color = { bg = "#325B5B" },
        },
        search = {
          hl_color = { bg = "#5C475C" },
        },
        comment = {
          hl_color = { bg = "#7A5A3D" },
        },
        cursor = {
          hl_color = { bg = "#793D54" },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        callback = function()
          local undo_glow = require "undo-glow"
          pcall(undo_glow.yank)
        end,
      })

      vim.api.nvim_create_autocmd("CmdLineLeave", {
        pattern = { "/", "?" },
        desc = "Highlight when search cmdline leave",
        callback = function()
          require("undo-glow").search_cmd {
            animation = {
              animation_type = "fade",
            },
          }
        end,
      })
    end,
  },
  {
    "arnamak/stay-centered.nvim",
    keys = function()
      local enabled = false
      return {
        {
          "<leader>tc",
          function()
            enabled = not enabled
            require("stay-centered").toggle()
            Snacks.notify(enabled and "Enabled" or "Disabled", { title = "Stay Centered" })
          end,
          mode = { "n", "v" },
          desc = "Toggle stay-centered.nvim",
        },
      }
    end,
    opts = {
      enabled = false,
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Window Resize right",
      },
      {
        "<Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Window Resize left",
      },
      {
        "<Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Window Resize up",
      },
      {
        "<Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Window Resize down",
      },
      {
        "<M-Right>",
        function()
          require("smart-splits").swap_buf_right()
        end,
        desc = "Window Swap right",
      },
      {
        "<M-Left>",
        function()
          require("smart-splits").swap_buf_left()
        end,
        desc = "Window Swap left",
      },
      {
        "<M-Up>",
        function()
          require("smart-splits").swap_buf_up()
        end,
        desc = "Window Swap up",
      },
      {
        "<M-Down>",
        function()
          require("smart-splits").swap_buf_down()
        end,
        desc = "Window Swap down",
      },
    },
    opts = {},
  },
  {
    "b0o/incline.nvim",
    event = { "BufReadPost", "BufEnter" },
    opts = {
      render = function(props)
        local helpers = require "incline.helpers"
        local devicons = require "nvim-web-devicons"
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        return {
          ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
          " ",
          { filename, gui = modified and "bold,italic" or "bold" },
          " ",
          guibg = "#44406e",
        }
      end,
      hide = {
        cursorline = true,
        focused_win = true,
      },
      window = {
        margin = {
          vertical = 2,
        },
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>;",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Dropbar Pick symbol",
      },
      {
        "<leader>td",
        function()
          if vim.o.winbar == "" then
            vim.o.winbar = "%{%v:lua.dropbar()%}"
          else
            vim.o.winbar = ""
          end
        end,
        desc = "Toggle Dropbar (breadcrumbs)",
      },
    },
    opts = {},
  },
}
