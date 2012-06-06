if exists("did\_load\_filetypes") | finish | endif

" CoffeeScript autocompilation
"autocmd BufWritePost *.coffee silent CoffeeMake! | cwindow

" Scala (See: http://mdr.github.com/scalariform/)
au BufEnter *.scala setl formatprg=scalariform\ --forceOutput

" JSON
au! BufRead,BufNewFile *.json setfiletype json


" Vim-LaTeX
au! BufRead,BufNewFile *.tex
  \ set textwidth=76 |
  \ set suffixes+=.pdf,.dvi,.ps,.ps.gz,.aux,.bbl,.blg,.log,.out,.ent,.fdb_latexmk,.brf " TeX auxiliary logs
"  \ imap <M-j> <Plug>IMAP_JumpBack |


" Marked
au! FileType markdown map <F9> :!open -a Marked '%'<CR><CR>
