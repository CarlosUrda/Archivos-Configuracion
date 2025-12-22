local stdpath = vim.fn.stdpath("state")

local opts = {
    ruta_sesion = stdpath .. "/" .. "session.vim", -- Ruta donde guardar la sesión. nil o vacío = por defecto.
    autoguardar = true,                            -- Guardar automáticamente la sesión al salir de Neovim.
}

return opts
