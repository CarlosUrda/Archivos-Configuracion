-- ~/.config/nvim/init.lua

-- Líder (espacio)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Opciones básicas
require("config.opts")

-- Gestor de plugins (lazy)
require("bootstrap")

