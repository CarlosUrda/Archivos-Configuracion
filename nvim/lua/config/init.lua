-- Description: Módulo para gestionar la configuración de otros plugins en Neovim.
-- Hace de puerta de entrada para cargar la configuración específica de cada plugin.
-- Expone a modo de API la configuración de usuario de cada plugin
-- -- Este módulo permite cargar opciones y plugins específicos para un plugin dado.

local M = {}
local _NIL = {}

local _TIPO_ERR_ARG   = "E_ARG"
local _TIPO_ERR_SPEC  = "E_SPEC"
local _TIPO_ERR_VALUE = "E_VALUE"

local TUtil = {}
TUtil.__index = TUtil
local _prv = {}

-- Clonar una tabla de forma recursiva (no comprueba consistencia de argumentos).
-- @param tabla table Tabla a copiar
-- @param copia_claves boolean|nil Indica si se deben copiar las claves de la tabla. Si nil = false
-- @param copia_valores boolean|nil Indica si se deben copiar los valores de la tabla. Si nil = false
-- @param nivel_max_copia number Nivel máximo de copia recursiva. 
-- -- Si es 0 no se realiza copia en ningún nivel (copia superficial).
-- -- Si es un número positivo N, se realiza copia recursiva hasta N niveles.
-- -- Si es negativo se realiza copia recursiva ilimitada.
-- @param tablas_vistas table Tabla usada internamente para evitar ciclos en la copia recursiva.
-- @return table Copia recursiva de la tabla.
function _prv[TUtil]._clonar_unsafe(tabla, copia_claves, copia_valores, nivel_max_copia, copia_metatabla, tablas_vistas)
    if tablas_vistas[tabla] then
        return tablas_vistas[tabla]
    end

    local copia = {}
    tablas_vistas[tabla] = copia
    if copia_metatabla then

    end

    if (copia_claves or copia_valores) and nivel_max_copia ~= 0 then
        if nivel_max_copia > 0 then
            nivel_max_copia = nivel_max_copia - 1
        end

        local type, pairs, clonar_unsafe = type, pairs, _prv[TUtil]._clonar_unsafe
        
        if copia_claves and copia_valores then
            for k, v in pairs(tabla) do
                if type(k) == "table" then k = clonar_unsafe(k, copia_claves, copia_valores, nivel_max_copia, tablas_vistas) end
                if type(v) == "table" then v = clonar_unsafe(v, copia_claves, copia_valores, nivel_max_copia, tablas_vistas) end
                copia[k] = v
            end
        elseif not copia_claves then
            for k, v in pairs(tabla) do
                if type(v) == "table" then v = clonar_unsafe(v, copia_claves, copia_valores, nivel_max_copia, tablas_vistas) end
        copia[k] = v
            end
        else
            for k, v in pairs(tabla) do
                if type(k) == "table" then k = clonar_unsafe(k, copia_claves, copia_valores, nivel_max_copia, tablas_vistas) end
                copia[k] = v
            end
        end
    else
        for k, v in pairs(tabla) do
            copia[k] = v
        end
    end

    return copia
end


function TUtil:copiar_unsafe(copia_claves, copia_valores, nivel_max_copia)
    return _prv[TUtil]._copiar_unsafe(self, copia_claves, copia_valores, nivel_max_copia, {})
end


-- Copiar una tabla de forma superficial (sin copia recursiva - no comprueba consistencia de argumentos).
-- @param tabla table Tabla a copiar.
-- @return table Copia superficial de la tabla.
function TUtil:copiar_shallow_unsafe()
    return _prv[TUtil]._copiar_unsafe(self, false, false, 0, {})
end



