-- Desde aquí se cargan los módulos lanzadera para cada plugin instalado manualmente (no a través
-- de lazy.nvim). Un módulo lanzadera es un script que realiza una función equivalente a un 
-- archivo de especificación de plugin para lazy.nvim (excepto instalarlo, ya que el plugin ya
-- está instalado manualmente). 
-- Se encarga, básicamente, de añadir la ruta del plugin al runtimepath y de cargar su
-- configuración llamando a la función setup con las opciones adecuadas.
-- La ruta del plugin debe tener dentro la estructura /lua/<plugin>.lua o /lua/<plugin>/init.lua.
-- 
-- Un ejemplo de módulo lanzadera es 'bootstrap/<plugin>.lua', y carga el plugin con la línea
-- siguiente:
--
-- require("<plugin>").setup(opts)
--
-- Donde opts debe ser es una tabla con las opciones de configuración del plugin.
--
-- Si se desea usar el archivo genérico de inicialización ("config.init") que funciona a modo de
-- API exponiendo los datos de configuración del usuario, y guardar todos esos datos aparte en el
-- el directorio "config/<plugin>/ se puede usar el siguiente código a cambio:
-- -- local cfg = require("config.init").new("<plugin>")
-- -- local opts = cfg.get_opts()
-- -- cfg.setup(opts)
-- Los archivos de configuración del usuario son, por ejemplo:
--   .config/nvim/lua/config/<plugin>/opts.lua      -- Opciones específicas del plugin
--   .config/nvim/lua/config/<plugin>/plugins.lua   -- Especificaciones de plugins para el plugin
--   .config/nvim/lua/config/<plugin>/deps.lua      -- Dependencias del plugin
--
--   Si se desea que un módulo lanzadera se cargue automáticamente en lugar de tener que indicarlo
--   aquí manualmente, se debe añadir al directorio bootstrap/autoload.d

require("bootstrap.lazy")

-- En último lugar se cargan automáticamente los módulos lanzadera que se encuentren en el
-- directorio bootstrap/autoload.d
require("bootstrap.autoload")

