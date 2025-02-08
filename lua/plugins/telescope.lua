return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)
      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end

      -- Change Noice Mini Background Color (where LSP Progress is shown)
      vim.cmd "hi TelescopeMatching guifg=#89b4fa guibg=#76758a"
      vim.cmd "hi TelescopeSelection guifg=#d9e0ee guibg=#5c5a82"

      local map = vim.keymap.set
      -- Diagnostics
      map("n", "<leader>lda", function()
        require("telescope.builtin").diagnostics()
      end, { desc = "Diagnostics All Diagnostics" })
      map("n", "<leader>ldc", function()
        require("telescope.builtin").diagnostics { bufnr = 0 }
      end, { desc = "Diagnostics Diagnostics Current Buf" })
      -- Other
      map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Buffers" })
      map("n", "<leader>fhe", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Help page" })
      map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Oldfiles" })
      map("n", "<leader><leader>", function()
        require("telescope.builtin").oldfiles {
          only_cwd = true,
        }
      end, { desc = "Telescope Oldfiles in cwd" })
      map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Current Buffer" })
      -- map("n", "<leader><leader>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Current Buffer" })
      map("n", "<leader>fgc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
      map("n", "<leader>fgt", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
      map("n", "<leader>fgh", "<cmd>Telescope git_file_history<CR>", { desc = "Telescope Git file history" })
      map("n", "<leader>fte", "<cmd>Telescope terms<CR>", { desc = "Telescope Terminals" })
      -- map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Files" })
      map(
        "n",
        "<leader>fa",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        { desc = "telescope Files (all)" }
      )
      map("n", "<leader>fth", function()
        require("nvchad.themes").open { style = "flat", border = false }
      end, { desc = "Telescope Themes (NVChad)" })
      map("n", '<leader>f"', function()
        require("telescope.builtin").registers()
      end, { desc = "Telescope Registers" })
      map("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", { desc = "Telescope Jumplist" })
      map("n", "<leader>fco", "<cmd>Telescope commands<CR>", { desc = "Telescope Commands" })
      map("n", "<leader>fch", "<cmd>Telescope command_history<CR>", { desc = "Telescope Command history" })
      map("n", "<leader>fv", "<cmd>Telescope vim_options<CR>", { desc = "Telescope Vim Options" })
      map("n", "<leader>fsy", "<cmd>Telescope treesitter<CR>", { desc = "Telescope Symbols" })
      map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Telescope Resume last search" })
      map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Telescope Mappings" })
      map("n", "<leader>fma", "<cmd>Telescope marks<CR>", { desc = "Telescope Marks" })
      map({ "n", "v" }, "<leader>fgs", "<cmd>Telescope grep_string<CR>", { desc = "Telescope Grep String" })
      map("n", "<leader>fme", "<cmd>Telescope media_files<CR>", { desc = "Telescope Media" })
      map("v", "<leader>fz", function()
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
      end, { desc = "Telescope Current Buffer" })
      map("n", "<leader>fhi", "<cmd>Telescope highlights<CR>", { desc = "Telescope Highlights" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    opts = require "configs.actions-preview",
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = { "nvim-lua/popup.nvim" },
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
    config = function()
      require("todo-comments").setup()

      local map = vim.keymap.set
      map("n", "<leader>fto", "<cmd>TodoTelescope<CR>", { desc = "Telescope TODOs" })
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup()

      local map = vim.keymap.set
      map("n", "<leader>ha", function()
        require("harpoon"):list():add()
      end, { desc = "Harpoon Add" })
      -- map("n", "<C-h>", function()
      --   require("harpoon"):list():select(1)
      -- end)
      -- map("n", "<C-t>", function()
      --   require("harpoon"):list():select(2)
      -- end)
      -- map("n", "<C-n>", function()
      --   require("harpoon"):list():select(3)
      -- end)
      -- map("n", "<C-s>", function()
      --   require("harpoon"):list():select(4)
      -- end)
      map("n", "<leader>hp", function()
        require("harpoon"):list():prev()
      end, { desc = "Harpoon Previous" })
      map("n", "<leader>hn", function()
        require("harpoon"):list():next()
      end, { desc = "Harpoon Next" })
      map("n", "<leader>hl", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon List" })
      map("n", "<leader>fha", function()
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
      end, { desc = "Telescope Harpoon" })
    end,
  },
  {
    "isak102/telescope-git-file-history.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    config = function()
      require("telescope").load_extension "smart_open"
      vim.keymap.set("n", "<leader>ff", function()
        require("telescope").extensions.smart_open.smart_open {
          cwd_only = true,
          filename_first = true,
        }
      end)
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
      { -- lazy style key map
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
}
