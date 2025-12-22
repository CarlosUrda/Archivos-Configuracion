let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
set shortmess+=aoO
badd +42 scripts.lua
badd +8 ajustes.lua
badd +9 ~/Desarrollo/Archivos-Configuracion/nvim/init.lua
badd +9 lazy/opts.lua
badd +3 lazy/plugins.lua
badd +1 lualine/opts.lua
badd +13 ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua
badd +1 ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/lazy.lua
badd +9 ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/init.lua
badd +4 ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/autoload.lua
badd +1 init_config.lua
badd +1 8
argglobal
%argdel
$argadd 8
set stal=2
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit init_config.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd _ | wincmd |
split
1wincmd k
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
exe 'vert 1resize ' . ((&columns * 105 + 105) / 210)
exe '2resize ' . ((&lines * 46 + 28) / 56)
exe 'vert 2resize ' . ((&columns * 104 + 105) / 210)
exe '3resize ' . ((&lines * 6 + 28) / 56)
exe 'vert 3resize ' . ((&columns * 104 + 105) / 210)
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
let s:l = 63 - ((32 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 63
normal! 0
lcd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
wincmd w
argglobal
if bufexists(fnamemodify("~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua", ":p")) | buffer ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua | else | edit ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua | endif
if &buftype ==# 'terminal'
  silent file ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua
endif
balt ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/autoload.lua
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
let s:l = 1 - ((0 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 04|
lcd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
wincmd w
argglobal
if bufexists(fnamemodify("~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/lazy.lua", ":p")) | buffer ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/lazy.lua | else | edit ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/lazy.lua | endif
if &buftype ==# 'terminal'
  silent file ~/Desarrollo/Archivos-Configuracion/nvim/lua/bootstrap/lazy.lua
endif
balt ~/Desarrollo/Archivos-Configuracion/nvim/lua/plugins/lualine.lua
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
let s:l = 29 - ((5 * winheight(0) + 3) / 6)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 29
normal! 0
lcd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
wincmd w
exe 'vert 1resize ' . ((&columns * 105 + 105) / 210)
exe '2resize ' . ((&lines * 46 + 28) / 56)
exe 'vert 2resize ' . ((&columns * 104 + 105) / 210)
exe '3resize ' . ((&lines * 6 + 28) / 56)
exe 'vert 3resize ' . ((&columns * 104 + 105) / 210)
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
exe 'vert 1resize ' . ((&columns * 105 + 105) / 210)
exe 'vert 2resize ' . ((&columns * 104 + 105) / 210)
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
let s:l = 9 - ((8 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 9
normal! 09|
lcd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
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
let s:l = 11 - ((10 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 11
normal! 0
lcd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
wincmd w
exe 'vert 1resize ' . ((&columns * 105 + 105) / 210)
exe 'vert 2resize ' . ((&columns * 104 + 105) / 210)
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
exe 'vert 1resize ' . ((&columns * 81 + 105) / 210)
exe 'vert 2resize ' . ((&columns * 128 + 105) / 210)
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
let s:l = 29 - ((28 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 29
normal! 043|
lcd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
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
let s:l = 8 - ((7 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 8
normal! 0
lcd ~/Desarrollo/Archivos-Configuracion/nvim/lua/config
wincmd w
exe 'vert 1resize ' . ((&columns * 81 + 105) / 210)
exe 'vert 2resize ' . ((&columns * 128 + 105) / 210)
tabnext 3
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
