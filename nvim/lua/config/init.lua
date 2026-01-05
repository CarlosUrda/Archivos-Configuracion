-- Description: Módulo para gestionar la configuración de otros plugins en Neovim.
-- Hace de puerta de entrada para cargar la configuración específica de cada plugin.
-- Expone a modo de API la configuración de usuario de cada plugin
-- -- Este módulo permite cargar opciones y plugins específicos para un plugin dado.

local M = {}
local _NIL = {}


-- Envoltorio para ejecutar una función y relanzar su excepción con un nivel concreto desde dentro del
-- envoltorio. 
-- @param nivel number|nil Nivel usado al lanzar la excepción desde dentro del envoltorio. 
-- -- EL valor debe ser >= 0. Si nil se toma el valor 3 por defecto.
-- @param function Función a ejecutar
-- @return any EL valor devuelto por la función
-- @throws Si los argumentos no son válidos, lanza excepción nivel 2 explicando el error.
-- @throws Excepción lanzada por la función con el nivel indicado.
local function ejecutar(nivel, funcion, ...)
    if nivel == nil then
        nivel = 3
    elseif type(nivel) ~= "number" or nivel < 0 then
        error("Nivel debe ser un número >= 0", 2)
    elseif type(funcion) ~= "function" then
        error("Funcion debe ser una función", 2)
    end

    local res = table.pack(pcall(funcion, ...))
    if not res[1] then error(res[2], nivel) end

    return table.unpack(res, 2, res.n)
end


-- Crear función formatear tabla y añadirla a la metatabla con __tostring y __concat de las tablas devueltas al lanzar error.


local function normalizar_condiciones(condiciones)
end




-- Tabla para guardar datos privados
-- -- _prv_wk es para guardar datos de cada instancia de una clase (desaparecen cuando sea la clave sea
-- --   la ultima referencia al objeto)
-- -- _prv se suele usar para guardar métodos privados de prototipos (clases)
local _prv_wk = setmetatable({}, {__mode = "k"})
local _prv = {}

local GestionCache = {}
GestionCache.__index = GestionCache
_prv[GestionCache] = {}
-- Nombre de los campos estados de cada entrada de la caché que actúan como flags (boolean)
-- normalizado: si el dato fue normalizado antes de ser grabado en la entrada de la caché.
-- grabado: si se ha grabado algún dato en la entrada de la caché.
-- procesando: si está en proceso de nromalización un nuevo dato aunque aún no se ha grabado.
_prv[GestionCache].TAG_FLAGS_ENTRADA = {"normalizado", "grabado", "procesando"}

function GestionCache.new()
    local self = setmetatable({}, GestionCache)
    _prv_wk[self] = {}
    _prv_wk[self]._cache = {}
    return self
end


-- Comprobar argumentos de los distintos métodos de GestionCache
-- @param clave any Cualquier valor que vale como clave, excepto nil o NaN
-- @param normalizar function|nil Función que realiza la normalización del valor.
-- -- Si nil, no se realiza normalización.
-- @throws table arg => mensaje de error 
-- ** Porblema: hay que distinguir entre pasar nil para no comprobar ese arg o nil como valor del arg ***
function _prv[GestionCache]._comprobar_args(clave, normalizar, espera_procesando)
    local info_err = {}
    local tag_clave = "clave"
    local tag_normalizar = "normalizar"
    local tag_espera_procesando = "espera_procesando"

    if clave == nil or type(clave) == "number" and clave ~= clave then
        info_err[tag_clave] = string.format("%s debe ser un valor válido (nil o NaN inválidos)", tag_clave)
    end
    if normalizar ~= nil and type(normalizar) ~= "function" then
        info_err[tag_normalizar] = string.format("%s debe ser una función o nil si no se desea normalizar", tag_normalizar)
    end
    if espera_procesando ~= nil and type(espera_procesando) ~= "boolean" then
        info_err[tag_espera_procesando] = string.format("%s debe ser boolean o nil si no se desea esperar", tag_espera_procesando)
    end

    if next(info_err) then
        error(info_err, 2)
    end

    return true
end


-- Comprobar si una entrada de la caché es consistente y cumple las invariantes.
-- @param entrada table Entrada de la cache
-- @return true Si la entrada cumple las condiciones
-- @throws Error con mensaje explicando la inconsistencia en la entrada.
function _prv[GestionCache]._comprobar_entrada(entrada)
    if type(entrada) ~= "table" then
        error("La entrada no es una tabla", 2)
    elseif entrada.estados == nil then
        error("La entrada no tiene información sobre su estado", 2)
    elseif type(entrada.estados) ~= "table" then
        error("La información de estado de la entrada no está en una tabla", 2)
    end

    for _, tag_flag in ipairs(_prv[GestionCache].TAG_FLAGS_ENTRADA) do
        local flag = entrada.estados[tag_flag] 
        if flag == nil then
            error(string.format("El campo de estado %s no existe", tag_flag), 2)
        elseif type(flag) ~= "boolean" then 
            error(string.format("El campo de estado %s tiene tipo inválido (no es boolean)", tag_flag, 2))
        end
    end
    
    if entrada.estados["grabado"] and entrada.dato == nil then
        error("El campo dato se ha perdido y no existe", 2)
    end
    if not entrada.estados["grabado"] and entrada.dato ~= nil then
        error("El campo dato tiene contenido pero nunca se ha grabado en él.", 2)
    end

    return true
end


