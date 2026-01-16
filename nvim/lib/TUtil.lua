E = require("lib.error")

local TUtil = {}
TUtil.__index = TUtil
local _prv = {}


-- Copiar la metatabla de una tabla origen (tabla) a la tabla destino (self)
-- @param self table Tabla a la cual copiar la metatabla de la tablña origen
-- @param tabla table Tabla de la cual obtener la metatabla a copiar.
-- @param clona_mt Boolean true si se clona la metatabla o false si se copia 
-- -- solo la referencia.
-- @throws table {tipo = string, msg = string}
-- -- E_ARG si hay inconsistencia en los argumentos.
-- -- E_VALUE si no se puede obtener o asignar la metatabla
function TUtil:copiar_metatabla(tabla, clona_mt)
    assert(type(self) == "table", {tipo = E.E_ARG, msg = "La tabla destino no es una tabla"})
    assert(type(tabla) == "table", {tipo = E.E_ARG, msg = "La tabla origen no es una tabla"})

    local metatabla = getmetatable(tabla)
    if metatabla == nil then
        return self
    end

    if clona_mt then
        local ok, res = pcall(TUtil.clonar_shallow, metatabla)
        assert(ok, {tipo = res.tipo == E.E_ARG and E.E_VALUE or res.tipo, 
                    msg = string.format("No se puede clonar la metatabla de la tabla original: %s", res.msg)})
        metatabla = res
    end

    local ok, err = pcall(setmetatable, self, metatabla)
    assert(ok, {tipo = E.E_VALUE, msg = string.format("No se puede asignar la metatabla a la tabla: %s", tostring_seg(err))}, 2)

    return self    
end



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


