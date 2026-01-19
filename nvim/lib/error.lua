-- Hacer funciones hacer_imprimible y hacer_constante en el módulo TUtil.
-- Este módulo debe ser constante y los errores lanzados deben ser imprimibles.

local E = {}
local _prv = {}

local TUtil = require("lib.tutil")

function E.noop() end

E.NIL = {}

E.debug = false
E.assert_dbg = E.debug and assert or E.noop
E.assertf_dbg = E.debug and E.assertf or E.noop

_prv[E]_TIPO = {
    ERR = {
        msg  = "Error",
        TIPO = {
            msg  = "Tipo de dato inválido",
        },
        SPEC = {
            msg = "Inconsistencia en la especificación",
        }
        VALOR = {
            msg = "Valor inválido",
        }
        META = {
            msg = "Error al preparar el lanzamiento de un error",
            ARG = _prv[E].TIPO.ERR.ARG,
            TIPO = _prv[E].TIPO.ERR.TIPO,
            VALOR = _prv[E].TIPO.ERR.VALOR,
        },
        ARG = {
            msg  = "Inconsistencia en argumento",
            TIPO = _prv[E].TIPO.ERR.TIPO,
            VALOR = _prv[E].TIPO.ERR.VALOR,
        }
    }
}

-- Comprueba si una función es un número entero.
-- @param 
function E.es_entero(numero)
    return type(numero) == "number" and math.floor(numero) ~= numero
end


-- Comprobar si un valor es igual a otro valor, dando la posibilidad de aceptar nil. 
-- @param valor any Valor a comprobar
-- @param valor_cmp any Valor con el cual comparar.
-- @param nil_valido boolean|nil Indica si se admite el valor nil como válido. Por defecto inválido.
-- @return boolean true si los valóres son iguales, o es nil y nil_valido es true.
-- @throws Error si los argumentos no son del tipo adecuado.
local function es_valor(valor, valor_cmp, nil_valido)
    return valor == valor_cmp or (nil_valido ~= false and nil_valido ~= nil)
end


-- Comprobar si un valor es igual a otro valor
-- @param valor any Valor a comprobar
-- @param tipo string Tipo esperado del valor (según devuelve type())
-- @param nil_valido boolean|nil Indica si se admite el valor nil como válido. Por defecto inválido.
-- @return boolean true si el valor es del tipo esperado o es nil y nil_valido es true.
-- @throws Error si los argumentos no son del tipo adecuado.
local function es_tipo(valor, tipo, nil_valido)
    assertf_dbg(type(tipo) ~= "string", "ERR.META.ARG.TIPO",
        "El segundo argumento (tipo a comprobar) debe ser string", "STRING_ESPERADO", 
        {var = "tipo", val = tipo}, 3)
    
    return type(valor) == tipo or (nil_valido and valor == nil)
end


-- Obtener la información relacionada a los tipos de errores predefinidos: el valor del tipo
-- de error que va dentro del objeto error lanzado y el mensaje por defecto.
function E.obtener_msg(tipo)
    assertf_dbg(type(tipo) ~= "string", "ERR.ARG.TIPO", "El primer argumento (tipo) debe ser string",
        "STRING_ESPERADO", {var = "tipo", val = tipo}, 3)

    msg = ""
    for subtipo in string.gmatch(tipo, "^[_%a]+"

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



function raise(tipo, msg, codigo, extra, nivel)
    err = crear_err(tipo, msg, codigo, extra)
    if nivel == nil then
        nivel = 2
    else
        assertf(E.es_entero(nivel), )
    end
    
end


function E.assertf(cond, info, nivel)
    if cond then return end

    if type(info) == "string" then
        tipo, msg_defecto = E.obtener_tipo(tipo)
    assertf_dbg(type(funcion) == "function", "ERR.ARG.TIPO", "El segundo parametro debe ser una función",
        "FUNCION_ESPERADA", {var = "funcion", val = funcion}, 3)


    if not cond then funcion()
        error( , nivel)
    end
end

function E.assertf(cond, tipo, msg, codigo, extra, nivel)

function _prv[E].validar_info(info)

end






