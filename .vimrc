set enc=utf8
au BufNewFile,BufRead *.m2,*.DEF,*.Mod,*.mod,*.MOD,*.md,*.mi setfiletype modula2
:set nolist
:set sw=2
:set tabstop=2
":set expandtab

set mouse-=a

" makes ascii art font
nmap <leader>F :.!toilet -w 200 -f pagga.tlf<CR>
nmap <leader>f :.!toilet -w 200 -f smbraille.tlf<CR>
" makes ascii border
nmap <leader>1 :.!toilet -w 200 -f term -F border<CR>
set clipboard^=unnamed,unnamedplus


"set ffs=mac,unix,dos
"set ffs=unix
set ffs=unix,dos,mac
set encoding=utf-8
set fileencoding=utf-8
set listchars=eol:¶
set list
