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
              modified = "[+]",
              readonly = "[-]",
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
        ignore_focus = {},
        sections = sections,
        inactive_sections = sections,
        extensions = { "trouble", "mason", "lazy" },
      }
      require("lualine").setup(opts)
      local colors = require "colors"
      colors.add_color_module("lualine_transparent", function()
        vim.api.nvim_set_hl(0, "lualine_c_normal", {
          bg = "NONE",
        })
        vim.api.nvim_set_hl(0, "lualine_c_transparent", {
          bg = "NONE",
        })
      end)
      if vim.g.transparent_enabled then
        colors.set_colors "lualine_transparent"
        require("transparent").clear_prefix "lualine_x"
      end
      colors.add_and_set_color_module("lualine", function()
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
      -- { "<leader>dm", "<cmd>Noice dismiss<CR>", desc = "Noice Dismiss messages" },
    },
    opts = {
      presets = {
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
        enabled = true,
      },
      notify = {
        enabled = true,
      },
      popupmenu = {
        enabled = true,
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
    config = function(_, opts)
      require("noice").setup(opts)
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
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
        local colors = require "colors"
        colors.set_colors "lualine"
        colors.set_colors "bufferline"
        colors.set_colors "ibl"
        require("utils").run_global_function "ibl_setup"
        colors.set_colors "telescope"
        if vim.g.transparent_enabled then
          colors.set_colors "lualine_transparent"
          transparent.clear_prefix "lualine_x"
          transparent.clear_prefix "TabLineFill"
        end
      end
      vim.api.nvim_create_user_command("ToggleTransparency", toggle_transparency, {})
    end,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "xiyaowong/transparent.nvim" },
    keys = {
      {
        "<leader>bch",
        function()
          require("bufferline").close_in_direction "left"
        end,
        desc = "Buffer Close buffers to the left",
      },
      {
        "<leader>bcl",
        function()
          require("bufferline").close_in_direction "right"
        end,
        desc = "Buffer Close buffers to the right",
      },
      {
        "<leader>bh",
        function()
          require("bufferline").move(-1)
        end,
        desc = "Buffer Move buffer to left",
      },
      {
        "<leader>bl",
        function()
          require("bufferline").move(1)
        end,
        desc = "Buffer Move buffer to right",
      },
      {
        "<leader>bH",
        "<cmd>BufferLineGoToBuffer 1<CR>",
        desc = "Buffer Go to most left buffer",
      },
      {
        "<leader>bL",
        "<cmd>BufferLineGoToBuffer -1<CR>",
        desc = "Buffer Go to most right buffer",
      },
      { "<tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer Goto next", noremap = true },
      { "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer Goto prev" },
      { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Buffer Pick" },
      { "<leader>bP", "<cmd>BufferLineTogglePin<CR>", desc = "Buffer Toggle Pin" },
      {
        "<leader>tb",
        function()
          local current_status = vim.o.showtabline
          if current_status == 0 then
            vim.o.showtabline = 2
          else
            vim.o.showtabline = 0
          end
        end,
        desc = "Toggle Bufferline",
      },
    },
    opts = function()
      local M = {}

      local bufferline = require "bufferline"

      M.options = {
        mode = "buffers",
        style_preset = bufferline.style_preset.default,
        themable = true,
        numbers = "ordinal",
        close_command = "confirm bd %d",
        right_mouse_command = false,
        left_mouse_command = "buffer %d",
        middle_mouse_command = "confirm bd %d",
        indicator = {
          style = "underline",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "● ",
        close_icon = " ",
        left_trunc_marker = " ",
        right_trunc_marker = " ",
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_update_on_event = true,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for error_level, error_count in pairs(diagnostics_dict) do
            local icon
            if error_level:match "error" then
              icon = " "
            elseif error_level:match "warning" then
              icon = " "
            elseif error_level:match "hint" then
              icon = " "
            elseif error_level:match "info" then
              icon = "󰋼 "
            else
              icon = " "
            end
            s = s .. error_count .. icon
          end
          return s
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = true,
        get_element_icon = function(element)
          local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        duplicates_across_groups = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        separator_style = "thick",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        auto_toggle_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current",
      }

      M.setup_custom_colors = function()
        local colors = require "colors"
        colors.add_color_module("bufferline", function()
          vim.api.nvim_set_hl(0, "BufferLineSeparator", {
            fg = "#ffffff",
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorVisible", {
            fg = "#f38ba8",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorSelected", {
            fg = "#f38ba8",
            sp = "#f38ba8",
            cterm = { bold = true, underline = true, italic = true },
            bold = true,
            underline = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorDiagnostic", {
            fg = "#f38ba8",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorDiagnosticSelected", {
            fg = "#f38ba8",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorDiagnosticVisible", {
            fg = "#f38ba8",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningVisible", {
            fg = "#fae3b0",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningSelected", {
            fg = "#fae3b0",
            sp = "#fae3b0",
            cterm = { bold = true, underline = true, italic = true },
            bold = true,
            underline = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningDiagnostic", {
            fg = "#fae3b0",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningDiagnosticSelected", {
            fg = "#fae3b0",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningDiagnosticVisible", {
            fg = "#fae3b0",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineHintVisible", {
            fg = "#d0a9e5",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineHintSelected", {
            fg = "#d0a9e5",
            sp = "#d0a9e5",
            cterm = { bold = true, underline = true, italic = true },
            bold = true,
            underline = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineHintDiagnostic", {
            fg = "#d0a9e5",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineHintDiagnosticSelected", {
            fg = "#d0a9e5",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineHintDiagnosticVisible", {
            fg = "#d0a9e5",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoVisible", {
            fg = "#abe9b3",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoSelected", {
            fg = "#abe9b3",
            sp = "#abe9b3",
            cterm = { bold = true, underline = true, italic = true },
            bold = true,
            underline = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoDiagnostic", {
            fg = "#abe9b3",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoDiagnosticSelected", {
            fg = "#abe9b3",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoDiagnosticVisible", {
            fg = "#abe9b3",
            cterm = { bold = true, italic = true },
            bold = true,
            italic = true,
          })
          vim.api.nvim_set_hl(0, "BufferLineSeparator", {
            fg = "#ffffff",
          })
          vim.api.nvim_set_hl(0, "BufferLineBufferSelected", {
            fg = "#e0e2ea",
            sp = "#e0e2ea",
            bold = true,
            italic = true,
            underline = true,
          })
        end)
        vim.schedule(function()
          colors.set_colors "bufferline"
        end)
      end

      local constants = require "bufferline.constants"
      local bufferline_colors = require "bufferline.colors"
      local highlights = require "bufferline.highlights"
      local visibility = constants.visibility
      local PREFIX = "BufferLine"
      local icon_hl_cache = {}

      M.set_icon_highlight_func = function(state, hls, base_hl)
        local preset = vim.tbl_get(require("bufferline.config").get(), "user", "options", "style_preset")
        if type(preset) ~= "table" then
          preset = { preset }
        end
        local is_minimal = vim.tbl_contains(preset, bufferline.style_preset.minimal)
        local italic = not vim.tbl_contains(preset, bufferline.style_preset.italic)
        local bold = not vim.tbl_contains(preset, bufferline.style_preset.bold)

        local transparent_inactive = {
          fg = hls.buffer_visible.fg,
          bg = "NONE",
          italic = is_minimal and italic,
          bold = is_minimal and bold,
        }
        local transparent_selected = {
          fg = hls.buffer_selected.fg,
          bg = "NONE",
          italic = italic,
          bold = bold,
          sp = hls.buffer_selected.sp,
          underline = hls.buffer_selected.underline,
        }
        local transparent_background = {
          fg = hls.background.fg,
          bg = "NONE",
        }
        local state_props = ({
          [visibility.INACTIVE] = { "Inactive", transparent_inactive },
          [visibility.SELECTED] = { "Selected", transparent_selected },
          [visibility.NONE] = { "", transparent_background },
        })[state]
        local icon_hl, parent = PREFIX .. base_hl .. state_props[1], state_props[2]
        if icon_hl_cache[icon_hl] then
          return icon_hl
        end

        local color_icons = M.options.color_icons
        local color = not color_icons and "NONE"
        local hl_colors = vim.tbl_extend("force", parent, {
          fg = color or bufferline_colors.get_color { name = base_hl, attribute = "fg" },
          ctermfg = color or bufferline_colors.get_color { name = base_hl, attribute = "fg", cterm = true },
          italic = false,
          bold = false,
          hl_group = icon_hl,
        })
        highlights.set(icon_hl, hl_colors)
        icon_hl_cache[icon_hl] = true
        return icon_hl
      end

      M.reset_icon_hl_cache_func = function()
        icon_hl_cache = {}
      end

      return M
    end,
    config = function(_, opts)
      require("bufferline").setup { options = opts.options }
      opts.setup_custom_colors()
      if vim.g.transparent_enabled then
        local bufferline_highlights = require "bufferline.highlights"
        bufferline_highlights.set_icon_highlight = opts.set_icon_highlight_func
        bufferline_highlights.reset_icon_hl_cache = opts.reset_icon_hl_cache_func
        require("transparent").clear_prefix "BufferLine"
      end
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = { "BufEnter", "BufNewFile" },
    opts = {},
  },
  {
    "y3owk1n/undo-glow.nvim",
    event = { "VeryLazy" },
    ---@type UndoGlow.Config
    opts = {
      animation = {
        enabled = true,
        duration = 300,
        animation_type = "fade",
        window_scoped = true,
      },
      fallback_for_transparency = {
        bg = "#000000",
        fg = "#FFFFFF",
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
      priority = 2048 * 3,
    },
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
      skip_filetypes = {},
      enabled = false,
      allow_scroll_move = true,
      disable_on_mouse = true,
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
        desc = "Pick Symbol from top bar",
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
