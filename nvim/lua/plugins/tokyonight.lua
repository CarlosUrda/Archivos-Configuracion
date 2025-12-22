-- ~/.config/nvim/lua/plugins/tokyonight.lua

-- local cfg = require("config").new("tokyonight", "config.tokyonight")

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