-- Copiar una tabla.
-- @param tabla table Tabla a copiar
-- @param copia_claves boolean|nil Indica si se deben copiar las claves de la tabla. nil = por defecto false.
-- @param copia_valores boolean|nil Indica si se deben copiar los valores de la tabla. nil = por defecto false.
-- @param nivel_max_copia number|nil Nivel máximo de copia recursiva. 
-- -- Si es nil o 0 no se realiza copia en ningún nivel (copia superficial).
-- -- Si es un número positivo N, se realiza copia recursiva hasta N niveles.
-- -- Si es negativo se realiza copia recursiva ilimitada.
-- @return table Copia de la tabla.
-- @throws Error si la entrada no es una tabla, o si los parámetros no son del tipo adecuado.
function TUtil:copiar(copia_claves, copia_valores, nivel_max_copia)
    if type(self) ~= "table" then
        error("La entrada no es una tabla", 2)
    end

    for nombre_arg, arg in pairs({copia_claves = copia_claves, copia_valores = copia_valores}) do
        if arg ~= nil and type(arg) ~= "boolean" then
            error(_hti({tipo = _TIPO_ERR_ARG, msg = string.format("El parámetro %s debe ser boolean o nil/vacío", nombre_arg)}), 2)
        end
    end

    if nivel_max_copia == nil then
        nivel_max_copia = 0
    elseif type(nivel_max_copia) ~= "number" or math.floor(nivel_max_copia) ~= nivel_max_copia then
        error(_hti({tipo = _TIPO_ERR_ARG, msg = "El parámetro nivel_max_copia debe ser un número entero"}), 2)
    end

    return _prv[TUtil]._copiar_unsafe(self, copia_claves, copia_valores, nivel_max_copia, {})
end


-- Copiar una tabla de forma superficial (sin copia recursiva - no comprueba consistencia de argumentos).
-- @param tabla table Tabla a copiar.
-- @return table Copia superficial de la tabla.
function TUtil:copiar_shallow()
    return self:copiar(false, false, 0)
end


-- Hacer que una tabla sea imprimible como cadena de texto (no comprueba consistencia de argumentos, aunque
-- la tabla sí debe dejar modificar su metatabla).
-- @param copia_metatabla boolean|nil Indica si se debe crear una copia de la metatabla existente. Si es nil
-- @return table Tabla original con metatabla que permite imprimirla como cadena de texto.
-- @throws table {tipo = string, msg = string}
-- -- Si la tabla no se puede hacer imprimible modificando su metatabla, se lanza error.
-- -- tipo es error de argumento ERR_ARG
-- -- msg es el mensaje con la descripción del error.
function TUtil:hacer_imprimible_unsafe(copia_metatabla)
    local metatabla = getmetatable(self) or {}
    if type(metatabla) ~= "table" then
        error({tipo = _TIPO_ERR_ARG, msg = "No se puede acceder a la metatabla: ésta no es una tabla"}, 2)
    end

    if copia_metatabla then
        metatabla = _copiar_tabla_shallow(metatabla)
    end

    metatabla.__tostring = vim.inspect
    metatabla.__concat = function(a, b) return tostring(a) .. tostring(b) end
    local ok, err = pcall(setmetatable, self, metatabla)
    if not ok then
        error({tipo = _TIPO_ERR_ARG, msg = string.format("No se puede asignar la metatabla a la tabla: %s", tostring_seg(err))}, 2)
    end

    return self
end


-- Hacer que una tabla sea imprimible como cadena de texto (no comprueba consistencia de argumentos).
-- @param copia_metatabla boolean|nil Indica si se debe crear una copia de la metatabla existente. Si es nil
-- @return table Tabla original con metatabla que permite imprimirla como cadena de texto. Si no se puede
-- -- modificar o asignar la metatabla de la tabla, devuelve la tabla original y un mensaje de error.
function TUtil:hacer_imprimible_try_unsafe(copia_metatabla)
    local ok, res, err = pcall(self.hacer_imprimible_unsafe, self, copia_metatabla)
    if not ok then
        return self, res.msg
    end

    return self
end


-- Hacer que una tabla sea imprimible como cadena de texto.
-- @param copia_metatabla boolean|nil Indica si se debe crear una copia de la metatabla existente. Si es nil
-- o no se pasa valor se toma por defecto false.
-- @param try boolean Si true y la tabla no se puede hacer imprimible no lanza ningún error y devuelve
-- -- la propia tabla. Si false lanza error al no poder hacerla imprimible. Esto no afecta a la comprobación
-- -- de los argumentos de entrada.
-- @return table Si try es true, tabla original con metatabla que permite imprimirla como cadena de texto.
-- -- Si la tabla ya tenía metatabla, se le añaden los métodos __tostring y __concat, sobrescribiéndolos si 
-- -- ya existían.
-- -- Si no tenía metatabla, se crea una nueva metatabla con esos métodos.
-- @throws Si try es nil/false Error tipo ERR_ARG si los argumentos no son del tipo adecuado, o error
-- tipo ERR_VALUE si no se puede asignar o modificar la metatabla de la tabla.
function TUtil:hacer_imprimible(copia_metatabla, try)
    if type(self) ~= "table" then
        error({tipo = _TIPO_ERR_ARG, msg = "La entrada no es una tabla"}, 2)
    end
    if copia_metatabla ~= nil and type(copia_metatabla) ~= "boolean" then
        error({tipo = _TIPO_ERR_ARG, msg = "El parámetro copia_metatabla debe ser boolean o nil/vacío"}, 2)
    end

    if try then
        return self:hacer_imprimible_try_unsafe(copia_metatabla) 
    else
        return self:hacer_imprimible_unsafe(copia_metatabla)
    end

