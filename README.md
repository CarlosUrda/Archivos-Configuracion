# Archivos de Configuración
Archivos de Configuración de distintas herramientas usadas: Vim, Git, Bash, etc.

Los archivos se pueden distribuir opcionalmente de la siguiente manera:

_~/.bashrc_

_~/.bash_profile_

_~/.gitconfig_

_~/git-completion.bash_

_~/git-prompt.sh_

_~/.vim/vimrc_

Para poder usar el gestor de plugins Vundle hay que instalarlo previamente mediante:

`$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

Una vez instalado el plugin Vundle, dentro de vim ejecutar el comando :PluginInstall! Parara instalar y actualizar todos los plugins configurados en vimrc.

En https://github.com/Valloric/YouCompleteMe se encuentran la información para la instalación del plugin YouCompleteMe.
Para poder usar este plugin, primero se debe añadir en vimrc la línea 'valloric/youcompleteme', actualizar Vundle y después ir a la carpeta ~/.vim/bundle/youcompleteme y compilarlo el plugin ejecutando ./install.py --clang-completer. 
Este plugin se debe instalar solo con la opción --clang-completer para evitar la parte que corresponde a JavaScript. Si se desea incluir la parte de JavaScript se debe ejecutar ./install.py --all, añadir en vimrc la línea del plugin 'marijnh/tern_for_vim' y luego ejecutar cd ~/.vim/bundle/term_for_vim && npm install (http://ternjs.net/).
Además, para que funcione correctamente este plugin tern_for_vim en ubuntu, se debe realizar el siguiente cambio:

Ubuntu "node.js" command is "nodejs" not "node". It works by modify autolad/tern.vim line 15 from
let g:tern#command = ["node", expand(':h') . '/../node_modules/tern/bin/tern', '--no-port-file']
to
let g:tern#command = ["nodejs", expand(':h') . '/../node_modules/tern/bin/tern', '--no-port-file'].
Can you add a option to set node.js command?
eg: let tern_nodejs_cmd = "nodejs"


Fuente de donde obtener plugins para vim:
http://vimawesome.com/

Fuente de donde se han obtenido los datos de instalación de plugins para javascript: http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
