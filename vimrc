
" Indentar automáticamente dependiendo del tipo de archivo.
filetype plugin indent on

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
" ESTÁ IGNORÁNDOLO Y NO SÉ POR QUÉ
"inoremap } }<Esc><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
"inoremap ] ]<Esc><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
"inoremap ) )<Esc><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a

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
