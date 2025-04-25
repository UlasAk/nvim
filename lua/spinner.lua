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

local spinner_index = 1
local spinner_timer = nil
local spinner_buf = nil
local spinner_win = nil

--- Show a spinner at the specified position.
function M.show(msg, title)
  msg = msg ~= nil and msg or ""
  -- Default position: the top right corner
  local win_options = {
    relative = "editor",
    width = #msg + 7,
    height = 1,
    col = vim.o.columns - 1,
    row = vim.o.lines - 5,
    style = "minimal",
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    title = title,
  }

  -- Create buffer and window for the spinner
  spinner_buf = vim.api.nvim_create_buf(false, true)
  spinner_win = vim.api.nvim_open_win(spinner_buf, false, win_options)

  -- Set up timer and update spinner
  spinner_timer = vim.loop.new_timer()
  spinner_timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(spinner_buf) then
        vim.api.nvim_buf_set_lines(spinner_buf, 0, -1, false, {
          (#msg > 0 and " " .. msg .. "    " or "") .. config.spinner_frames[spinner_index] .. (#msg > 0 and " " or ""),
        })
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
