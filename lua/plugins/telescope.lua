return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    keys = {
      -- Diagnostics
      {
        "<leader>lda",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Diagnostics All Diagnostics",
      },
      {
        "<leader>ldc",
        function()
          require("telescope.builtin").diagnostics { bufnr = 0 }
        end,
        desc = "Diagnostics Diagnostics Current Buf",
      },
      -- Other
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Telescope Buffers" },
      { "<leader>fhe", "<cmd>Telescope help_tags<CR>", desc = "Telescope Help page" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Telescope Oldfiles" },
      {
        "<leader><leader>",
        function()
          require("telescope.builtin").oldfiles { only_cwd = true }
        end,
        desc = "Telescope Oldfiles in cwd",
      },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope Current Buffer" },
      { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "Telescope Git commits" },
      { "<leader>fgt", "<cmd>Telescope git_status<CR>", desc = "Telescope Git status" },
      { "<leader>fgh", "<cmd>Telescope git_file_history<CR>", desc = "Telescope Git file history" },
      { "<leader>fte", "<cmd>Telescope terms<CR>", desc = "Telescope Terminals" },
      {
        "<leader>fa",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        desc = "Telescope Files (all)",
      },
      {
        "<leader>fth",
        function()
          require("nvchad.themes").open { style = "flat", border = false }
        end,
        desc = "Telescope Themes (NVChad)",
      },
      {
        '<leader>f"',
        function()
          require("telescope.builtin").registers()
        end,
        desc = "Telescope Registers",
      },
      { "<leader>fj", "<cmd>Telescope jumplist<CR>", desc = "Telescope Jumplist" },
      { "<leader>fco", "<cmd>Telescope commands<CR>", desc = "Telescope Commands" },
      { "<leader>fch", "<cmd>Telescope command_history<CR>", desc = "Telescope Command history" },
      { "<leader>fv", "<cmd>Telescope vim_options<CR>", desc = "Telescope Vim Options" },
      { "<leader>fsy", "<cmd>Telescope treesitter<CR>", desc = "Telescope Symbols" },
      { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Telescope Resume last search" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Telescope Keybindings" },
      { "<leader>fma", "<cmd>Telescope marks<CR>", desc = "Telescope Marks" },
      { "<leader>fgs", "<cmd>Telescope grep_string<CR>", mode = { "n", "v" }, desc = "Telescope Grep String" },
      { "<leader>fme", "<cmd>Telescope media_files<CR>", desc = "Telescope Media" },
      {
        "<leader>fz",
        function()
          local saved_reg = vim.fn.getreg "v"
          vim.cmd [[noautocmd sil norm! "vy]]
          local selection = vim.fn.getreg "v"
          vim.fn.setreg("v", saved_reg)
          if selection == nil then
            return nil
          end
          require("telescope.builtin").current_buffer_fuzzy_find {
            default_text = selection,
          }
        end,
        mode = { "v" },
        desc = "Telescope Current Buffer",
      },
      { "<leader>fhi", "<cmd>Telescope highlights<CR>", desc = "Telescope Highlights" },
    },
    opts = function()
      return require "configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end

      vim.api.nvim_set_hl(0, "TelescopeMatching", {
        fg = "#89b4fa",
        bg = "#76758a",
      })
      vim.api.nvim_set_hl(0, "TelescopeSelection", {
        fg = "#d9e0ee",
        bg = "#5c5a82",
      })
    end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>fw", "<cmd>Telescope live_grep_args<CR>", desc = "Telescope Live grep" },
    },
    opts = function()
      local lga_actions = require "telescope-live-grep-args.actions"
      return {
        extensions = {
          live_grep_args = {
            additional_args = { "--no-ignore", "--hidden" },
            file_ignore_patterns = {},
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
                -- freeze the current list and start a fuzzy search in the frozen list
                ["<C-space>"] = lga_actions.to_fuzzy_refine,
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension "live_grep_args"
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "LspAttach",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<leader>lca",
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "n", "v", "x" },
        desc = "Lsp Code action",
      },
    },
    opts = require "configs.actions-preview",
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = { "nvim-lua/popup.nvim", "nvim-telescope/telescope.nvim" },
    cmd = "Telescope media_files",
    config = function()
      require("telescope").load_extension "media_files"
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "TodoTelescope",
    keys = {
      { "<leader>fto", "<cmd>TodoTelescope<CR>", desc = "Telescope TODOs" },
    },
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {

      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon Add",
      },
      {
        "<leader>hp",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon Previous",
      },
      {
        "<leader>hn",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon Next",
      },
      {
        "<leader>hl",
        function()
          local harpoon = require "harpoon"
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon List",
      },
      {
        "<leader>fha",
        function()
          local conf = require("telescope.config").values
          local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
            end

            local make_finder = function()
              local paths = {}

              for _, item in ipairs(harpoon_files.items) do
                table.insert(paths, item.value)
              end

              return require("telescope.finders").new_table {
                results = paths,
              }
            end

            require("telescope.pickers")
              .new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table {
                  results = file_paths,
                },
                previewer = conf.file_previewer {},
                sorter = conf.generic_sorter {},
                attach_mappings = function(prompt_buffer_number, local_map)
                  -- The keymap you need
                  local_map("i", "<c-d>", function()
                    local state = require "telescope.actions.state"
                    local selected_entry = state.get_selected_entry()
                    local current_picker = state.get_current_picker(prompt_buffer_number)

                    -- This is the line you need to remove the entry
                    require("harpoon"):list():remove(selected_entry)
                    current_picker:refresh(make_finder())
                  end)

                  return true
                end,
              })
              :find()
          end
          toggle_telescope(require("harpoon"):list())
        end,
        desc = "Telescope Harpoon",
      },
    },
  },
  {
    "isak102/telescope-git-file-history.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = "Telescope git_file_history",
    config = function()
      require("telescope").load_extension "git_file_history"
    end,
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope.nvim",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope").extensions.smart_open.smart_open {
            cwd_only = true,
            filename_first = true,
          }
        end,
        desc = "Telescope Files",
      },
    },
    config = function()
      require("telescope").load_extension "smart_open"
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      {
        "<leader>u",
        "<cmd>Telescope undo<cr>",
        desc = "Telescope Undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension "undo"
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap" },
    event = "LspAttach",
    config = function()
      require("telescope").load_extension "dap"
    end,
  },
  {
    "HUAHUAI23/telescope-dapzzzz",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    event = "LspAttach",
    config = function()
      -- :Telescope i23 dap23
      -- input your configuration file directory, /path/of/project/.vscode is default
      -- note: the adapter type corresponds to the configuration type, and filetype is which the configuration will attach to
      require("telescope").load_extension "i23"
    end,
  },
  {
    "allaman/emoji.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          require("telescope").extensions.emoji.emoji()
        end,
        desc = "Telescope Emoji",
      },
    },
    dependencies = {
      -- util for handling paths
      "nvim-lua/plenary.nvim",
      -- optional for nvim-cmp integration
      -- "hrsh7th/nvim-cmp",
      -- optional for telescope integration
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
    config = function(_, opts)
      require("emoji").setup(opts)
      -- optional for telescope integration
      require("telescope").load_extension "emoji"
    end,
  },
}
