-- Hacer funciones hacer_imprimible y hacer_constante en el módulo TUtil.
-- Este módulo debe ser constante y los errores lanzados deben ser imprimibles.

local E = {}
local _prv = {}

local TUtil = require("lib.tutil")

function E.noop() end

E.NIL = {}

_prv[E].debug = false
E.assert_dbg = E.debug and assert or E.noop
E.assertf_dbg = E.debug and E.assertf or E.noop

_prv[E].INFO_TIPO_ERR = {
    ERR = {
        msg = "Error",
    },
    TIPO = {
        msg = "Tipo de dato inválido",
    },
    SPEC = {
        msg = "Inconsistencia en la especificación",
    }
    VALOR = {
        msg = "Valor inválido",
    }
    META = {
        msg = "Error al preparar el lanzamiento de un error",
    },
    ARG = {
        msg = "Inconsistencia en argumento",
    }
}


-- Comprueba la veracidad de un valor.
-- @param valor any Promociona a boolean. Comprueba si el valor se considera como true
-- @return boolean true si se considera como verdadero y false si se considera como falso.
function E.es_true(valor)
    return valor ~= false and valor ~= nil
end

-- Comprueba la falsedad de un valor.
-- @param valor any Promociona a boolean. Comprueba si el valor se considera como false
-- @return boolean true si se considera como falso y false si se considera como verdadero.
function E.es_false(valor)
    return not E.es_true(valor)
end


-- Comprueba si una función es un número entero.
-- @param numero any Valor a comprobar si es un número entero.
-- @return boolean Si es entero devuelve true, si no lo es false.
function E.es_entero(numero)
    return type(numero) == "number" and math.floor(numero) ~= numero
end


-- Comprobar si un valor es igual a otro valor, dando la posibilidad de aceptar nil. 
-- @param valor any Valor a comprobar
-- @param valor_cmp any Valor con el cual comparar.
-- @param nil_valido any Promociona a boolean. Si es verdadero, admite el valor nil como válido.
-- -- Si es falso el valor nil no se considera válido. Por defecto inválido.
-- @return boolean true si los valóres son iguales, o es nil y nil_valido es verdadero.
-- @throws Error si los argumentos no son del tipo adecuado.
function E.es_valor(valor, valor_cmp, nil_valido)
    return valor == valor_cmp or (es_true(nil_valido) and valor == nil)
end


-- Comprobar si un valor es igual a otro valor
-- @param valor any Valor a comprobar
-- @param tipo string Tipo esperado del valor (según devuelve type())
-- @param nil_valido boolean|nil Indica si se admite el valor nil como válido. Por defecto inválido.
-- @return boolean true si el valor es del tipo esperado o es nil y nil_valido es true.
-- @throws Error si los argumentos no son del tipo adecuado.
function E.es_tipo(valor, tipo, nil_valido)
    assertf_dbg(type(tipo) == "string", "ERR.META.ARG.TIPO",
        "El segundo argumento (tipo a comprobar) debe ser string", "STRING_ESPERADO", 
        {var = "tipo", val = tipo, fun = "E.es_tipo"}, 2)
    
    return E.es_valor(type(valor), tipo, nil_valido)
end


-- Cambiar el flag debug para ejecutar el módulo en modo debug.
-- @param estado any Valor del estado considerado como boolean.
-- @return boolean Valor de estado promocionado a boolean.
function E.cambiar_debug(estado)
    _prv[E].debug = E.es_true(estado)

    return _prv[E].debug
end

-- Obtener el mensaje por defecto asociado a cada tipo de error predefinido
-- @param string Tipo de error (subtipos de error separados por punto)
-- @return string Mensaje por defecto asociado a ese tipo de error.
-- @throws {tipo, msg, codigo, {var, val, , subval, fun}}
function _prv[E].obtener_msg(tipo_err)
    local extra = {var = "tipo_err", val = tipo_err, fun = "E.obtener_msg"}
    assertf_dbg(type(tipo_err) == "string", "ERR.META.ARG.TIPO", "El primer argumento (tipo_err) debe ser string", "STRING_ESPERADO", extra, 2)

    local tipo_err_norm = tipo_err:match("^%s*([%w_]+(%.[%w_]+)*)%s*$") 
    assertf_dbg(tipo_err_norm ~= nil, "ERR.META.ARG.VALOR", "El primer argumento (tipo_err) debe estar en formato correcto", "FORMATO_INVALIDO", extra, 2)
    tipo_err_norm = tipo_err_norm:upper()

    local msg = ""
    local info_tipo_err = _prv[E].INFO_TIPO_ERR
    for subtipo_err in string.gmatch(tipo_err_norm, "[_%w]+") do
        extra.subval = subtipo_err
        local info_subtipo_err = info_tipo_err[subtipo_err]
        assertf_dbg(type(info_subtipo_err) == "table", "ERR.META.ARG.VALOR", "El subtipo de error %s del primer argumento (tipo_err) no es un tipo predefinido":format(subtipo_err), "TIPO_ERR_INVALIDO", extra, 2) 
        msg_subtipo = info_subtipo_err.msg
        assertf_dbg(type(msg_subtipo) == "string", "ERR.META.SPEC", "El campo msg por defecto del subtipo de error %s no es una cadena":format(subtipo_err), "STING_ESPERADO", extra, 2) 
        msg = msg .. msg_subtipo .. ":"
    end
    
    return msg:match("(.*):")
end

function E.crear_err(tipo, codigo, msg, extra)
    if E.MSG_DEFECTO[tipo] == nil then
        error({
            tipo = E.TIPO.E_META, 
            msg = "El valor de tipo de error debe de ser un valor válido predefinido"},
            info = {var = "tipo", val = tipo}
        })
    end
    if type(msg) ~= "string" then
        error({
            tipo = E.TIPO.E_META, 
            msg = "El mensaje de error debe ser de tipo string"},
            info = {var = "msg", val = msg}
        })
    end
    if type(msg) ~= "string" then
        error({
            tipo = E.TIPO.E_META, 
            msg = "El mensaje de error debe ser de tipo string"},
            info = {var = "msg", val = msg}
        })
    end

    -- El error creado debe ser imprimible.
end


function E.error(err, nivel)
    if nivel ~= nil then 
        if not E.es_entero(nivel) then
            error({"ERR.META.ARG.TIPO", "El parametro nivel debe ser un entero", "ENTERO_ESPERADO", {var = "nivel", val = nivel, fun = "E.error"}}, 2)
        elseif nivel < 0 then
            error({"ERR.META.ARG.VALOR", "El parametro nivel debe ser >= 0", "ENTERO_>=0_ESPERADO", {var = "nivel", val = nivel, fun = "E.error"}}, 2)
        end
    end
    error(err, nivel)
end


function E.errort(tipo, msg, codigo, extra, nivel)
    local err = crear_err(tipo, msg, codigo, extra)
    E.error(err, nivel) 
end


function E.error_cond(cond, err, nivel)
    if cond then return end

    if type(err) == "function" then
        err = err()
    end

    E.error(err, nivel)
end


function E.error_condt(cond, tipo, msg, codigo, extra, nivel)
    if cond then return end
    E.errort(tipo, msg, codigo, extra, nivel)
end


function _prv[E].validar_info(info)

end






