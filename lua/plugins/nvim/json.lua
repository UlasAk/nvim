return {
  {
    "Joakker/lua-json5",
    build = "./install.sh",
    cond = function()
      return vim.fn.executable "cargo" == 1
    end,
    lazy = true,
  },
}
