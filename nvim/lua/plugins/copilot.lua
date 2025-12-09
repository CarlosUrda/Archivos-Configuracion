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

    local opts = { noremap = true, silent = true, expr = true, replace_keycodes = false}

    -- Aceptar sugerencia
    opts.desc = "Copilot: aceptar sugerencia completa"
    vim.keymap.set("i", "<C-j>", 'copilot#Accept()', opts)

    -- Aceptar palabra de sugerencia
    opts.desc = "Copilot: aceptar palabra de sugerencia"
    vim.keymap.set("i", "<M-j>", 'copilot#AcceptWord()', opts)

    -- Aceptar línea de sugerencia
    opts.desc = "Copilot: aceptar línea de sugerencia"
    vim.keymap.set("i", "<M-l>", 'copilot#AcceptLine()', opts)

    -- Siguiente sugerencia
    opts.desc = "Copilot: siguiente sugerencia"
    vim.keymap.set("i", "<C-l>", 'copilot#Next()', opts)

    -- Sugerencia anterior
    opts.desc = "Copilot: sugerencia anterior"
    vim.keymap.set("i", "<C-h>", 'copilot#Previous()', opts)

    -- Forzar sugerencia
    opts.desc = "Copilot: forzar sugerencia"
    vim.keymap.set("i", "<C-f>", 'copilot#Suggest()', opts)

    -- Desechar sugerencia
    opts.desc = "Copilot: desechar sugerencia"
    vim.keymap.set("i", "<C-k>", 'copilot#Dismiss()', opts)

  end,
}