end


-- Versión rápida de hacer_tabla_imprimible sin copia de metatabla, sin comprobar argumentos y sin lanzar errores.
-- @return table Tabla original con metatabla que permite imprimirla como cadena de texto. Si no se puede
-- -- modificar o asignar la metatabla de la tabla, devuelve la tabla original y un mensaje de error.
function TUtil:hitu() 
    return self:hacer_imprimible_try_unsafe(false, false)
end


-- Busca un valor entre los valores de una tabla (no comprueba argumentos)
-- @param valor any valor a comprobar si existe dentro de la tabla
-- @return boolean true o false si encuentra el valor o no.
function TUtil:contiene_unsafe(valor)
    for _, v in pairs(self) do
        if v == valor then
            return true
        end
    end

    return false
end


function TUtil:contiene(valor)
    if type(self) ~= "table" then
        error({tipo = _TIPO_ERR_ARG, msg = "La entrada no es una tabla"}, 2)
    end
    return self:contiene_unsafe(valor)
end


-- Comprobar si el nombre de un tipo es válido (uno de los tipos existentes)
-- @param tipo string Nombre del tipo a comprobar.
-- @return boolean true si el nombre del tipo es válido.
local function nombre_tipo_valido(tipo)
    return tipo == "nil" or tipo == "string" or tipo == "table" or tipo == "number" or tipo == "boolean" or tipo == "function" or 
        tipo == "userdata" or tipo == "thread"
end


-- Comprobar si un valor es igual a otro valor, dando la posibilidad de aceptar nil. 
-- @param valor any Valor a comprobar
-- @param valor_cmp any Valor con el cual comparar.
-- @param nil_valido boolean|nil Indica si se admite el valor nil como válido. Por defecto inválido.
-- @return boolean true si los valóres son iguales o es nil y nil_valido es true.
-- @throws Error si los argumentos no son del tipo adecuado.
local function es_valor(valor, valor_cmp, nil_valido)
end


-- Comprobar si un valor es igual a otro valor
-- @param valor any Valor a comprobar
-- @param tipo string Tipo esperado del valor (según devuelve type())
-- @param nil_valido boolean|nil Indica si se admite el valor nil como válido. Por defecto inválido.
-- @return boolean true si el valor es del tipo esperado o es nil y nil_valido es true.
-- @throws Error si los argumentos no son del tipo adecuado.
local function es_tipo(valor, tipo, nil_valido)
    if type(tipo) ~= "string" then
        error(_hti({tipo = _TIPO_ERR_ARG, msg = "El tipo a comprobar debe ser una cadena de texto"}), 2)
    end
    if nil_valido ~= nil and type(nil_valido) ~= "boolean" then
        error(_hti({tipo = _TIPO_ERR_ARG, msg = "El parámetro nil_valido debe ser boolean o nil/vacío"}), 2)
    end
    
    return type(valor) == tipo or (nil_valido and valor == nil)
end



