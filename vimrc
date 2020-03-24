" get easier to use and more user friendly vim defaults
" CAUTION: This option breaks some vi compatibility.
"          Switch it off if you prefer real vi compatibility
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}
" WakaTime Plugin
Plugin 'wakatime/vim-wakatime'

" Búsqueda completa de archivos
" Ctrl-P (Buscar); Ctr-d (Incluir directorios); Ctrl-f (Buffers o archivos)
Plugin 'ctrlp.vim'

" Líneas verticales de indentado.
Plugin 'Yggdroot/indentLine'

Plugin 'SyntaxComplete'

" Autocompletar
Plugin 'valloric/youcompleteme'
Plugin 'marijnh/tern_for_vim'

" Explorador de archivos como un árbol.
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'

" JavaScript
Plugin 'pangloss/vim-javascript'

" Python
Plugin 'davidhalter/jedi-vim'

" HTML5, CSS
Plugin 'othree/html5.vim'
Plugin 'hail2u/vim-css3-syntax'

" Code Folding (Ocultar bloques de código)
Plugin 'tmhedberg/SimpylFold'

" Auto indentación.
Plugin 'vim-scripts/indentpython.vim'

" Comprobar sintaxis
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'

" Línea base de información.
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Indentar automáticamente dependiendo del tipo de archivo.
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Undo persistente. Crear manualmente el directorio ~/.vim/undodir/
set undofile
set undodir=~/.vim/undodir

set modifiable

" enable syntax highlighting
syntax on
let python_highlight_all=1
set t_Co=256

" automatically indent lines (default)
set autoindent

" select case-sensitive search
set noic

" show cursor line and column in the status line
set ruler

" show matching brackets
set showmatch

" display mode INSERT/REPLACE/...
set showmode

" Muestra los corchetes al que se empareja al escribir uno.
set showmatch
set matchtime=2
" Realiza scroll para mostrar el corchete emparejado.
" ESTÁ IGNORÁNDOLO Y NO SÉ POR QUÉ
"inoremap } }<Esc><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
"inoremap ] ]<Esc><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
"inoremap ) )<Esc><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a

" changes special characters in search patterns (default)
" set magic

" Required to be able to use keypad keys and map missed escape sequences
set esckeys

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Complete longest common string, then each full match
" enable this for bash compatible behaviour
set wildmode=longest,full

" Changed default required by SuSE security team--be aware if enabling this
" that it potentially can open for malicious users to do harmful things.
set nomodeline

" Skeleton for spec files
autocmd BufNewFile      *.spec  call SKEL_spec()

" get easier to use and more user friendly vim defaults
" /etc/vimrc ends here

" Cambiar espacios por tabulación
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=0
    \ set shiftwidth=4

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=0
    \ set shiftwidth=2

retab
set expandtab
set smarttab
set fileformat=unix

" Code folding (comando za para desplegar/plegar código agrupado).
set foldmethod=indent
set foldlevel=99

" Mantener cambios realizados en el búfer cuando se alterna a otro.
set hidden

" Grabar el archivo cuando se alterna a otro búfer o se ejecuta un comando de
" terminal.
set autowrite

" Visualizar los tabuladores y espacios al final de la línea con caracteres
" especiales
set list

" Activa búsqueda interactiva.
set incsearch

" Límite de 80 caracteres.
set textwidth=80
" Columna avisando del límite de caracteres. 81 general y 73 para commits
set colorcolumn=+1
" Límite de 72 caracteres para editar commits.
autocmd FileType gitcommit set textwidth=72
" Segunda columna avisando del límite de caracteres en commits.
autocmd FileType gitcommit set colorcolumn+=51
highlight ColorColumn ctermbg=7

" Manejar buffers
nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <S-b> :bnext<CR>

" Manejar pestañas
nnoremap <S-p> :tabn<CR>

" Manejar ventanas
nnoremap <S-w> <C-w>w
nnoremap - <C-W>-
nnoremap + <C-W>+
nnoremap / <C-W><
nnoremap * <C-W>>

" Eliminar todos los espacios finales.
cmap Alt-b g/[[:blank:]]*$/s//

" Guardar un archivo sin privilegios sudo.
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" cmap w!! w !sudo tee % >/dev/null

" Codificación UTF-8
set encoding=utf-8 fileencoding=utf8 termencoding=utf-8

" Mostrar los número de línea.
set number

" Cambiar colores del Plugin indentLine
" Vim
let g:indentLine_color_term = 239
"
" "GVim
let g:indentLine_color_gui = '#A4E57E'
"
" " none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
