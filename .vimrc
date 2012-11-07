" netj's Vi IMproved configurations
" Author:  Jaeho Shin <netj@sparcs.org>
" Created: 2000-04-05
" 
" Based on the bundled vimrc_example.vim.
" 
" Derived many parts from
" Uwe Hermann <uwe@hermann-uwe.de>'s vimrc at 2005-11-20
"
" More settings for plugins can be found in .vim/addons.vim.

version 7.3

if v:progname =~? "evim" | finish | endif

set nocompatible        " This is Vi IMproved, not Vi :^)

" source optional files
fun! SourceOptional(files)
  for f in a:files | if filereadable(expand(f)) | exec 'source '.f | endif | endfor
endfun
command! -nargs=* SourceOptional :call SourceOptional([<f-args>])

" setup vim-addon-manager aka VAM
SourceOptional ~/.vim/addons.vim

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set autoindent		" always set autoindenting on
set copyindent		" indent even when copying
set preserveindent	" preserve whitespace for indentations
set nobackup		" don't keep backups
set history=1024	" keep so many lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set showmode		" display current mode
set title		" set xterm title
"set mouse=a		" use mouse
set clipboard=exclude:.*
set nowrap              " no line wrapping
set scrolloff=2
set modeline modelines=5

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
set suffixes+=#         " Emacs auto backups
set suffixes+=.hi       " Haskell intermediates
set suffixes+=.cmi,.cmo,.cmx,.cma,.cmxa,.blg,.annot " OCaml intermediates

" keep swap, undo in ~/.vim/tmp/
if isdirectory($HOME."/.vim/tmp") == 0
  silent !mkdir -p ~/.vim/tmp
endif
set directory=~/.vim/tmp//
set directory+=.
set undodir=~/.vim/tmp//
set undodir+=.


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
  set guifont=Envy_Code_R:h16,Consolas:h16,Menlo:h16,Monaco:h16
  set t_Co=256
  if has("gui_macvim")
    set transparency=5
  endif
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2
  syntax on
  set hlsearch
  highlight Search term=reverse ctermbg=3 ctermfg=1
endif

" Mac OS X (>=10.7) Terminal.app's Title Icon and Drag & Drop support
"  See: http://www.macosxautomation.com/lion/terminal.html
"  See: /private/etc/bashrc's update_terminal_cwd
if !has("gui_running") && $TERM_PROGRAM == "Apple_Terminal" && $TERM_PROGRAM_VERSION >= 297
  set title titlestring=%(%m\ %)%((%{expand(\"%:~:h\")})%)%a
  set icon iconstring=%{&t_IE}]7;file://%{hostname()}%{expand(\"%:p\")}%{&t_IS}
  set iconstring+=VIM
endif


"------------------------------------------------------------------------------
" Key bindings                                                                -
"------------------------------------------------------------------------------

" Don't use Ex mode, use Q for formatting
map Q gq

" quickly display mappings of <C-\>, <Space>, <Leader>
nnoremap <C-\><C-l>     :map <C-\><CR>
nnoremap <Space><C-l>   :map <S<BS>Space><CR>
nnoremap <Leader><C-l>  :map <L<BS>Leader><CR>


" Mode Toggler Keys
fun! ModeToggleKey(mode, lhs)
  exec 'nnoremap '.a:lhs.'      :set '.a:mode.'!<CR>:set '.a:mode.'?<CR>'
  exec 'inoremap '.a:lhs.' <C-o>:set '.a:mode.'!<CR>'
endfun
command! -nargs=+ -complete=option ModeToggleKey  :call ModeToggleKey(<f-args>)

" toggle display of unprintable characters
ModeToggleKey autoread        <C-\>&
ModeToggleKey autowrite       <C-\>!
ModeToggleKey autowriteall    <C-\>!!
ModeToggleKey binary          <C-\>@
ModeToggleKey cursorbind      <C-\>.
ModeToggleKey cursorline      <C-\>:
ModeToggleKey cursorcolumn    <C-\>,
ModeToggleKey diff            <C-\><C-d>
ModeToggleKey foldenable      <C-\><C-z>
ModeToggleKey list            <C-\><Space>
ModeToggleKey modifiable      <C-\><C-m>
ModeToggleKey number          <C-\>1
ModeToggleKey paste           <C-\><C-]>
ModeToggleKey readonly        <C-\><C-r>
ModeToggleKey ruler           <C-\>%
ModeToggleKey scrollbind      <C-\>+
ModeToggleKey spell           <C-\>=
ModeToggleKey swapfile        <C-\>$
ModeToggleKey undofile        <C-\><C-u>
ModeToggleKey winfixwidth     <C-\>\|
ModeToggleKey winfixheight    <C-\>_
ModeToggleKey wrap            <C-\><C-\>

" Fold
nnoremap <Space>z      :set foldmethod=indent<CR>
nnoremap <Space>Z      :set foldmethod=syntax<CR>
nnoremap <Space><C-z>  :set foldmethod=manual<CR>

" Fix syntax highlighting by doing it from start of file
" See: http://vim.wikia.com/wiki/Fix_syntax_highlighting
nnoremap <C-\>s      :syntax sync fromstart<CR>
inoremap <C-\>s <C-o>:syntax sync fromstart<CR>

" Toggle hlsearch (highlight search matches).
nnoremap <Space>* :nohlsearch<CR>

" Easy open and close of the QuickFix window
nnoremap <Space>q :copen<CR>
au! BufWinEnter *
      \ if &buftype == "quickfix" |
      \   nnoremap <buffer> <silent> q :close<CR>|
      \ endif
" XXX is above the best way to close with q? why don't BufAdd, BufNew work?

" Arrows for moving cursor based on displayed lines
nnoremap <Up>   gk
nnoremap <Down> gj

" Window resize for Mac (to be mapped to pinch in/out gestures)
if has("mac")
  nnoremap <D-≠>      16<C-w>>
  inoremap <D-≠> <C-o>16<C-w>>
  nnoremap <D-–>      16<C-w><
  inoremap <D-–> <C-o>16<C-w><
  nnoremap <D-±>      8<C-w>+
  inoremap <D-±> <C-o>8<C-w>+
  nnoremap <D-—>      8<C-w>-
  inoremap <D-—> <C-o>8<C-w>-
endif


"------------------------------------------------------------------------------
" Abbreviations                                                               -
"------------------------------------------------------------------------------

" My name + email address.
iab netj>    Jaeho Shin <netj@sparcs.org>
iab netj@cs> Jaeho Shin <netj@cs.stanford.edu>
iab jshin>   Jaeho.Shin@Stanford.EDU

" Frequently typed lines.
iab Created:    Created: <C-R>=system("date +%Y-%m-%d")

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
