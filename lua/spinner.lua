local M = {}
local config = {
  -- Show notification when done.
  -- Set to false to disable.
  show_notification = false,
  -- Name of the plugin. Basically the title of the notification, when the spinner is hidden
  plugin = "spinner.nvim",
  -- Spinner frames.
  spinner_frames = {
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
  },
}

local default_position = {
  relative = "editor",
  width = 1,
  height = 1,
  col = vim.o.columns - 1,
  row = 0,
}
local spinner_index = 1
local spinner_timer = nil
local spinner_buf = nil
local spinner_win = nil

--- Show a spinner at the specified position. Containing position table and msg string
---@param opts? table
function M.show(opts)
  -- Default position: the top right corner
  local options = opts ~= nil and opts.position ~= nil and opts.position or default_position
  options.style = "minimal"

  -- Create buffer and window for the spinner
  spinner_buf = vim.api.nvim_create_buf(false, true)
  spinner_win = vim.api.nvim_open_win(spinner_buf, false, options)

  -- Set up timer and update spinner
  spinner_timer = vim.loop.new_timer()
  spinner_timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(spinner_buf) then
        vim.api.nvim_buf_set_lines(
          spinner_buf,
          0,
          -1,
          false,
          { opts ~= nil and opts.msg and opts.msg or "" .. " " .. config.spinner_frames[spinner_index] }
        )
      end
      spinner_index = spinner_index % #config.spinner_frames + 1
    end)
  )
end

--- Hide the spinner.
---@param msg? string
function M.hide(msg)
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
    if spinner_win then
      vim.api.nvim_win_close(spinner_win, true)
    end
    if spinner_buf then
      vim.api.nvim_buf_delete(spinner_buf, { force = true })
    end

    if msg ~= nil then
      vim.notify(msg ~= nil and msg or "", vim.log.levels.INFO, { title = config.plugin })
    end
  end
end

-- }}}

return M
