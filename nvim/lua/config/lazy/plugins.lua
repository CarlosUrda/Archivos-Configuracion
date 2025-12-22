-- Esta tabla de tablas debe ser asignada al campo 'spec' de la tabla 'opts' que se pasa a 'lazy.setup()'.
-- Cada subtabla puede contener la especificación de configuración de un plugin por lazy.nvim.
-- Si una subtabla contiene solo el campo 'import', lazy.nvim importará los plugins desde el directorio especificado en todos los runtimespaths.
local spec = {
    -- import your plugins
    { import = "plugins" },
}

return spec
