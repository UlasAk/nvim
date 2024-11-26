return {
  {
    "echasnovski/mini.cursorword",
    version = false,
    config = function()
      require("mini.cursorword").setup { delay = 100 }
    end,
  },
  {
    "echasnovski/mini.animate",
    version = false,
    config = function()
      require("mini.animate").setup {
        -- Cursor path
        cursor = {
          -- Whether to enable this animation
          enable = true,

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
      }
    end,
  },
  {
    "echasnovski/mini.jump",
    version = false,
    config = function()
      require("mini.jump").setup {
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          forward = "f",
          backward = "F",
          forward_till = "t",
          backward_till = "T",
          repeat_jump = ";",
        },

        -- Delay values (in ms) for different functionalities. Set any of them to
        -- a very big number (like 10^7) to virtually disable.
        delay = {
          -- Delay between jump and highlighting all possible jumps
          highlight = 250,

          -- Delay between jump and automatic stop if idle (no jump is done)
          idle_stop = 10000000,
        },
      }
    end,
  },
  {
    "echasnovski/mini.misc",
    version = false,
    config = function()
      require("mini.misc").setup {
        -- Array of fields to make global (to be used as independent variables)
        make_global = { "put", "put_text" },
      }
    end,
  },
  {
    "echasnovski/mini.move",
    version = false,
    config = function()
      require("mini.move").setup {
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
          left = "<M-h>",
          right = "<M-l>",
          down = "<M-j>",
          up = "<M-k>",

          -- Move current line in Normal mode
          line_left = "<M-h>",
          line_right = "<M-l>",
          line_down = "<M-j>",
          line_up = "<M-k>",
        },

        -- Options which control moving behavior
        options = {
          -- Automatically reindent selection during linewise vertical move
          reindent_linewise = true,
        },
      }
    end,
  },
}
