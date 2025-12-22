local DEFECTO = {
    fn_sesion = "session.vim",
    ruta_state = vim.fn.stdpath("state"),
    auto = true,
}
DEFECTO.ruta_sesion = DEFECTO.ruta_state .. "/" .. DEFECTO.fn_sesion

local cfg = {}
local M = {}

function configurar_opciones(opts)
    opts = opts or {}

    ruta_sesion, err = preparar_ruta_sesion(cfg.ruta_sesion)
    cfg.ruta_sesion = opts.ruta_sesion or DEFECTO.ruta_sesion
    
    if type(opts.autoguardar) == "boolean" then
        cfg.autoguardar = opts.autoguardar
    else
        opts.autoguardar = DEFECTO.autoguardar
        if opts.autoguardar ~= nil then
            local mensaje = "La opción 'autoguardar' debe ser un valor booleano (true o false)."
            vim.notify(mensaje, vim.log.levels.WARN)
        end
    end
end

function registrar_comandos()
    
end

function M.setup(opts)
    configurar_opciones(opts)
    registrar_comandos()
    return M
end

function normalizar_nombre_archivo(nombre)
    nombre = vim.trim(nombre)
    if nombre == "" then
        return nil, "El nombre del archivo no puede estar vacío."
    end
    if nombre:sub(-1) == "/" then
        return nil, "El nombre del archivo no puede terminar con '/'."
    end
    -- Reemplazar caracteres no permitidos en nombres de archivos
    local nombre_normalizado = nombre:gsub("[<>:\"/\\|%?%*]", "_")
    return nombre_normalizado, nil
end

function preparar_ruta_sesion(ruta_sesion)
    if ruta_sesion == nil then
        ruta_sesion = ruta_defecto_sesion
    elseif type(ruta_sesion) ~= "string" then
        local mensaje = "La ruta de la sesión debe ser una cadena de texto."
        vim.notify(mensaje, vim.log.levels.ERROR)
        return false, mensaje
    end

    ruta_sesion = vim.trim(ruta_sesion)
    local es_dir = false

    if ruta_sesion == "" then
        ruta_sesion = "./"
    end

    if ruta_sesion:sub(-1) == "/" then
        es_dir = true
    end

    ruta_sesion = vim.fn.fnamemodify(ruta_sesion, ":p")  -- Si el directorio existe, agrega o mantiene '/' al final de rutas absolutas. Si no existe, la puede quitar. 
    if es_dir and ruta_sesion:sub(-1) ~= "/" then
        ruta_sesion = ruta_sesion .. "/"
    end

    -- Asegurarse de que el directorio exista
    local dir_sesion = vim.fn.fnamemodify(ruta_sesion, ":h")
    if vim.fn.isdirectory(dir_sesion) == 0 then
        vim.fn.mkdir(dir_sesion, "p")
    end

    if ruta_sesion:sub(-1) == "/" then
        ruta_sesion = ruta_sesion .. fn_sesion
    end
}


function guardar_sesion(ruta_sesion)

    local ok, res = pcall(vim.cmd, "mks! " .. vim.fn.fnameescape(ruta_sesion))
    ruta_bonita = vim.fn.fnamemodify(ruta_sesion, ":p:.:~") -- Normalizar la ruta para notificaciones. :~ y :. válido para notificaciones. Para trabajar internamente se usan rutas absolutas.
    if ok then
        vim.notify("Sesión guardada en: " .. ruta_bonita, vim.log.levels.INFO)
        return true, ruta_bonita
    else
        local mensaje = "Error al guardar la sesión en " .. ruta_bonita .. ": " .. tostring(res)
        vim.notify(mensaje, vim.log.levels.ERROR)
        return false, mensaje
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


