local opts = {
    options = {
      theme = "tokyonight",   -- pega con tu esquema actual
      icons_enabled = true,
    },
    sections = {
      lualine_a = { "mode" },
      -- AQUÍ aparece la rama y los cambios de git
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename", "filesize" },
      lualine_x = { "encoding", "fileformat", "filetype", "lsp_status" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
}

return opts
