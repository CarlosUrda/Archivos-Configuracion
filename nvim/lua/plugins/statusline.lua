-- ~/.config/nvim/lua/plugins/statusline.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- iconos opcionales
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",   -- pega con tu esquema actual
          icons_enabled = true,
        },
        sections = {
          lualine_a = { "mode" },
          -- AQUÍ aparece la rama y los cambios de git
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
