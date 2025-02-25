return {
  {
    "echasnovski/mini.animate",
    version = false,
    opts = {
      -- Cursor path
      cursor = {
        -- Whether to enable this animation
        enable = false,

        -- Timing of animation (how steps will progress in time)
        -- timing = --<function: implements linear total 250ms animation duration>,

        -- Path generator for visualized cursor movement
        -- path = --<function: implements shortest line path>,
      },

      -- Vertical scroll
      scroll = {
        -- Whether to enable this animation
        enable = false,

        -- Timing of animation (how steps will progress in time)
        -- timing = --<function: implements linear total 250ms animation duration>,

        -- Subscroll generator based on total scroll
        -- subscroll = --<function: implements equal scroll with at most 60 steps>,
      },

      -- Window resize
      resize = {
        -- Whether to enable this animation
        enable = true,

        -- Timing of animation (how steps will progress in time)
        -- timing = --<function: implements linear total 250ms animation duration>,

        -- Subresize generator for all steps of resize animations
        -- subresize = --<function: implements equal linear steps>,
      },

      -- Window open
      open = {
        -- Whether to enable this animation
        enable = true,

        -- Timing of animation (how steps will progress in time)
        -- timing = --<function: implements linear total 250ms animation duration>,

        -- Floating window config generator visualizing specific window
        -- winconfig = --<function: implements static window for 25 steps>,

        -- 'winblend' (window transparency) generator for floating window
        -- winblend = --<function: implements equal linear steps from 80 to 100>,
      },

      -- Window close
      close = {
        -- Whether to enable this animation
        enable = true,

        -- Timing of animation (how steps will progress in time)
        -- timing = --<function: implements linear total 250ms animation duration>,

        -- Floating window config generator visualizing specific window
        -- winconfig = --<function: implements static window for 25 steps>,

        -- 'winblend' (window transparency) generator for floating window
        -- winblend = --<function: implements equal linear steps from 80 to 100>,
      },
    },
  },
  {
    "echasnovski/mini.misc",
    version = false,
    opts = {
      -- Array of fields to make global (to be used as independent variables)
      make_global = { "put", "put_text" },
    },
  },
  {
    "echasnovski/mini.move",
    version = false,
    event = "BufReadPost",
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = "<M-Left>",
        right = "<M-Right>",
        down = "<M-Down>",
        up = "<M-Up>",

        -- Move current line in Normal mode
        line_left = "<M-Left>",
        line_right = "<M-Right>",
        line_down = "<M-Down>",
        line_up = "<M-Up>",
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    },
  },
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      {
        "<leader>m",
        function()
          require("mini.files").open()
        end,
        desc = "Mini Files",
      },
    },
  },
  {
    "echasnovski/mini.ai",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Table with textobject id as fields, textobject specification as values.
      -- Also use this to disable builtin textobjects. See |MiniAi.config|.
      custom_textobjects = nil,

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Main textobject prefixes
        around = "a",
        inside = "i",

        -- Next/last variants
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",

        -- Move cursor to corresponding edge of `a` textobject
        goto_left = "g[",
        goto_right = "g]",
      },

      -- Number of lines within which textobject is searched
      n_lines = 50,

      -- How to search for object (first inside current line, then inside
      -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
      search_method = "cover_or_next",

      -- Whether to disable showing non-error feedback
      -- This also affects (purely informational) helper messages shown after
      -- idle time if user input is required.
      silent = false,
    },
  },
}
