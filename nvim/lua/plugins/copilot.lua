-- ~/.config/nvim/lua/plugins/copilot.lua
return {
  "github/copilot.vim",
  event = "InsertEnter",  -- carga Copilot al entrar en modo inserción

  config = function()
    -- Que Copilot no use <Tab> por defecto
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""

    -- >>> CLAVE: reiniciar Copilot automáticamente al cargar el plugin <<<
    -- config() se ejecuta SOLO una vez, cuando lazy.nvim carga el plugin.
    vim.schedule(function()
      pcall(vim.cmd, "Copilot restart")
    end)

    -- Aceptar sugerencia
    vim.keymap.set("i", "<C-j>", 'copilot#Accept()', {
      expr = true,
      replace_keycodes = false,
      desc = "Copilot: aceptar sugerencia",
    })

    -- Siguiente sugerencia
    vim.keymap.set("i", "<C-l>", 'copilot#Next()', {
      expr = true,
      silent = true,
      desc = "Copilot: siguiente sugerencia",
    })

    -- Sugerencia anterior
    vim.keymap.set("i", "<C-h>", 'copilot#Previous()', {
      expr = true,
      silent = true,
      desc = "Copilot: sugerencia anterior",
    })

    -- Forzar sugerencia
    vim.keymap.set("i", "<C-f>", 'copilot#Suggest()', {
      expr = true,
      silent = true,
      desc = "Copilot: forzar sugerencia",
    })

    -- Desechar sugerencia
    vim.keymap.set("i", "<C-k>", 'copilot#Dismiss()', {
      expr = true,
      silent = true,
      desc = "Copilot: desechar sugerencia",
    })

  end,
}