-- Validar la especificación con la información de una varible en la función validar.
-- @param spec table Especificación de la variable a validar.
-- @throws Error con mensaje explicando la inconsistencia en la especificación.
local function _validar_spec(spec)
    if type(spec) ~= "table" then
        error(_hti({tipo = _TIPO_ERR_SPEC, msg = "La especificación de variable debe ser una tabla"}), 3)
    end
    if type(spec.nombre) ~= "string" then
        error(_hti({tipo = _TIPO_ERR_SPEC, msg = "El nombre de la variable en la especificación debe ser una cadena de texto"}), 3)
    end
    for _, campo_tipos in ipairs({"tipo_valido", "tipo_filtro"}) do
        if type(spec[campo_tipos]) == "table" then
            for _, tipo in ipairs(spec[campo_tipos]) do
                if not nombre_tipo_valido(tipo) then
                    error(_hti({tipo = _TIPO_ERR_SPEC, msg = string.format("El tipo %s dentro de %s en la especificación no es un tipo reconocido", tostring_seg(tipo), campo_tipos)}), 3)
                end
            end
        elseif spec[campo_tipos] ~= nil and not nombre_tipo_valido(spec[campo_tipos]) then
            error(_hti({tipo = _TIPO_ERR_SPEC, msg = string.format("El campo %s en la especificación no es un tipo reconocido o una tabla de tipos", campo_tipos)}), 3)
        end   
    end
    for _, campo_funciones in ipairs({"pre_procesar", "post_procesar", "validar"}) do
        if type(spec[campo_funciones]) == "table" then
            for _, func in ipairs(spec[campo_funciones]) do
                if type(func) ~= "function" then
                    error(_hti({tipo = _TIPO_ERR_SPEC, msg = string.format("El campo %s en la especificación contiene un valor que no es una función", campo_funciones)}), 3)
                end
            end
        elseif spec[campo_funciones] ~= nil and type(spec[campo_funciones]) ~= "function" then
            error(_hti({tipo = _TIPO_ERR_SPEC, msg = string.format("El campo %s en la especificación no es una función ni una tabla de funciones", campo_funciones)}), 3)
        end
    end
    if spec.msg ~= nil and type(spec.msg) ~= "string" then
        error(_hti({tipo = _TIPO_ERR_SPEC, msg = "El mensaje de error en la especificación debe ser una cadena de texto o nil"}), 3)
    end

    return true
 end


