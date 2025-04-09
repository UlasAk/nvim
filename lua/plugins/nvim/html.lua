local function get_filetypes()
  return {
    "html",
    "htmlangular",
    "htmldjango",
    "tsx",
    "jsx",
    "erb",
    "svelte",
    "vue",
    "blade",
    "php",
    "templ",
    "astro",
  }
end

return {
  {
    "Jezda1337/nvim-html-css",
    dependencies = { "hrsh7th/nvim-cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using nvim-cmp
    -- dependencies = { "saghen/blink.cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using blink.cmp
    ft = get_filetypes(),
    opts = {
      enable_on = get_filetypes(),
      handlers = {
        definition = {
          bind = "gd",
        },
        hover = {
          bind = "K",
          wrap = true,
          border = "none",
          position = "cursor",
        },
      },
      documentation = {
        auto_show = true,
      },
      style_sheets = {
        "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
        "https://cdnjs.cloudflare.com/ajax/libs/bulma/1.0.3/css/bulma.min.css",
        "./index.css", -- `./` refers to the current working directory.
        "./src/styles/main.css",
        "./src/styles/components.css",
        "https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css",
      },
    },
  },
}
