return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        transparent_background = true,
        float = {
          transparent = true,
        },
        custom_highlights = function(colors)
          return {
            SnacksDashboardHeader = { fg = colors.yellow },
            NoiceCmdlinePrompt = { fg = colors.yellow },
            NoiceCmdlinePopupBorder = { fg = colors.yellow },
            DevIconDart = { fg = "#5fc9f8" },
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
            scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
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
            indent_scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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

        -- type: Device
        local device = decorations.device
        if device then
          table.insert(information_table, device.name)
        end

        -- tpye: flutter.ProjectConfig
        local project_config = decorations.project_config
        if project_config and project_config.name then
          table.insert(information_table, project_config.name)
        end

        -- type: string
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
      local colors = require "catppuccin.palettes.mocha"
      local sections = {
        lualine_a = {
          { "mode", separator = { right = separators.section_separators.left } },
          { recording, color = { bg = colors.red }, separator = { right = separators.section_separators.left } },
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
            color = { fg = colors.blue },
            separator = { left = separators.section_separators.right, right = "" },
          },
          { custom_separator, color = { fg = colors.blue }, separator = { left = "", right = "" }, padding = 0 },
          { workspace, color = { fg = colors.blue }, separator = { left = "", right = "" } },
        },
        lualine_z = {
          {
            "location",
            color = { bg = colors.yellow },
            separator = { left = separators.section_separators.right, right = "" },
            padding = 1,
          },
          {
            custom_separator,
            color = { fg = colors.crust, bg = colors.yellow },
            separator = { left = "", right = "" },
            padding = 0,
          },
          { "progress", color = { bg = colors.yellow }, separator = { left = "", right = "" }, padding = 1 },
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

      -- Change Noice Mini Background Color (where LSP Progress is shown)
      vim.api.nvim_set_hl(0, "NoiceMini", {
        fg = "#282737",
        bg = "#1E1E2E",
      })
      vim.api.nvim_set_hl(0, "NoiceVirtualText", {
        fg = "#fdfd96",
      })
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    opts = {
      exclude_groups = {
        "IblIndent",
        "IblChar",
        "IblScope",
      },
    },
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
      -- {"<tab>", function()
      --   require("bufferline").cycle(1)
      -- end, desc = "Buffer Goto next" },
      -- {"<S-tab>", function()
      --   require("bufferline").cycle(-1)
      -- end, desc = "Buffer Goto prev" },
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
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        style_preset = bufferline.style_preset.default, -- bufferline.style_preset.default or bufferline.style_preset.minimal,
        themable = true, -- true | false, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = "ordinal", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "confirm bd %d", -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = false, -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = "confirm bd %d", -- can be a string | function, | false see "Mouse actions"
        indicator = {
          -- icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "underline", -- 'icon' | 'underline' | 'none',
        },
        buffer_close_icon = "󰅖",
        modified_icon = "● ",
        close_icon = " ",
        left_trunc_marker = " ",
        right_trunc_marker = " ",
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        -- name_formatter = function(buf) -- buf contains:
        --   -- name                | str        | the basename of the active file
        --   -- path                | str        | the full path of the active file
        --   -- bufnr               | int        | the number of the active buffer
        --   -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
        --   -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
        -- end,
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false, -- only applies to coc
        diagnostics_update_on_event = true, -- use nvim's diagnostic handler
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
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
        -- this will be called a lot so don't do any heavy processing here
        -- custom_filter = function(buf_number, buf_numbers)
        --   -- -- filter out filetypes you don't want to see
        --   -- if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
        --   --     return true
        --   -- end
        --   -- -- filter out by buffer name
        --   -- if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
        --   --     return true
        --   -- end
        --   -- -- filter out based on arbitrary rules
        --   -- -- e.g. filter out vim wiki buffer from tabline in your work repo
        --   -- if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
        --   --     return true
        --   -- end
        --   -- -- filter out by it's index number in list (don't show first buffer)
        --   -- if buf_numbers[1] ~= buf_number then
        --   --     return true
        --   -- end
        -- end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer", -- "File Explorer" | function ,
            text_align = "left", -- "left" | "center" | "right"
            separator = true,
          },
        },
        color_icons = true, -- true | false, -- whether or not to add the filetype icon highlights
        get_element_icon = function(element)
          -- element consists of {filetype: string, path: string, extension: string, directory: string}
          -- This can be used to change how bufferline fetches the icon
          -- for an element e.g. a buffer or a tab.
          -- e.g.
          local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
          -- -- or
          -- local custom_map = {my_thing_ft: {icon = "my_thing_icon", hl}}
          -- return custom_map[element.filetype]
        end,
        show_buffer_icons = true, -- true | false, -- disable filetype icons for buffers
        show_buffer_close_icons = true, -- true | false,
        show_close_icon = true, -- true | false,
        show_tab_indicators = true, -- true | false,
        show_duplicate_prefix = true, -- true | false, -- whether to show duplicate buffer prefix
        duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "thick", -- "slant" | "slope" | "thick" | "thin" | { "any", "any" },
        enforce_regular_tabs = false, -- false | true,
        always_show_bufferline = true, -- true | false,
        auto_toggle_bufferline = true, -- true | false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current", --"insert_after_current"
        -- | "insert_at_end"
        -- | "id"
        -- | "extension"
        -- | "relative_directory"
        -- | "directory"
        -- | "tabs"
        -- | function(buffer_a, buffer_b)
        --   -- add custom logic
        --   local modified_a = vim.fn.getftime(buffer_a.path)
        --   local modified_b = vim.fn.getftime(buffer_b.path)
        --   return modified_a > modified_b
        -- end,
        -- pick = {
        --   alphabet = "abcdefghijklmopqrstuvwxyz",
        -- },
        -- groups = {
        --   options = {
        --     toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
        --   },
        --   items = {
        --     {
        --       name = "Code",
        --       highlight = { underline = true, undercurl = false, sp = "yellow" },
        --       auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
        --       priority = 1, -- determines where it will appear relative to other groups (Optional)
        --       icon = " ", -- Optional
        --       matcher = function(_)
        --         local path = vim.api.nvim_buf_get_name(0)
        --         return path:match ".*src.*"
        --       end,
        --       -- separator = { -- Optional
        --       --   style = require('bufferline.groups').separator.tab
        --       -- },
        --     },
        --     bufferline.groups.builtin.ungrouped,
        --     {
        --       name = "Docs",
        --       highlight = { underline = false, undercurl = true, sp = "blue" },
        --       auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
        --       priority = 2, -- determines where it will appear relative to other groups (Optional)
        --       icon = " ", -- Optional
        --       matcher = function(_)
        --         local path = vim.api.nvim_buf_get_name(0)
        --         return path:match "%.md" or path:match "%.txt"
        --       end,
        --       -- separator = { -- Optional
        --       --   style = require('bufferline.groups').separator.tab
        --       -- },
        --     },
        --   },
        -- },
      }

      M.setup_custom_colors = function()
        vim.schedule(function()
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
      end

      local constants = require "bufferline.constants"
      local colors = require "bufferline.colors"
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
          bg = nil,
          italic = is_minimal and italic,
          bold = is_minimal and bold,
        }
        local transparent_selected = {
          fg = hls.buffer_selected.fg,
          bg = nil,
          italic = italic,
          bold = bold,
          sp = hls.buffer_selected.sp,
          underline = hls.buffer_selected.underline,
        }
        local transparent_background = {
          fg = hls.background.fg,
          bg = nil,
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
          fg = color or colors.get_color { name = base_hl, attribute = "fg" },
          ctermfg = color or colors.get_color { name = base_hl, attribute = "fg", cterm = true },
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
    event = { "BufEnter", "BufNewFile" },
    opts = {},
  },
  -- {
  --   "tamton-aquib/duck.nvim",
  --   keys = {
  --     {
  --       "<leader>dun",
  --       function()
  --         require("duck").hatch()
  --       end,
  --       desc = "Duck Hatch duck",
  --     },
  --     {
  --       "<leader>duk",
  --       function()
  --         require("duck").cook()
  --       end,
  --       desc = "Duck Kill duck",
  --     },
  --     {
  --       "<leader>dua",
  --       function()
  --         require("duck").cook_all()
  --       end,
  --       desc = "Duck Kill all ducks",
  --     },
  --   },
  -- },
  -- {
  --   "shellRaining/hlchunk.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   keys = function()
  --     local indent_chunk_enabled = false
  --     local indent_line_num_enabled = false
  --     return {
  --       {
  --         "<leader>its",
  --         function()
  --           vim.cmd "IBLToggleScope"
  --         end,
  --         { desc = "Indent Toggle Line Number" },
  --         { "<leader>itc", desc = "Indent Toggle Chunks" },
  --         { "<leader>itl", desc = "Indent Toggle Line Number" },
  --       },
  --       {
  --         "<leader>itl",
  --         function()
  --           if indent_line_num_enabled then
  --             vim.cmd "DisableHLChunk"
  --             vim.cmd "DisableHLLineNum"
  --           else
  --             vim.cmd "EnableHLChunk"
  --             vim.cmd "EnableHLLineNum"
  --           end
  --           indent_line_num_enabled = not indent_line_num_enabled
  --         end,
  --         desc = "Indent Toggle Line Number",
  --       },
  --       {
  --         "<leader>itc",
  --         function()
  --           if indent_chunk_enabled then
  --             vim.cmd "DisableHLChunk"
  --           else
  --             vim.cmd "EnableHLChunk"
  --           end
  --           indent_chunk_enabled = not indent_chunk_enabled
  --         end,
  --         desc = "Indent Toggle Chunks",
  --       },
  --     }
  --   end,
  --   opts = {
  --     chunk = {
  --       enable = true,
  --       -- style = "#fdfd96",
  --       duration = 0,
  --       delay = 0,
  --     },
  --     indent = {
  --       enable = false,
  --     },
  --     line_num = {
  --       enable = false,
  --       style = "#fdfd96",
  --     },
  --     blank = {
  --       enable = false,
  --     },
  --   },
  -- },
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
        bg = "#000000", -- fallback color for when the highlight is transparent
        fg = "#FFFFFF", -- fallback color for when the highlight is transparent
      },
      highlights = {
        undo = {
          hl_color = { bg = "#693232" }, -- Dark muted red
        },
        redo = {
          hl_color = { bg = "#2F4640" }, -- Dark muted green
        },
        yank = {
          hl_color = { bg = "#7A683A" }, -- Dark muted yellow
        },
        paste = {
          hl_color = { bg = "#325B5B" }, -- Dark muted cyan
        },
        search = {
          hl_color = { bg = "#5C475C" }, -- Dark muted purple
        },
        comment = {
          hl_color = { bg = "#7A5A3D" }, -- Dark muted orange
        },
        cursor = {
          hl_color = { bg = "#793D54" }, -- Dark muted pink
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
      -- {
      --   "n",
      --   function()
      --     require("undo-glow").search_next {
      --       animation = {
      --         animation_type = "strobe",
      --       },
      --     }
      --   end,
      --   mode = "n",
      --   desc = "Search next with highlight",
      --   noremap = true,
      -- },
      -- {
      --   "N",
      --   function()
      --     require("undo-glow").search_prev {
      --       animation = {
      --         animation_type = "strobe",
      --       },
      --     }
      --   end,
      --   mode = "n",
      --   desc = "Search prev with highlight",
      --   noremap = true,
      -- },
      -- {
      --   "*",
      --   function()
      --     require("undo-glow").search_star {
      --       animation = {
      --         animation_type = "strobe",
      --       },
      --     }
      --   end,
      --   mode = "n",
      --   desc = "Search star with highlight",
      --   noremap = true,
      -- },
      -- {
      --   "#",
      --   function()
      --     require("undo-glow").search_hash {
      --       animation = {
      --         animation_type = "strobe",
      --       },
      --     }
      --   end,
      --   mode = "n",
      --   desc = "Search hash with highlight",
      --   noremap = true,
      -- },
      -- {
      --   "gc",
      --   function()
      --     -- This is an implementation to preserve the cursor position
      --     local pos = vim.fn.getpos "."
      --     vim.schedule(function()
      --       vim.fn.setpos(".", pos)
      --     end)
      --     return require("undo-glow").comment()
      --   end,
      --   mode = { "n", "x" },
      --   desc = "Toggle comment with highlight",
      --   expr = true,
      --   noremap = true,
      -- },
      -- {
      --   "gc",
      --   function()
      --     require("undo-glow").comment_textobject()
      --   end,
      --   mode = "o",
      --   desc = "Comment textobject with highlight",
      --   noremap = true,
      -- },
      -- {
      --   "gcc",
      --   function()
      --     return require("undo-glow").comment_line()
      --   end,
      --   mode = "n",
      --   desc = "Toggle comment line with highlight",
      --   expr = true,
      --   noremap = true,
      -- },
    },
    init = function()
      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        callback = function()
          local undo_glow = require "undo-glow"
          pcall(undo_glow.yank)
        end,
      })

      -- This only handles neovim instance and do not highlight when switching panes in tmux
      -- vim.api.nvim_create_autocmd("CursorMoved", {
      --   desc = "Highlight when cursor moved significantly",
      --   callback = function()
      --     require("undo-glow").cursor_moved {
      --       animation = {
      --         animation_type = "slide",
      --       },
      --     }
      --   end,
      -- })

      -- This will handle highlights when focus gained, including switching panes in tmux
      -- vim.api.nvim_create_autocmd("FocusGained", {
      --   desc = "Highlight when focus gained",
      --   callback = function()
      --     ---@type UndoGlow.CommandOpts
      --     local opts = {
      --       animation = {
      --         animation_type = "fade",
      --       },
      --     }
      --
      --     opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
      --     local pos = require("undo-glow.utils").get_current_cursor_row()
      --
      --     require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
      --       s_row = pos.s_row,
      --       s_col = pos.s_col,
      --       e_row = pos.e_row,
      --       e_col = pos.e_col,
      --       force_edge = opts.force_edge == nil and true or opts.force_edge,
      --     }))
      --   end,
      -- })

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
  -- {
  --   "folke/zen-mode.nvim",
  --   cmd = { "ZenMode" },
  --   keys = {
  --     { "<leader>Z", "<cmd>ZenMode<CR>", mode = "n", desc = "Zen Toggle Zen Mode" },
  --   },
  --   opts = {
  --     plugins = {
  --       gitsigns = { enabled = false },
  --       twilight = { enabled = false },
  --     },
  --     on_open = function()
  --       require("gitsigns").detach()
  --       vim.o.foldcolumn = "0" -- '0' is not bad
  --     end,
  --     on_close = function()
  --       require("gitsigns").attach()
  --       vim.o.foldcolumn = "1" -- '0' is not bad
  --     end,
  --   },
  -- },
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
      -- The filetype is determined by the vim filetype, not the file extension. In order to get the filetype, open a file and run the command:
      -- :lua print(vim.bo.filetype)
      skip_filetypes = {},
      -- Set to false to disable by default
      enabled = false,
      -- allows scrolling to move the cursor without centering, default recommended
      allow_scroll_move = true,
      -- temporarily disables plugin on left-mouse down, allows natural mouse selection
      -- try disabling if plugin causes lag, function uses vim.on_key
      disable_on_mouse = true,
    },
  },
  -- {
  --   "aidancz/buvvers.nvim",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   keys = {
  --     {
  --       "<leader>tb",
  --       function()
  --         require("buvvers").toggle()
  --       end,
  --       desc = "Toggle Vertical buffer list",
  --     },
  --   },
  --   opts = {
  --     buffer_handle_list_to_buffer_name_list = function(handle_l)
  --       local name_l
  --
  --       local default_function = require "buvvers.buffer_handle_list_to_buffer_name_list"
  --       name_l = default_function(handle_l)
  --
  --       for n, name in ipairs(name_l) do
  --         -- modified prefix
  --         local table_to_add = {}
  --         local is_modified = vim.api.nvim_get_option_value("modified", { buf = handle_l[n] })
  --         local prefix
  --         if is_modified then
  --           prefix = "  "
  --         else
  --           prefix = ""
  --         end
  --         table.insert(table_to_add, { prefix, "BuvversModifiedIcon" })
  --         -- filetype icon
  --         local ok, devicons = pcall(require, "nvim-web-devicons")
  --         local icon = nil
  --         local hl = nil
  --         if ok then
  --           local filetype = vim.filetype.match { filename = name }
  --           local fetched_icon, fetched_hl = devicons.get_icon_by_filetype(filetype, { default = false })
  --           icon = fetched_icon
  --           hl = fetched_hl
  --         end
  --         if icon ~= nil then
  --           local icon_table = { icon .. " " }
  --           if hl ~= nil then
  --             table.insert(icon_table, hl)
  --           end
  --           table.insert(table_to_add, icon_table)
  --         end
  --         -- filename
  --         table.insert(table_to_add, name)
  --
  --         name_l[n] = table_to_add
  --       end
  --
  --       return name_l
  --     end,
  --   },
  --   config = function(_, opts)
  --     vim.api.nvim_set_hl(0, "BuvversModifiedIcon", {
  --       fg = "#50fed8",
  --     })
  --     require("buvvers").setup(opts)
  --     local add_autocmds = function()
  --       vim.api.nvim_create_autocmd({
  --         "BufModifiedSet",
  --       }, {
  --         group = "buvvers",
  --         callback = require("buvvers").buvvers_open,
  --       })
  --     end
  --     vim.api.nvim_create_augroup("buvvers_config", { clear = true })
  --     vim.api.nvim_create_autocmd("User", {
  --       group = "buvvers_config",
  --       pattern = "BuvversAutocmdEnabled",
  --       callback = add_autocmds,
  --     })
  --   end,
  -- },
  -- {
  --   "uga-rosa/ccc.nvim",
  --   cmd = { "CccPick" },
  --   keys = {
  --     { "<leader>ccc", "<cmd>CccPick<CR>", desc = "Colors Change color under cursor" },
  --   },
  --   opts = {},
  -- },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "TermExec" },
    keys = {
      {
        "<leader>Th",
        "<cmd>ToggleTerm direction=horizontal<CR>",
        desc = "Terminal Toggle horizontal term",
      },
      {
        "<leader>Tv",
        "<cmd>ToggleTerm direction=vertical size=60<CR>",
        desc = "Terminal Toggle vertical term",
      },
      {
        "<leader>Tf",
        "<cmd>ToggleTerm direction=float<CR>",
        desc = "Terminal Toggle floating term",
      },
    },
    opts = {
      shell = "/bin/zsh --login",
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
