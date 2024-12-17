return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.stdpath "state" .. "/sessions/", -- directory where session files are saved
      -- minimum number of file buffers that need to be open to save
      -- Set to 0 to always save
      need = 1,
      branch = true, -- use git branch to save session
    },
    config = function()
      local map = vim.keymap.set
      map("n", "<leader>ps", function()
        require("persistence").select()
      end, { desc = "Persistence Select session" })
      map("n", "<leader>pc", function()
        require("persistence").load()
      end, { desc = "Persistence Load session for current directory" })
      map("n", "<leader>pl", function()
        require("persistence").load { last = true }
      end, { desc = "Persistence Load last session" })
      map("n", "<leader>pq", function()
        require("persistence").stop()
      end, { desc = "Persistence Stop persistence" })
    end,
  },
}
