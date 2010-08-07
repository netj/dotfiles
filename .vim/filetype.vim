if exists("did\_load\_filetypes")
 finish
endif

" markdown filetype file
augroup markdown
 au! BufRead,BufNewFile *.{mkd,markdown}   setfiletype mkd
 autocmd BufRead *.{mkd,markdown}          set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END
