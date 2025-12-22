-- Este módulo carga automáticamente todos los módulos lanzadera que se encuentran en el directorio
-- bootstrap/autoload.d

local ruta_modulo = debug.getinfo(1, "S").source:match("^%s-@(.-)%s*$")
local ruta_dir, mensaje

-- Si la ruta del archivo del módulo actual no existe o es relativa, la obtenemos del argumento de la llamada a require a este
-- módulo, para poder encontrarla en el packagepath.
if not ruta_modulo or not vim.fs.is_absolute(ruta_modulo) then
    if type((...)) ~= "string" then
        mensaje = "No se puede obtener la ruta del directorio .d desde donde cargar los módulos automáticos"
    else
        local tbl_clave_modulo = vim.split((...), ".", { plain=true, trimempty=true }))
        if next(tbl_clave_modulo) == nil then
            mensaje = "No se puede obtener la ruta del directorio .d desde donde cargar los módulos automáticos"
        else
            tbl_clave_modulo[#tbl_clave_modulo] = tbl_clave_modulo[#tbl_clave_modulo] .. ".d"
            local ruta_dir_rtp = vim.fs.normalize(vim.fs.joinpath("lua", vim.tbl_unpack(tbl_clave_modulo))
            local rutas_dir = vim.api.nvim_get_runtime_file(ruta_dir_rtp, true)
            if #rutas_dir == 0 then
                mensaje = "No existe la ruta " .. ruta_dir_rtp .. " en el packagepath"
            elseif #rutas_dir > 1 then
                mensaje = "Ambigüedad al encontrarse duplicadas las rutas: " .. vim.inspect(rutas_dir)
            else
                ruta_dir = rutas_dir[1]
            end
        end
    end
else
    ruta_dir = vim.fn.fnamemodify(ruta_modulo, ":r") .. ".d"
    -- local ruta_dir, n = ruta_modulo:gsub("(.*%.)lua", "%1d")
end

if mensaje then
    vim.notify(mensaje, vim.log.levels.WARN)
    return nil, mensaje
end

for modulo, tipo in vim.fs.dir(ruta_dir) do
    if tipo == "file" and modulo:match("%.lua$") then
        local ruta_sub_modulo = vim.fs.normalize(vim.fs.joinpath(ruta_dir, modulo))
        local chunk, err = loadifile(ruta_sub_modulo)
        if not chunk then
            vim.notify("Error al cargar el módulo " .. ruta_sub_modulo .. ": " .. err, vim.log.levels.WARN)
        else
            ok, res = pcall(chunk)
            if not ok then
                vim.notify("Error al ejecutar el módulo " .. ruta_sub_modulo .. ": " .. res, vim.log.levels.WARN)
            else
                vim.notify("Módulo " .. ruta_sub_modulo .. " cargado correctamente", vim.log.levels.INFO)
            end
        end
    end
end
