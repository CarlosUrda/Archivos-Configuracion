-- Description: Módulo para gestionar la configuración de otros plugins en Neovim.
-- Hace de puerta de entrada para cargar la configuración específica de cada plugin.
-- Expone a modo de API la configuración de usuario de cada plugin
-- -- Este módulo permite cargar opciones y plugins específicos para un plugin dado.

local M = {}

-- Comprobar si una cadena es de tipo string y cumple condiciones.
-- @param cadena string Cadena a comprobar
-- @param nil_valido boolean Si se admite el valor nil de la cadena como válido. Por defecto inválido.
-- @param vacio_valido boolean Si se admite la cadena vacía como válida. Por defecto inválido.
-- @return boolean ok si la cadena es válida
-- @return string|nil Cadena con los espacios eliminados en los bordes (trim), o nil
-- @return string msg Mensaje de tipo de error
local function comprobar_cadena(cadena, nil_valido, vacio_valido)
    if type(cadena) ~= "string" then 
        return false, nil, "El nombre del plugin no es una cadena"
    end

    if cadena == nil then
        if nil_valido then
            return true, cadena
        else
            return false, cadena, "La cadena no puede ser nil"
        end
    end

    cadena = vim.trim(cadena)
    if cadena == "" then and not vacio_valido then
        return false, cadena, "La cadena no puede estar vacía"
    end

    return true, cadena
end


