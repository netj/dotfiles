if exists("did\_load\_filetypes") | finish | endif

" CoffeeScript autocompilation
"autocmd BufWritePost *.coffee silent CoffeeMake! | cwindow

" Scala (See: http://mdr.github.com/scalariform/)
au BufEnter *.scala setl formatprg=scalariform\ --forceOutput

" JSON
au! BufRead,BufNewFile *.json setfiletype json

" TeX
au! BufRead,BufNewFile *.tex
  \ map <F5> :!latexmk -pdf %<CR> |
  \ set textwidth=76

" Marked
au! FileType markdown map <F9> :!open -a Marked '%'<CR><CR>
