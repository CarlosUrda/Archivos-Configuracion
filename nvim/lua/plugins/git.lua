-- ~/.config/nvim/lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- se carga al abrir archivos
    config = function()
      local gitsigns = require("gitsigns")

      gitsigns.setup({
        -- con la config por defecto vale; usa la signcolumn que ya tienes
      })

      -- Atajos de teclado básicos
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true, desc = "" }

      -- Ir al siguiente / anterior "hunk" (cambio)
      map("n", "]h", gitsigns.next_hunk,  vim.tbl_extend("force", opts, { desc = "Git: siguiente cambio" }))
      map("n", "[h", gitsigns.prev_hunk,  vim.tbl_extend("force", opts, { desc = "Git: cambio anterior" }))

      -- Ver el cambio de la línea actual
      map("n", "<leader>hp", gitsigns.preview_hunk, opts) -- "hunk preview"

      -- Hacer stage / reset del hunk actual
      map("n", "<leader>hs", gitsigns.stage_hunk,   opts) -- "hunk stage"
      map("n", "<leader>hr", gitsigns.reset_hunk,   opts) -- "hunk reset"

      -- Blame de la línea
      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, vim.tbl_extend("force", opts, { desc = "Git: blame línea" }))
    end,
  },
}
