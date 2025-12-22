-- Description: Módulo para gestionar la configuración de otros plugins en Neovim.
-- Hace de puerta de entrada para cargar la configuración específica de cada plugin.
-- Expone a modo de API la configuración de usuario de cada plugin
-- -- Este módulo permite cargar opciones y plugins específicos para un plugin dado.

local M = {}


-- Crear una nueva instancia de configuración para un plugin específico
-- @param plugin_mod string Nombre del módulo del plugin dentro de su repositorio: lua/<plugin>.lua o lua/<plugin>/init.lua
-- @param clave_ruta_config string Ruta en dot notation (formato directorios separados por '.') dentro
-- del packagepath donde se encuentran los archivos de configuración de usuario del plugin.
-- Si nil no se podrá acceder a archivos de configuración (para cuando se vayan a usar los valores
-- de configuracion por defecto)
-- @return table Instancia de configuración con métodos para cargar opciones y plugins.
--  -- Nil en caso de error
function M.new(plugin_mod, clave_ruta_config)
    -- La comprobación de la existencia del módulo plugin.lua o plugin/init.lua se hace en el setup justo antes de intentar
    -- cargar el módulo, y no ahora que puede todavía no existir.
    if type(plugin_mod) ~= "string" or plugin_mod == "" then
        return nil, "El nombre del plugin no es una cadena no vacía"
    end

    if clave_ruta_config ~= nil and type(clave_ruta_config) ~= "string" then
        return nil, "La clave de la ruta de los archivos de configuración no es una cadena"
    end

    -- Función para comprobar y cargar un módulo de configuración específico del plugin
    -- @param modulo string Nombre del módulo a cargar (sin extensión .lua)
    -- @return boolean ok Indica si la carga fue exitosa
    -- @return table|nil res Tabla con el contenido del módulo cargado, o nil si no se encontró
    -- @return number|nil log_level Nivel de log (vim.log.levels) en caso de error
    -- @return string|nil msg Mensaje de error en caso de error
    local function _comprobar_modulo(modulo)
        if type(modulo) ~= "string" or modulo == "" then
            return false, nil, vim.log.levels.ERROR, "Nombre de módulo de configuración debe ser una cadena no vacía"
        end

        if clave_ruta_config == nil then
            return true, nil
        end

        local clave_modulo = clave_ruta_config .. "." .. modulo
        local ok, res = pcall(require, clave_modulo)
        if not ok then
            return false, nil, vim.log.levels.ERROR, "Error al cargar el módulo de configuración " .. clave_modulo .. ": " .. tostring(res)
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
    local function get_config(modulo, pre_opts)
        local ok, res, log_level, msg = _comprobar_modulo(modulo)

        if res == nil then
            res = pre_opts
        elseif type(res) == "table" then
            if type(pre_opts) ~= "table" then
                pre_opts = {}
            end 
            res = vim.tbl_deep_extend("force", pre_opts, res)
        end

        return ok, res, log_level, msg
    end


    -- Callback para llamar a la función setup del plugin.
    -- @param plugin_spec table Tabla con la especificación del plugin (usado en Lazy)
    -- @param opts table Tabla con las opciones de configuración del plugin
    -- @return nil
    local function callback_setup(plugin_spec, opts)
        local ok, res = pcall(require, plugin_mod)
        if not ok then
            vim.notify("Error al cargar el módulo de setup " .. plugin_mod .. ": " .. tostring(res), vim.log.levels.ERROR)
            return
        end
        if type(res) ~= "table" or not res["setup"] or type(res["setup"]) ~= "function" then
            vim.notify("El módulo " .. plugin_mod .. " no tiene método setup", vim.log.levels.WARN)
            return
        end
        ok, res = pcall(res.setup, opts)
        if not ok then
            vim.notify("Error al ejecutar el método setup de " .. plugin_mod .. ": " .. tostring(res), vim.log.levels.ERROR)
            return
        end
    end


    -- Obtener una función de callback para cargar las opciones de un  módulo de configuración del plugin
    -- @param modulo string Nombre del módulo a cargar (sin extensión .lua)
    -- @param pre_datos table Tabla con datos previos para combinar con las opciones cargadas
    -- @param min_name_log_level string Nivel mínimo de log para notificaciones, en mayúsculas o minúsculas:
    -- ("TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF")
    -- @return function Función de callback que carga las opciones cuando se llama
    local function get_callback_get_config(modulo, min_name_log_level)
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
