# Archivos de Configuración
Archivos de Configuración de distintas herramientas usadas: Vim, Git, Bash, etc.

Los archivos se pueden distribuir opcionalmente de la siguiente manera:

~/.bashrc

~/.bash_profile

~/.gitconfig

~/git-completion.sh

~/git-prompt.sh

~/.vim/vimrc

Para poder usar el gestor de plugins Vundle hay que instalarlo previamente mediante:

$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Una vez instalado el plugin Vundle, dentro de vim ejecutar el comando :PluginInstall! Parara instalar y actualizar todos los plugins configurados en vimrc.

Los datos de instalación del plugin YouCompleteMe: https://github.com/Valloric/YouCompleteMe
Se debe añadir primero en vimrc el Plugin 'valloric/youcompleteme', actualizarlo y después ir a la carpeta bundle/youcompleteme y compilarlo ejecutando ./install.py --clang-completer. Este plugin se debe instalar solo con la opción --clang-completer, porque si se hace con --all no funciona la parte de JavaScript. Para que ésta funcione, se debe añadir en vimrc el Plugin 'marijnh/tern_for_vim' y luego ejecutar cd ~/.vim/bundle/term_for_vim && npm install (http://ternjs.net/).
Para que funcione correctamente el plugin tern_for_vim en ubuntu, se debe realizar el siguiente cambio:

Ubuntu "node.js" command is "nodejs" not "node". It works by modify autolad/tern.vim line 15 from
let g:tern#command = ["node", expand(':h') . '/../node_modules/tern/bin/tern', '--no-port-file']
to
let g:tern#command = ["nodejs", expand(':h') . '/../node_modules/tern/bin/tern', '--no-port-file'].
Can you add a option to set node.js command?
eg: let tern_nodejs_cmd = "nodejs"


Fuente de donde obtener plugins para vim:
http://vimawesome.com/

Fuente de donde se han obtenido los datos de instalación de plugins para javascript: http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
