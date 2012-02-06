" netj's Vi IMproved configurations
" Author:  Jaeho Shin <netj@sparcs.org>
" Created: 2000-04-05
" 
" Based on the bundled vimrc_example.vim.
" 
" Derived many parts from
" Uwe Hermann <uwe@hermann-uwe.de>'s vimrc at 2005-11-20

version 7.0

if v:progname =~? "evim" | finish | endif

set nocompatible        " This is Vi IMproved, not Vi :^)

" source optional files
fun! SourceOptional(files)
    for f in a:files | if filereadable(expand(f)) | exec 'source '.f | endif | endfor
endfun
command! -nargs=* SourceOptional :call SourceOptional([<f-args>])

" setup vim-addon-manager aka VAM
SourceOptional ~/.vim/setup-vam.vim

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


" let xterm title work even in screen or tmux
" From http://vim.wikia.com/wiki/Automatically_set_screen_title
if &term == "screen"
  set t_ts=]0;
  set t_fs=
elseif &term == "xterm-color" || &term == "xterm-256color"
  set t_Co=256
endif

" Some GUI options
if has("gui_running")
  set guioptions-=m
  set guioptions-=r
  set guioptions-=L
  set guioptions-=b
  set guioptions-=t
  set guioptions-=T
  set guifont=Consolas:h16,Menlo:h16,Monaco:h16
  set t_Co=256
  set transparency=10
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2
  syntax on
  set hlsearch
  highlight Search term=reverse ctermbg=3 ctermfg=1
endif

if &t_Co >= 8
  " See for more available schemes in ColorSamplerPack: http://www.vi-improved.org/color_sampler_pack/
  " dark-lo: desertEx anotherdark darkZ inkpot jellybeans herald railscasts fruity dante wombat256 chocolateliquor clarity freya xoria256 twilight darkslategray darkblue2
  " dark-hi: candycode asu1dark jammy lettuce darkspectrum desert256 leo vibrantink vividchalk guardian torte darkbone
  " light-hi: eclipse nuvola fruit
  " light-lo: spring autumn autumn2 siena
  " fun: matrix borland golden camo
  try
    if &t_Co >= 256
      " scroll among my favorites with VimTip341
      let g:mySetColors = split('jellybeans inkpot desertEx darkZ chocolateliquor')
      colorscheme jellybeans
    else " &term == "screen"
      " e.g. screen's color support isn't so good
      let g:mySetColors = split('default chocolateliquor')
      colorscheme default
    endif
    " let g:mySetColors=split('desertEx anotherdark darkZ inkpot jellybeans herald railscasts fruity dante wombat256 chocolateliquor clarity freya xoria256 twilight darkslategray darkblue2  candycode asu1dark jammy lettuce darkspectrum desert256 leo vibrantink vividchalk guardian torte darkbone  eclipse nuvola fruit  spring autumn autumn2 siena  matrix borland golden camo')
  catch /.*/
  endtry
endif

" Mac OS X (>=10.7) Terminal.app's Title Icon and Drag & Drop support
"  See: http://www.macosxautomation.com/lion/terminal.html
"  See: /private/etc/bashrc's update_terminal_cwd
if $TERM_PROGRAM == "Apple_Terminal" && $TERM_PROGRAM_VERSION >= 297
  set title titlestring=%(%m\ %)%((%{expand(\"%:~:h\")})%)%a
  set icon iconstring=%{&t_IE}]7;file://%{hostname()}%{expand(\"%:p\")}%{&t_IS}
  set iconstring+=VIM
endif


"------------------------------------------------------------------------------
" Key bindings                                                                -
"------------------------------------------------------------------------------

" My name + email address.
iab netj>    Jaeho Shin <netj@sparcs.org>
iab netj@cs> Jaeho Shin <netj@cs.stanford.edu>
iab jshin>   Jaeho.Shin@Stanford.EDU

" Frequently typed lines.
iab Created:    Created: <C-R>=system("date +%Y-%m-%d")

" Toggle list (display unprintable characters).
nnoremap <F2> :set list!<CR>
inoremap <F2> <C-o>:set list!<CR>

" Toggle hlsearch (highlight search matches).
nmap <F3> :set hlsearch!<CR>

" Fix syntax highlighting by doing it from start of file
" See: http://vim.wikia.com/wiki/Fix_syntax_highlighting
noremap <F4> :syntax sync fromstart<CR>
inoremap <F4> <C-o>:syntax sync fromstart<CR>

" Toggle wrapping
noremap <F5> :set wrap!<CR>
inoremap <F5> <C-o>:set wrap!<CR>

" Toggle paste
nnoremap <F6> :set paste!<CR>
inoremap <F6> <C-o>:set paste!<CR>

" Spellcheck.
map <F7> :!aspell -x %<CR>:e!<CR><CR>

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

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

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
SourceOptional ~/.vim_local


delcommand SourceOptional | delfunction SourceOptional

" vim:sw=2:sts=2:ts=8
