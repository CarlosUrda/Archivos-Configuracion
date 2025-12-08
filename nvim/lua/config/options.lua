-- ~/.config/nvim/lua/config/options.lua

local o = vim.opt

o.guifont = "FiraCode Nerd Font Mono:h10"  -- Fuente para GUI (Neovim-Qt, etc.)

-- ===== INTERFAZ BÁSICA =====
o.number         = true   -- número de línea
o.relativenumber = true   -- número relativo (para moverse con jj, kk, etc.)
o.cursorline     = true   -- resalta la línea actual

o.termguicolors  = true   -- colores 24 bits
o.signcolumn     = "yes"  -- columna de signos siempre visible (LSP, git, etc.)
o.wrap           = false  -- no partir líneas largas
o.scrolloff      = 4      -- margen vertical al hacer scroll
o.sidescrolloff  = 8      -- margen horizontal

-- ===== TABS / INDENTACIÓN =====
o.tabstop     = 4   -- tamaño visual de un tab real
o.shiftwidth  = 4   -- indentación automática (>>, <<, autoindent)
o.softtabstop = 4   -- cuánto avanza el TAB al escribir
o.expandtab   = true -- convierte TAB en espacios

o.smartindent = true -- intenta indentación inteligente
o.autoindent  = true -- copia la indentación de la línea anterior

-- ===== BÚSQUEDA =====
o.ignorecase = true  -- ignorar mayúsculas en búsquedas...
o.smartcase  = true  -- ...salvo que uses alguna mayúscula
o.incsearch  = true  -- ir mostrando resultados mientras escribes
o.hlsearch   = true  -- resaltar coincidencias

-- ===== ARCHIVOS / CODIFICACIÓN =====
o.encoding     = "utf-8"
o.fileencoding = "utf-8"

-- ===== VENTANAS / SPLITS =====
o.splitright = true  -- los splits verticales se abren a la derecha
o.splitbelow = true  -- los splits horizontales se abren abajo

-- ===== PORTAPAPELES (OPCIONAL) =====
-- Usa el portapapeles del sistema (Ctrl+C / Ctrl+V del SO)
-- Si no te gusta, comenta esta línea.
-- o.clipboard = "unnamedplus"

-- ===== MOUSE (OPCIONAL) =====
-- Si quieres usar ratón en la terminal, descomenta:
-- o.mouse = "a"

-- Desactivar backups “molestos” (ya tenemos swap/undo aparte si quieres)
o.swapfile = false
o.backup = false
o.writebackup = true

-- Scroll cómodo
o.scrolloff = 2
o.sidescrolloff = 4
