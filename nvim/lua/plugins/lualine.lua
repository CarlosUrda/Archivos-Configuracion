-- ~/.config/nvim/lua/plugins/lualine.lua
cfg = require("config").new("lualine", "config.lualine")

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = cfg.get_callback_get_config("deps")(),
    opts = cfg.get_callback_get_config("opts"),
    config = cfg.callback_setup,
  },
}
