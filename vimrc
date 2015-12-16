"***************************
" Vundle Gestor de Plugins
"****************************
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
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}
"Autocompletado
"Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Pathogen para manejar plugins y archivos en tiempo de ejecución
execute pathogen#infect()

" enable syntax highlighting
syntax on

" automatically indent lines (default)
set autoindent

" select case-insenitiv search (not default)
set ignorecase

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
inoremap } }<Left><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
inoremap ] ]<Left><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
inoremap ) )<Left><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a

" changes special characters in search patterns (default)
" set magic

" Required to be able to use keypad keys and map missed escape sequences
set esckeys

" get easier to use and more user friendly vim defaults
" CAUTION: This option breaks some vi compatibility. 
"          Switch it off if you prefer real vi compatibility
set nocompatible

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
set expandtab
set tabstop=4
retab
set shiftwidth=4

" Mantener los cambios realizados en un buffer cuando se alterna a otro
set hidden

" Línea que informa del límite de 80 caracteres.
set textwidth=80
set colorcolumn=+1
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

" Codificación UTF-8
set encoding=utf-8 fileencoding=utf8 termencoding=utf-8

" Mostrar los número de línea.
set number
