-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  {
    -- 1) De dónde se baja el plugin
    "nvim-treesitter/nvim-treesitter",

    -- 2) Qué hacer tras instalar/actualizar
    -- Ejecuta :TSUpdate para bajar/actualizar gramáticas
    build = ":TSUpdate",

    -- 3) Cuándo cargar el plugin
    -- Al abrir un archivo o crear uno nuevo
    event = { "BufReadPost", "BufNewFile" },

    -- 4) Configuración del plugin
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Lenguajes que quieres tener instalados sí o sí
        ensure_installed = {
          "c",
          "cpp",
          "python",
          "lua",
          "vim",
          "vimdoc",
          "query",
	  "javascript",
	  "typescript",
	  "html",
	  "css",
	  "json",
	  "bash",
	  "yaml",
	  "markdown",
	  "markdown_inline",
        },

        -- Instalación de gramáticas
        sync_install = false,  -- que no bloquee Neovim
        auto_install = true,   -- si abres un lenguaje nuevo, te ofrece instalarlo

        -- Resaltado de sintaxis con Tree-sitter
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- Indentación basada en árbol sintáctico
        indent = {
          enable = true,
        },

        -- (Opcional) selección incremental
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",        -- empezar selección
            node_incremental = "gnr",      -- ampliar al nodo padre
            scope_incremental = "gnc",     -- ampliar al scope
            node_decremental = "gnm",      -- reducir
          },
        },
      })
    end,
  },
}
