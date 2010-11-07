" netj's Vi IMproved configurations
" Author:  Jaeho Shin <netj@sparcs.org>
" Created: 2000-04-05
" 
" Based on the bundled vimrc_example.vim.
" 
" Derived many parts from
" Uwe Hermann <uwe@hermann-uwe.de>'s vimrc at 2005-11-20

version 6.4

if v:progname =~? "evim" | finish | endif

set nocompatible        " This is Vi IMproved, not Vi :^)

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set autoindent		" always set autoindenting on
set nobackup		" don't keep backups
set history=128		" keep 128 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set showmode		" display current mode
set title		" set xterm title
"set mouse=a		" use mouse
set clipboard=exclude:.*
set nowrap              " no line wrapping
set scrolloff=2

" searching
set incsearch		" do incremental searching
set ignorecase          " ignore case when searching
set smartcase           " but be smart when I type uppercases

" encodings
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,korea

" tabs
set softtabstop=4
set tabstop=8
set shiftwidth=4
set expandtab
set listchars=tab:>.,eol:$

" expansions
set wildmode=full,list:full
set wildchar=<TAB>

"  some by-product files
set suffixes+=.o,.a     " object and archive files
set suffixes+=.class    " Java classes
set suffixes+=.aux,.bbl,.blg,.ent,.fdb_latexmk,.log,.out " TeX auxiliary logs
set suffixes+=#         " Emacs auto backups
set suffixes+=.hi       " Haskell intermediates
set suffixes+=.cmi,.cmo,.cmx,.cma,.cmxa,.blg,.annot " OCaml intermediates


" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  highlight Search term=reverse ctermbg=3 ctermfg=1
endif

" Some GUI options
if has("gui_running")
    colorscheme darkblue
    set guioptions+=T
    set guioptions-=m
    set guifont=Monaco:h16
endif


"------------------------------------------------------------------------------
" Key bindings                                                                -
"------------------------------------------------------------------------------

" My name + email address.
iab netj>    Jaeho Shin <netj@sparcs.org>
iab jshin>   Jaeho Shin <netj@ropas.snu.ac.kr>

" Frequently typed lines.
iab Created:    Created: <C-R>=system("date +%Y-%m-%d")

" Toggle list (display unprintable characters).
nnoremap <F2> :set list!<CR>

" Toggle hlsearch (highlight search matches).
nmap <F3> :set hlsearch!<CR>

" Spellcheck.
map <F7> :!ispell -x %<CR>:e!<CR><CR>

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
"vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" ROT13 decode/encode the selected text (visual mode).
" Alternative: 'unmap g' and then use 'g?'.
vmap <F2> :!tr A-Za-z N-ZA-Mn-za-m<CR>

" Print an empty <a> tag.
"map! ;h <a href=""></a><ESC>5hi

" Wrap an <a> tag around the URL under the cursor.
"map ;H lBi<a href="<ESC>Ea"></a><ESC>3hi


"------------------------------------------------------------------------------
" File-type specific settings.
"------------------------------------------------------------------------------
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  " For files like *.shtml or *.html.ko
  au! BufRead,BufNewFile *.{s,}html.*		set filetype=html

  au! BufRead,BufNewFile *.tex
    \ map <F5> :!paper %<CR> |
    \ set textwidth=76

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Mutt bindings
  autocmd BufRead */tmp/mutt* normal :g/^> -- $/,/^$/-1d<CR>:set nomodified

endif " has("autocmd")


" let netrw use &suffixes for better file listings
let g:netrw_sort_sequence = '[\/]$,*'
for sfx in split(&suffixes, ',')
    let g:netrw_sort_sequence .= ',' . substitute(sfx, "\\.", "\\\\\\0", "") . '$'
endfor


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local settings                                                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source a local configuration file if available.
if filereadable(expand("~/.vim_local"))
    source ~/.vim_local
endif
