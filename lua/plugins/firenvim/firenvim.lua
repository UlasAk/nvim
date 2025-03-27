local opened_by_firenvim = vim.g.started_by_firenvim == true

if opened_by_firenvim then
  -- options
  vim.opt.stl = nil
  vim.opt.showmode = false
  vim.o.laststatus = 0
  vim.cmd "startinsert"

  -- autocmds
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    nested = true,
    command = "silent write",
  })
  -- for large buffers
  -- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  --   callback = function(_)
  --     if vim.g.timer_started == true then
  --       return
  --     end
  --     vim.g.timer_started = true
  --     vim.fn.timer_start(10000, function()
  --       vim.g.timer_started = false
  --       vim.cmd "silent write"
  --     end)
  --   end,
  -- })

  -- mappings
end

return {
  {
    "glacambre/firenvim",
    cond = opened_by_firenvim,
    build = ":call firenvim#install(0)",
    config = function()
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = "github.com_*.txt",
        command = "set filetype=markdown",
      })
    end,
  },
}
