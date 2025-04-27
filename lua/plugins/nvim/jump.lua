return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
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
    "voxelprismatic/rabbit.nvim",
    event = { "BufEnter", "BufNew" },
    keys = {
      { "<leader>r", "<cmd>Rabbit<CR>", desc = "Jump Rabbit" },
    },
    opts = {},
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
