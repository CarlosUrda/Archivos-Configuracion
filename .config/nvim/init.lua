-- ~/.config/nvim/init.lua

-- Líder (espacio)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Opciones básicas
require("config.options")

-- Gestor de plugins (lazy)
require("config.lazy")