-- Validar y procesar el valor de una variable.
-- @param spec table Tabla con la especificación de la variable a validar. Los campos de la especificación son:
-- -- nombre string Nombre de la variable a validar. Obligatorio.
-- -- valor any Valor de la variable a validar. Si no está presente o es nil, el valor a validar es nil.
-- Los siguientes campos son todos opcionales y el orden en que se ejecutan las fases es el siguiente: 
-- pre_procesar => tipo_valido => tipo_filtro => validar => post_procesar:
--                             ↑___________________↑
-- Fase de pre-procesado:
-- -- pre_procesar function|table|nil Función o tabla de funciones que reciben el valor y devuelven el valor transformado que será usado
-- -- -- en las siguientes fases de validación. Si es tabla ordenada se aplica el pipeline de funciones en orden. En caso de algún problema
-- -- -- la función debe lanzar una excepción y se consideraría que el valor no pasa la validación. Si es nil no se realiza esta fase.
-- Fase de validación:
-- -- tipo_valido string|table|nil Tipos que validan directamente. Puede ser un solo tipo (string) o una tabla de tipos (table). 
-- -- -- Si el tipo del valor está incluid en tipo_valido, el valor pasa directamente a fase de post-procesado sin validar más. 
-- -- -- Si el tipo del valor no está incluido en tipo_valido, se pasa a la siguiente fase de validación (tipo_filtro).
-- -- -- Si es nil se ignora esta comprobación y pasa a tipo_filtro.
-- -- tipo_filtro string|table|nil Tipos que permiten entrar a validar. Puede ser un solo tipo (string) o una tabla de tipos (table). 
-- -- -- Si el tipo del valor es uno de tipo_filtro, el valor pasa a la siguiente fase de validar.
-- -- -- Si el tipo del valor no es ninguno de tipo_filtro, se lanza error de validación desechando el valor como no validado.
-- -- -- Si es nil se ignora esta comprobación y se pasa a validar.
-- -- validar function|table|nil Función o tabla de funciones que reciben el valor y devuelven dos valores:
-- -- -- -- boolean: true si es válido, false si no lo es.
-- -- -- -- string: mensaje de error en caso de no ser válido.
-- -- -- Si es tabla ordenada se aplica un OR de las funciones en orden. Si alguna devuelve true se considera valor válido y pasa
-- -- -- -- directamente a la fase de post-procesado.
-- -- -- Si todas las funciones devuelven false (ninguna pasa la validación), se lanza error desechando el valor como no validado.
-- -- -- Si es nil se considera valor válido y pasa directamente a post-procesado.
-- Fase de post-procesado:
-- -- post_procesar function|table|nil Función o tabla de funciones que reciben el valor y devuelven el valor transformado.
-- -- -- Si es tabla ordenada se aplica el pipeline de funciones en orden. En caso de algún problema la función debe lanzar un error
-- -- -- y se consideraría que el valor no pasa la validación. Si es nil no se realiza esta fase.
-- @return any Valor validado y procesado.
-- @throws table {tipo=string, msg=string}
-- -- tipo string Tipo de error: 
-- -- -- E_VALUE para errores en la validación o procesamiento del valor.
-- -- -- E_SPEC error por incumplimiento de contrato en la especificación.
local function validar(spec)
    _validar_spec(spec)

    local valor = spec.valor
    local nombre = spec.nombre
    local msg = spec.msg and spec.msg .. ": " or ""

    local pre_procesar = type(spec.pre_procesar) == "function" and { spec.pre_procesar } or spec.pre_procesar or {}
    for _, pre_func in ipairs(pre_procesar) do
        local ok, res = pcall(pre_func, valor)
        if not ok then
            error(_hti({tipo = _TIPO_ERR_VALUE, msg = string.format("%sError en pre_procesar de %s: %s", msg, nombre, tostring_seg(res))}), 2)
        end
        valor = res
    end

    local validado = false 

    local tipo_valido = type(spec.tipo_valido) == "string" and { spec.tipo_valido } or spec.tipo_valido or {}
    for _, tipo in ipairs(tipo_valido) do
        if type(valor) == tipo then
            validado = true
            break
        end
    end

    if not validado then
        local filtrado = spec.tipo_filtro == nil

        local tipo_filtro = type(spec.tipo_filtro) == "string" and { spec.tipo_filtro } or spec.tipo_filtro or {}
        for _, tipo in ipairs(tipo_filtro) do
            if type(valor) == tipo then
                filtrado = true
                break
            end
        end

        if not filtrado then
            error(_hti({tipo = _TIPO_ERR_VALUE, msg = string.format("%sEl tipo del valor de %s no está incluido en tipo_filtro", msg, nombre)}), 2)
        end

        local validar = type(spec.validar) == "string" and { spec.validar } or spec.validar or {}
        for _, valid_func in ipairs(validar) do
            local ok, res, err = pcall(valid_func, valor)
            if not ok then
                error(_hti({tipo = _TIPO_ERR_SPEC, msg = string.format("La función validar ha lanzado un error validando %s: %s", nombre, tostring_seg(res))}), 2)
            end
            if res then
                validado = true
                break
            else
                -- Hacer algo con el mensaje de error
            end
        end

        if not validado then
            error(_hti({tipo = _TIPO_ERR_VALUE, msg = string.format("%sEl valor de %s no ha pasado ninguna función validar", msg, nombre)}), 2)
        end
    end

    local post_procesar = type(spec.post_procesar) == "function" and { spec.post_procesar } or spec.post_procesar or {}
    for _, pre_func in ipairs(post_procesar) do
        local ok, res = pcall(pre_func, valor)
        if not ok then
            error(_hti({tipo = _TIPO_ERR_VALUE, msg = string.format("%sError en post_procesar de %s: %s", msg, nombre, tostring_seg(res))}), 2)
        end
        valor = res
    end



    if type(args) ~= "table" then
        error("Los argumentos a comprobar deben estar en una tabla", 2)
    end
    if validaciones_defecto == nil then
        validaciones_defecto = _VALIDACIONES_DEFECTO_ARGS
    end

    local err_args = hacer_tabla_imprimible({}) 
    local res_args = {}

    for arg, validacion in pairs(args) do
        if type(validacion) ~= "table" then
            error(string.format("La información del argumento %s debe ser una tabla", tostring_seg(arg)), 2)
        end

        local validacion_defecto = nil
        if validacion.regla ~= nil then
            validacion_defecto = validaciones_defecto[validacion.regla]
        end
        local validar = validacion.validar
        local msg = validacion.msg

        if validar == nil then
            if validacion_defecto ~= nil then
                validar = validacion_defecto.validar
            end
        elseif type(validar) ~= "function" then
            error(string.format("La función de validación del argumento %s no es una función", tostring_seg(arg)), 2)
        end

        if msg == nil then 
            msg = validacion_defecto and validacion_defecto.msg or "El argumento %s no es válido"
        elseif type(msg) ~= "string" then
            local ok
            ok, msg = pcall(tostring, msg)
            if not ok or type(msg) ~= "string" then
                error(string.format("El mensaje de error del argumento %s no es una cadena ni convetible a cadena", tostring_seg(arg)), 2)
            end
        end

        if validar ~= nil then 
            local ok, res = validar(validacion.valor)
            if not ok then
                err_args[arg] = string.format(msg, tostring_seg(arg))
            else
                res_args[arg] = res
            end
        end
    end

    if next(err_args) then
        error(err_args, 2)
    end

    return res_args
