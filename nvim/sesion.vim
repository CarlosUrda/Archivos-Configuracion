let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/repos/Archivos-Configuracion/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +42 scripts.lua
badd +8 ajustes.lua
badd +9 ~/Desarrollo/Archivos-Configuracion/nvim/init.lua
badd +9 lazy/opts.lua
badd +3 lazy/plugins.lua
badd +1 lualine/opts.lua
badd +1 ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua
badd +1 ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/lazy.lua
badd +9 ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/init.lua
badd +4 ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/autoload.lua
badd +1 init_config.lua
badd +1 8
badd +12 init.lua
badd +1 ~/Desarrollo/Archivos-Configuracion/nvim/lua/config/lualine/opts.lua
badd +0 ~/Desarrollo/Archivos-Configuracion/nvim/lua/config/lazy/opts.lua
badd +0 lua/config/init.lua
argglobal
%argdel
$argadd 8
set stal=2
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit lua/config/init.lua
argglobal
balt init.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 299 - ((58 * winheight(0) + 49) / 99)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 299
normal! 045|
tabnext
edit ~/Desarrollo/Archivos-Configuracion/nvim/lua/config/lualine/opts.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 1resize ' . ((&columns * 60 + 99) / 199)
exe '2resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 2resize ' . ((&columns * 59 + 99) / 199)
argglobal
balt ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/init.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua", ":p")) | buffer ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua | else | edit ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua | endif
if &buftype ==# 'terminal'
  silent file ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua
endif
balt ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/autoload.lua
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
exe '1resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 1resize ' . ((&columns * 60 + 99) / 199)
exe '2resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 2resize ' . ((&columns * 59 + 99) / 199)
tabnext
edit ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/lazy.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 1resize ' . ((&columns * 46 + 99) / 199)
exe '2resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 2resize ' . ((&columns * 73 + 99) / 199)
argglobal
balt ~/Desarrollo/Archivos-Configuracion/nvim/init.lua
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/Desarrollo/Archivos-Configuracion/nvim/lua/config/lazy/opts.lua", ":p")) | buffer ~/Desarrollo/Archivos-Configuracion/nvim/lua/config/lazy/opts.lua | else | edit ~/Desarrollo/Archivos-Configuracion/nvim/lua/config/lazy/opts.lua | endif
if &buftype ==# 'terminal'
  silent file ~/Desarrollo/Archivos-Configuracion/nvim/lua/config/lazy/opts.lua
endif
balt ~/Desarrollo/Archivos-Configuracion/nvim/init.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
exe '1resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 1resize ' . ((&columns * 46 + 99) / 199)
exe '2resize ' . ((&lines * 27 + 51) / 102)
exe 'vert 2resize ' . ((&columns * 73 + 99) / 199)
tabnext 1
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
