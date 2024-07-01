local trouble = require "trouble.sources.telescope"

local options = {
  pickers = {
    live_grep = {
      additional_args = { "--no-ignore", "--hidden" },
    },
    find_file = {
      hidden = false,
    },
  },
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { ".git" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      i = {
        ["<c-t>"] = trouble.open,
        ["<C-Down>"] = require("telescope.actions").preview_scrolling_down,
        ["<C-Up>"] = require("telescope.actions").preview_scrolling_up,
        ["<C-Left>"] = require("telescope.actions").preview_scrolling_left,
        ["<C-Right>"] = require("telescope.actions").preview_scrolling_right,
      },
      n = {
        ["q"] = require("telescope.actions").close,
        ["<c-t>"] = trouble.open,
        ["<C-Down>"] = require("telescope.actions").preview_scrolling_down,
        ["<C-Up>"] = require("telescope.actions").preview_scrolling_up,
        ["<C-Left>"] = require("telescope.actions").preview_scrolling_left,
        ["<C-Right>"] = require("telescope.actions").preview_scrolling_right,
      },
    },
  },

  extensions_list = { "themes", "terms", "ui-select" },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    media_files = {
      filetypes = { "png", "webp", "jpg", "jpeg", "pdf", "webm", "mp4" },
      find_cmd = "rg",
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
}

return options
