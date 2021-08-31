set enc=utf8
au BufNewFile,BufRead *.m2,*.DEF,*.Mod,*.mod,*.MOD,*.md,*.mi setf modula2
:set nolist
:set sw=2
:set tabstop=2
:set expandtab
set mouse-=a


" makes ascii art font
nmap <leader>F :.!toilet -w 200 -f pagga.tlf<CR>
nmap <leader>f :.!toilet -w 200 -f smbraille.tlf<CR>
" makes ascii border
nmap <leader>1 :.!toilet -w 200 -f term -F border<CR>