end


local function normalizar_condiciones(condiciones)
end


-- Verificar las reglas de validaciones por defecto de los argumentos.
-- @param validaciones_defecto table Tabla con las validaciones por defecto a comprobar.
-- -- Cada entrada de la tabla es una clave regla cuyo valor es otra tabla con los campos:
-- -- -- validar function Función de validación que recibe el valor y devuelve dos valores:
-- -- -- -- -- boolean: true si es válido, false si no lo es.
-- -- -- -- -- any valor transformado del valor original (si no se transforma, se devuelve el valor original).
-- -- -- msg string Mensaje de error a lanzar si el valor no es válido. Usar %s para incluir el nombre del argumento.
-- @return true Si todas las validaciones por defecto están bien definidas.
-- @throws Error con mensaje explicando la inconsistencia en la entrada.
function _verificar_validaciones_defecto_args(validaciones_defecto)
    if type(validaciones_defecto) ~= "table" then
        error("Las reglas de validaciones por defecto de los argumentos deben estar en una tabla", 2)
    end

    for regla, validacion_defecto in pairs(validaciones_defecto) do
        if type(validacion_defecto) ~= "table" then
            error(string.format("La validación por defecto de la regla %s debe estar una tabla", tostring_seg(regla)), 2)
        end

        local validar = validación_defecto.validar
        local msg = validación_defecto.msg

        if type(validar) ~= "function" then
            error(string.format("La función de validación por defecto de la regla %s no es una función", tostring_seg(regla)), 2)
        end

        if type(msg) ~= "string" then
            if msg == nil then
                error(string.format("El mensaje de error por defecto de la regla %s no está definido", tostring_seg(regla)), 2)
            end
            local ok, res = pcall(tostring, msg)
            if not ok or type(res) ~= "string" then
                error(string.format("El mensaje de error por defecto de la regla %s no es una cadena ni convetible a cadena", tostring_seg(regla)), 2)
            end
        end
    end

    return true
end




_verificar_validaciones_defecto_args(_VALIDACIONES_DEFECTO_ARGS)


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
    else
        _validar_args({ nivel = { valor = nivel, regla = "entero_positivo" }, 
                        funcion = { valor = funcion, regla = "funcion" } })
    end
 
    local res = table.pack(pcall(funcion, ...))
    if not res[1] then error(res[2], nivel) end

    return table.unpack(res, 2, res.n)
end


local function hacer_constante_tabla(tabla)
-- Convertir un valor a cadena de texto de forma segura.
-- @param valor any Valor a convertir a cadena
-- @return string Cadena resultante de la conversión, o cadena vacía si no se pudo convertir.
local function tostring_seg(valor, es_seguro, nivel_error, msg_error)
    local ok, res = pcall(tostring, valor)
    if not ok or type(res) ~= "string" then
        if 
        return ""
    end
    return res
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

_prv[GestionCache]._VALIDACIONES_DEFECTO_ARGS = { 
    clave = {
        validar = function(v) return v ~= nil and not (type(v) == "number" and v ~= v) end,
        msg = "%s debe ser un valor válido (nil o NaN inválidos)"
    },
    normalizar = {
        validar = function(v) return v == nil or type(v) == "function" end,
        msg = "%s debe ser una función, o nil si no se desea normalizar"
    },
    procesando = {
        validar = function(v) return v == nil or type(v) == "boolean" end,
        msg = "%s debe ser boolean o nil si no se desea esperar"
    },
}


_verificar_validaciones_defecto_args(_prv[GestionCache]._VALIDACIONES_DEFECTO_ARGS)


-- Crear una nueva instancia de Gestión de Caché.
-- @return table Instancia de Gestión de Caché.
function GestionCache.new()
    local self = setmetatable({}, GestionCache)
    _prv_wk[self] = {}
    _prv_wk[self]._cache = {}
    _prv_wk[self]._num_entradas = 0
    return self
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
