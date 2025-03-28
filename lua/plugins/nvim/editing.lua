return {
  {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { enabled = false, char = "│", highlight = "IblScopeChar" },
    },
    keys = {
      {
        "<leader>gc",
        function()
          local config = { scope = {} }
          config.scope.exclude = { language = {}, node_type = {} }
          config.scope.include = { node_type = {} }
          local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

          if node then
            local start_row, _, end_row, _ = node:range()
            if start_row ~= end_row then
              vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
              vim.api.nvim_feedkeys("_", "n", true)
            end
          end
        end,
        desc = "Goto Inner Context",
      },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "IblScopeChar", {
        fg = "#fdfd96",
      })
      vim.api.nvim_set_hl(0, "IblScope", {
        fg = "#fdfd96",
      })
      vim.api.nvim_set_hl(0, "IblChar", {
        fg = "#383747",
      })
      -- dofile(vim.g.base46_cache .. "blankline")
      require("ibl").setup(opts)
      local hooks = require "ibl.hooks"

      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

      -- dofile(vim.g.base46_cache .. "blankline")
      require("ibl").refresh()
    end,
  },
  {
    "numtostr/Comment.nvim",
    keys = {
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        desc = "Toggle Comment",
      },
      {
        "<leader>/",
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        desc = "Toggle Comment",
        mode = "v",
      },
    },
    opts = {
      mappings = {
        basic = false,
        extra = false,
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "angular",
      "angular.html",
      "html",
      "htmlangular",
      "javascript",
      "jsx",
      "markdown",
      "php",
      "tsx",
      "typescript",
      "vue",
      "xml",
    },
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = true, -- Auto close on trailing </
    },
    config = function(_, opts)
      require("nvim-ts-autotag").setup {
        opts = opts,
      }
    end,
  },
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = {
      { "<leader>u", "<cmd> UndotreeToggle<CR>", desc = "Undotree Toggle" },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { " %s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          }
        end,
      },
    },
    event = "BufReadPost",
    keys = {

      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Folds Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Folds Close all folds",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Folds Open all folds",
      },
      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          -- if not winid then
          --   -- vim.lsp.buf.hover()
          --   vim.cmd [[ Lspsaga hover_doc ]]
          -- end
        end,
        desc = "Folds Peek into fold",
      },
    },
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      open_fold_hl_timeout = 400,
      close_fold_kinds_for_ft = { default = { "imports", "comment" } },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          -- winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
    },
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function(_, opts)
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local totalLines = vim.api.nvim_buf_line_count(0)
        local foldedLines = endLnum - lnum
        local suffix = (" 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
        -- Use this line instead to show the folded line count on position 160
        -- local rAlignAppndx = 160
        -- Use this line instead, if the folded line count should be shown on the edge of the window
        -- local rAlignAppndx = math.max(math.min(vim.api.nvim_win_get_width(0), width - 1) - curWidth - sufWidth, 0)
        suffix = (" "):rep(rAlignAppndx) .. suffix
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      opts["fold_virt_text_handler"] = handler
      require("ufo").setup(opts)
    end,
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    keys = {
      { "<leader>tN", "<cmd>TSJToggle<CR>", desc = "TreeSJ Toggle node unser cursor" },
    },
    event = "BufReadPost",
    opts = {
      ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
      use_default_keymaps = false,
      ---@type boolean Node with syntax error will not be formatted
      check_syntax_error = true,
      ---If line after join will be longer than max value,
      ---@type number If line after join will be longer than max value, node will not be formatted
      max_join_length = 100000,
      ---Cursor behavior:
      ---hold - cursor follows the node/place on which it was called
      ---start - cursor jumps to the first symbol of the node being formatted
      ---end - cursor jumps to the last symbol of the node being formatted
      ---@type 'hold'|'start'|'end'
      cursor_behavior = "hold",
      ---@type boolean Notify about possible problems or not
      notify = true,
      ---@type boolean Use `dot` for repeat action
      dot_repeat = true,
      ---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
      on_error = nil,
      ---@type table Presets for languages
      -- langs = {}, -- See the default presets in lua/treesj/langs
    },
  },
  {
    "sunnytamang/select-undo.nvim",
    keys = {
      { "gu" },
      { "gcu" },
    },
    cmd = { "SelectUndoLine", "SelectUndoPartial" },
    opts = {
      persistent_undo = true, -- Enables persistent undo history
      mapping = true, -- Enables default keybindings
      line_mapping = "gu", -- Undo for entire lines
      partial_mapping = "gcu", -- Undo for selected characters -- Note: dont use this line as gu can also handle partial undo
    },
  },
  {
    "monaqa/dial.nvim",
    keys = {},
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    event = { "BufEnter", "BufNew" },
    keys = {
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Yanky Put After" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Yanky Put Before" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Yanky G Put After" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Yanky G Put Before" },
      { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Yanky Previous Entry" },
      { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Yanky Next Entry" },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
}
