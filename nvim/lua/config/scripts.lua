local fn_sesion = "session.vim"
local ruta_state = vim.fn.stdpath("state")
local ruta_defecto_sesion = ruta_state .. "/" .. fn_sesion

function GuardarSesion(ruta_sesion)
    if ruta_sesion == "" or ruta_sesion == nil then
        ruta_sesion = ruta_defecto_sesion
    elseif type(ruta_sesion) != "string" then
        mensaje = "La ruta de la sesión debe ser una cadena de texto."
        vim.notify(mensaje, vim.log.levels.ERROR)
        return false, mensaje
    else
        -- Asegurarse de que el directorio exista
        local dir = vim.fn.fnamemodify(ruta_sesion, ":h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
        elseif ruta_sesion:sub(-1) == "/" then
            -- Si la ruta termina con '/', agregar el nombre de archivo por defecto
            ruta_sesion = ruta_sesion .. fn_sesion
        end
    ruta_sesion = ruta_sesion or ruta_defecto_sesion

    ok, res = pcall(vim.cmd, "mks! " .. ruta_sesion)
    if ok then
        vim.notify("Sesión guardada en: " .. ruta_sesion, vim.log.levels.INFO)
        return true, ruta_sesion
    else
        vim.notify("Error al guardar la sesión: " .. res, vim.log.levels.ERROR)
        return false, res
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


