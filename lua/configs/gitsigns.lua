local options = {
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },

  on_attach = function(bufnr)
    if require("lazy.core.config").plugins["zen-mode.nvim"]._.loaded ~= nil and require("zen-mode.view").is_open() then
      return false
    end

    local gs = package.loaded.gitsigns

    local function opts(desc)
      return { buffer = bufnr, desc = desc }
    end

    local map = vim.keymap.set

    map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
    map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
    map("n", "<leader>gb", gs.blame_line, opts "Blame Line")
  end,
}

return options
