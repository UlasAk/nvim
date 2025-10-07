vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.tabline()"
local devicons = require "nvim-web-devicons"

local function colored_icon(filename, ext, is_active)
  local icon, color = devicons.get_icon_color(filename, ext, { default = true })
  if not icon then
    icon, color = "", "#6d8086"
  end

  local fg_color = is_active and color or "#6d8086"

  local hl_name = (is_active and "TabLineIcon_" or "TabLineIconInactive_") .. ext
  if vim.fn.hlID(hl_name) == 0 then
    vim.api.nvim_set_hl(0, hl_name, { fg = fg_color, bg = "NONE" })
  end

  local restore_bg = is_active and "%#TabLineSel#" or "%#TabLine#"

  return "%#" .. hl_name .. "#" .. icon .. restore_bg
end

function _G.tabline()
  local s = ""
  local numtabs = vim.fn.tabpagenr "$"

  for tabnr = 1, numtabs do
    local is_active = (tabnr == vim.fn.tabpagenr())
    local names = {}
    local buflist = vim.fn.tabpagebuflist(tabnr)
    local numwins = vim.fn.tabpagewinnr(tabnr, "$")

    for winnr = 1, numwins do
      local bufnr = buflist[winnr]
      local bufname = vim.fn.bufname(bufnr)
      local buftype = vim.bo[bufnr].buftype
      local filetype = vim.bo[bufnr].filetype

      local display_name

      if filetype == "help" then
        local shortname = vim.fn.fnamemodify(bufname, ":t")
        local icon_fg = is_active and "#f9e2af" or "#6d8086"
        local hl_name = is_active and "TabLineHelpIcon" or "TabLineHelpIconInactive"
        if vim.fn.hlID(hl_name) == 0 then
          vim.api.nvim_set_hl(0, hl_name, { fg = icon_fg, bg = "NONE" })
        end
        local icon = "%#" .. hl_name .. "#" .. "" .. (is_active and "%#TabLineSel#" or "%#TabLine#")
        display_name = icon .. " Help:" .. (shortname ~= "" and shortname or filetype)
      elseif buftype == "terminal" then
        local icon_fg = is_active and "#a6e3a1" or "#6d8086"
        local hl_name = is_active and "TabLineTermIcon" or "TabLineTermIconInactive"
        if vim.fn.hlID(hl_name) == 0 then
          vim.api.nvim_set_hl(0, hl_name, { fg = icon_fg, bg = "NONE" })
        end
        local icon = "%#" .. hl_name .. "#" .. "" .. (is_active and "%#TabLineSel#" or "%#TabLine#")
        display_name = icon .. " :terminal"
      elseif bufname ~= "" then
        local filename = vim.fn.fnamemodify(bufname, ":t")
        local ext = filename:match "^.+%.(.+)$" or ""
        display_name = colored_icon(filename, ext, is_active) .. " " .. filename
      elseif bufname == "" and buftype == "" and filetype == "" then
        local icon_fg = is_active and "#89b4fa" or "#6d8086"
        local hl_name = is_active and "TabLineNewIcon" or "TabLineNewIconInactive"
        if vim.fn.hlID(hl_name) == 0 then
          vim.api.nvim_set_hl(0, hl_name, { fg = icon_fg, bg = "NONE" })
        end
        local icon = "%#" .. hl_name .. "#" .. "" .. (is_active and "%#TabLineSel#" or "%#TabLine#")
        display_name = icon .. " (new)"
      end

      if display_name then
        table.insert(names, display_name)
      end
    end

    -- Start mit richtiger Tabfarbe
    s = s .. (is_active and "%#TabLineSel#" or "%#TabLine#")

    if #names > 0 then
      s = s .. " " .. tabnr .. ": " .. table.concat(names, " | ") .. " "
    else
      s = s .. " " .. tabnr .. ": (empty) "
    end
  end

  s = s .. "%#TabLineFill#"
  return s
end