-- Obtener los datos de una entrada de la caché. 
-- ** Uso interno: no comprueba los argumentos de entrada **
-- @param self Objeto instancia de GestionCache de cuya caché se obtiene el valor.
-- @param any Clave usada para acceder al valor en la tabla de la caché
-- @param boolean espera_procesando Si existe algún dato procesando pendiente a grabar, esperar.
-- @return any dato Dato de la entrada.
-- @return boolean normalizado Si el dato fue normalizado al guardarlo.
-- @return boolean procesando Si hay un nuevo dato en proceso de normalización pendiente de ser grabado
-- @throws Error con mensaje explicando la inconsistencia en la entrada.
function _prv[GestionCache]._obtener_entrada(self, clave, espera_procesando)
    local entrada = _prv_wk[self]._cache[clave] 

    if entrada == nil then
        return nil, nil, nil
    end

    ejecutar(3, _prv[GestionCache]._comprobar_entrada, entrada)

    if entrada.estados["procesando"] and espera_procesado then
        -- AWAIT y cuando evento: flag procesando pasa a false

        ejecutar(3, _prv[GestionCache]._comprobar_entrada, entrada)
    end

    if not entrada.estados["grabado"] then
        return nil, nil, nil
    end

    local dato = entrada.dato
    if dato == _NIL then
        dato = nil

    return dato, entrada.estados["normalizado"], entrada.estados["procesando"]
end


-- Obtener los datos de una entrada de la caché. 
-- @param any Clave usada para acceder al valor en la tabla de la caché
-- @return any dato Dato de la entrada.
-- @return boolean normalizado Si el dato fue normalizado al guardarlo.
-- @return string estado Estado actual del dato. Si es válido o hay otro dato en proceso de normal.
-- @throws table arg => mensaje de error 
-- @throws Error con mensaje explicando la inconsistencia en la entrada.
function GestionCache:obtener_entrada(clave, espera_procesando)
    _prv[GestionCache]._comprobar_args(clave, espera_procesando)
    return _prv[GestionCache]._obtener_entrada(self, clave)
end


-- Grabar un valor en una entrada de la caché.
-- ** Uso interno: no comprueba los argumentos de entrada **
-- @param self Objeto instancia de GestionCache en cuya caché se graba el valor.
-- @param any Clave usada para asociar el valor en la tabla de la caché
-- @param any Valor a ser guardada en la entrada de la chaché.
-- @param nil|function Función de normalización a aplicar al valor antes de ser guardado.
-- -- Si es nil, no se aplica normalización.
function _prv[GestionCache]._grabar_valor(self, clave, valor, normalizar)
    local norma = false

    if normalizar then
        ok, res = pcall(normalizar, valor)
        if not ok then
            return false, "Error al ejecutar la función de normalización: " .. res    
        end
        valor = res
        norma = normalizar
    end

    _prv_wk[self]._cache[clave] = {norma = norma}  -- No merece la pena comparar si es nil
    if valor == nil then
        _prv_wk[self]._cache[clave].valor = _NIL
        return true, nil
    else
        return true, _prv_wk[self]._cache[clave]
    _prv_wk[self]._cache[clave].valor = valor


    elseif _prv_wk[self]._cache[clave] == _NIL then
        return true, nil
    else
        return true, _prv_wk[self]._cache[clave]
    end
end


function GestionCache:grabar_valor(clave, normalizar, valor)
    _prv[GestionCache]._comprobar_args(clave, normalizar)
    return _prv[GestionCache]._grabar_valor(self, clave, normalizar, valor)
end


function _prv[GestionCache]._limpiar(self, clave)
    if clave == nil then
        _prv_wk[self]._cache = {}
    else
        _prv_wk[self]._cache[clave] = nil 
end


function GestionCache:limpiar(clave)
    _prv[GestionCache]._comprobar_args(clave, normalizar)
    _prv[GestionCache]._limpiar(self, clave)
end

function GestionCache.actualizar_cache(clave, valor, normalizar, fuerza_grabar)
    self.comprobar_args(clave, normalizar)

    if fuerza_grabar or GestionCache._cache[clave] == nil then
        valor = (normalizar and normalizar(valor)) or valor
        GestionCache._cache[clave] = (valor == nil and _NIL) or valor
    end

    return self:obtener_valor(clave)
end

-- Comprobar si una cadena es de tipo string y cumple condiciones.
-- @param cadena string Cadena a comprobar
-- @param nil_valido boolean Si se admite el valor nil de la cadena como válido. Por defecto inválido.
-- @param vacio_valido boolean Si se admite la cadena vacía como válida. Por defecto inválido.
-- @return boolean ok si la cadena es válida
-- @return string|nil Cadena con los espacios eliminados en los bordes (trim), o nil
-- @return string msg Mensaje de tipo de error
local function comprobar_valor(valor, condiciones)
    local TAG_TIPOS, TAG_VALIDEZ, TAG_CONDICION, TAG_DEFECTO = "tipos", "condicion", "defecto"

    if type(condiciones) ~= "table" then
        if condiciones == nil then
            return cadena
        end
        error("Las condiciones de validación deben de ser una tabla")
    elseif next(condiciones) == nil then
        return cadena
    else if condiciones[tag_tipos] = 


    end

    

    { validez = true, 
      tipos = {"string" = true, 
               "number" = {validez = false, comp = nil, valores = {0, 10}}}
    }
    

    for tipo, validos in pairs(condiciones[tag_tipos]) do
        if tipo == type(valor) then
            z
        end
    end
    return false, nil, "El valor no es de un tipo correcto"
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
