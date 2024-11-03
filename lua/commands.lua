vim.api.nvim_create_user_command("ToggleTransparency", function()
  require("colors").toggle_transparency()
end, {})
