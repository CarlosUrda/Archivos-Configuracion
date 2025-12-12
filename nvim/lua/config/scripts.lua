local fn_sesion = "session.vim"
local ruta_state = vim.fn.stdpath("state")
local ruta_sesion = ruta_state .. "/" .. fn_sesion

function GuardarSesion()
    ok, res = pcall(vim.cmd, "mks! " .. ruta_sesion)
    if ok then
        vim.notify("Sesión guardada en: " .. ruta_sesion, vim.log.levels.INFO)
    else
        vim.notify("Error al guardar la sesión: " .. res, vim.log.levels.ERROR)
    end
end

function CargarSesion()
    if vim.fn.filereadable(ruta_sesion) == 0 then
        mensaje = "No se encontró ninguna sesión guardada en: " .. ruta_sesion
        vim.notify(mensaje, vim.log.levels.WARN)
        return false, mensaje
    end
    
    ok, res = pcall(vim.cmd, "source " .. ruta_sesion)
    if ok then
        vim.notify("Sesión cargada desde: " .. ruta_sesion, vim.log.levels.INFO)
        return true, ruta_sesion
    else
        vim.notify("Error al cargar la sesión desde " .. ruta_sesion .. ": " .. res, vim.log.levels.ERROR)
        return false, res
    end
end