-- Crear una nueva instancia de configuración para un plugin específico
-- @param plugin_mod string Nombre del módulo del plugin dentro de su repositorio: lua/<plugin>.lua
-- o lua/<plugin>/init.lua
-- @param clave_ruta_config string Ruta en dot notation (formato directorios separados por '.') dentro
-- del packagepath donde se encuentran los archivos de configuración de usuario del plugin.
-- nil si no se van a acceder a archivos de configuración del usuario (para cuando se vayan a usar
-- los valores de configuracion por defecto del plugin)
-- @return table Instancia de configuración con métodos para cargar opciones y plugins.
--  -- Nil en caso de error
function M.new(plugin_mod, clave_ruta_config)
    -- La comprobación de la existencia del módulo plugin.lua o plugin/init.lua se hace en el setup justo antes de intentar
    -- cargar el módulo, y no ahora que puede todavía no existir.

    ok, plugin_mod, msg = comprobar_cadena(plugin_mod)
    if not ok then
        return nil, "Error con el nombre del plugin: " .. msg 
    end

    ok, clave_ruta_config, msg = comprobar_cadena(clave_ruta_config, true, true)
    if not ok then
        return nil, "Error en la clave de la ruta de los archivos de configuración: " .. msg
    end


    -- Función para comprobar y cargar un módulo de configuración específico del plugin
    -- @param modulo string Nombre del módulo a cargar (sin extensión .lua).
    -- nil hace que la función devuelva nil, usado fuera para tomar valores por defecto.
    -- "" se considera error.
    -- @return boolean ok Indica si la carga fue exitosa
    -- @return any res Si ok true devuelve el resultado del módulo, o nil si la clave del módulo es nil
    -- -- Si ok es false, devuelve una tabla con la información del error:
    -- -- -- { level = nivel de error de vim.log.levels, msg = string mensaje de error }
    local function _comprobar_modulo(modulo)
        ok, modulo, msg = comprobar_cadena(modulo, true)
        if not ok then
            return false, { level = vim.log.levels.ERROR, msg = "Error con el nombre del módulo: " .. msg }
        end

        if clave_ruta_config == nil or modulo == nil then
            return true, nil
        end

        local clave_modulo = clave_ruta_config .. "." .. modulo
        local ok, res = pcall(require, clave_modulo)
        if not ok then
            return false, { level = vim.log.levels.ERROR, msg = "Error al cargar el módulo de configuración " .. clave_modulo .. ": " .. tostring(res) }
        end

        return true, res
    end


    -- Obtener las opciones de un módulo de configuración de usuario del plugin.
    -- Posible combinación de las opciones cargadas del módulo con pre_opts:
    -- -- Si los datos del módulo es nil devuelve directamente como datos pre_opts
    -- -- Si los datos del módulo no es una tabla, devuelve los datos cargados.
    -- -- Si los datos del módulo es una tabla: 
    -- -- -- se combina con pre_opts si éste es una tabla (priorizando los campos de los datos) 
    -- -- -- devuelve los datos cargados si pre_opts no es una tabla
    -- En todos los casos, el resto de valores retornados mostrará el estado de error al realizar
    -- la carga del módulo
    -- @param modulo string Nombre del módulo de configuración (sin .lua)
    -- @param pre_opts any Datos previos para combinar con las opciones cargadas
    -- @return boolean ok Indica si la carga fue exitosa
    -- @return any res Opciones cargadas, o nil si no se encontró
    -- @return number|nil log_level Nivel de log (vim.log.levels) en caso de error
    -- @return string|nil msg Mensaje de error en caso de error
    local function exec_modulo(modulo, pre_opts)
        local ok, res = _comprobar_modulo(modulo)

        if res == nil then
            res = pre_opts
        elseif type(res) == "table" then
            if type(pre_opts) ~= "table" then
                pre_opts = {}
            end 
            res = vim.tbl_deep_extend("force", pre_opts, res)
        end

        return ok, res
    end


    -- Callback para llamar a la función setup del plugin.
    -- @param plugin_spec table Tabla con la especificación del plugin (usado en Lazy)
    -- @param opts table Tabla con las opciones de configuración del plugin
    -- @return nil
    local function setup(plugin_spec, opts, nombre_setup, clave_mod)
        ok, nombre_setup, msg = comprobar_cadena(nombre_setup, true)
        if not ok then 
            return false, { level = vim.log.levels.ERROR, msg = "Error con el nombre de la función setup: " .. msg }
        end
        if nombre_setup == nil then
            nombre_setup = "setup"
        end

        ok, clave_mod, msg = comprobar_cadena(clave_mod, true)
        if not ok then 
            return false, { level = vim.log.levels.ERROR, msg = "Error con la clave del módulo del plugin setup: " .. msg }
        end
        if clave_mod == nil then
            clave_mod = plugin_mod
        end

        local ok, res = pcall(require, clave_mod)
        if not ok then
            return false, { level = vim.log.levels.ERROR, msg = "Error al cargar el módulo de setup " .. clave_mod .. ": " .. tostring(res) }
        end
        if type(res) ~= "table" or not res[nombre_setup] or type(res[nombre_setup]) ~= "function" then
            return false, { level = vim.log.levels.WARN, msg = "El módulo " .. clave_mod .. " no tiene método setup" }
        end
        ok, res = pcall(res.setup, opts)
        if not ok then
            vim.notify("Error al ejecutar el método setup de " .. clave_mod .. ": " .. tostring(res), vim.log.levels.ERROR)
            return
        end
    end


    -- Obtener una función de callback genérica para asignar a los campos de la especificación de
    -- un plugin o del módulo bootstrao, y que al ejecutar se obtengan datos o ejecuten acciones
    -- asociadas a ese campo
    -- @param modulo_pre string Nombre del módulo a ejecutar (sin extensión .lua) antes de realizar
    -- el setup. Los valores que devuelva este módulo serán ignorados. nil no ejecuta nada.
    -- @param setup string Nombre de la función setup del módulo del plugin
    -- @param modulo_post string Nombre del módulo a ejecutar (sin extensión .lua) después de
    -- realizar el setup. Los valores que devuelva este módulo serán retornados por el callback. 
    -- nil no ejecuta nada y hace que el callback devuelva nil.
    -- @param min_name_log_level string Nivel mínimo de log para notificaciones, en mayúsculas o minúsculas:
    -- ("TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF")
    -- @return function Función de callback que carga las opciones cuando se llama
    local function get_callback(modulo_pre, setup, modulo_post, min_name_log_level)
        local min_log_level = vim.log.levels[tostring(min_name_log_level):upper()] or vim.log.levels.WARN

        local function callback(plugin_spec, pre_opts)
            local ok, res, log_level, msg = get_config(modulo, pre_opts)
            if not ok and min_log_level ~= vim.log.levels.OFF and type(log_level) == "number" and log_level >= min_log_level then
                vim.notify(msg, log_level)
            end
            return res
        end

        return callback
    end

    return {
        callback_setup = callback_setup,
        get_config = get_config,
        get_callback_get_config = get_callback_get_config,
    }
end

return M
