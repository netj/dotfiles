if exists("did\_load\_filetypes")
 finish
endif

" markdown filetype file
augroup markdown
 au! BufRead,BufNewFile *.{mkd,markdown}   setfiletype mkd
 autocmd BufRead *.{mkd,markdown}          set ai formatoptions=tcroqn2 comments=n:&gt;
 autocmd BufRead,BufNewFile *.{mkd,markdown} map <C-K> ciW[ i=system('curl -s "pa" \| tr -d "\r\n" \| sed -n "s:.*<title>\\(.*\\)</title>.*:\\1:ip;T;q" \| { read -r t; echo -n "${t:-p}"; }')](P)lx
augroup END

" json
au! BufRead,BufNewFile *.json setfiletype json

" applescript
au! BufNewFile,BufRead *.{applescript,scpt} setfiletype applescript
