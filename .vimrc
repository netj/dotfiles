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

" Source a local configuration (if available) that's supposed to come before filetype plugin.
SourceOptional ~/.vim_local.before

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
if has("mouse")
  set mouse=a		" use mouse
endif
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
set wildmode=list:full
set wildchar=<Tab>
if has("&wildignorecase")
  set wildignorecase
endif

"  some by-product files
set suffixes-=.h
set suffixes+=.o,.d,.a  " object, dependencies, and archive files
set suffixes+=.class    " Java classes
set suffixes+=#         " Emacs auto backups
set suffixes+=.hi       " Haskell intermediates
set suffixes+=.cmi,.cmo,.cmx,.cma,.cmxa,.blg,.annot " OCaml intermediates
set suffixes+=DS_Store " macOS Finder remnants

" keep swap, undo in ~/.vim/tmp/
if isdirectory($HOME."/.vim/tmp") == 0
  silent !mkdir -p ~/.vim/tmp
endif
set directory=~/.vim/tmp//
set directory+=.
if exists("&undodir") " for vim < 7.3
  set undodir=~/.vim/tmp//
  set undodir+=.
endif

" use all spell files in ~/.vim/spell/
let &spellfile=substitute(glob("~/.vim/spell/*.utf-8.add"), "\n", ",", "g")
" and load them as dictionaries as well
let &dict=join(["spell"]+split(glob("~/.vim/spell/*.add"), "\n"), ",")

" let xterm title work even in screen or tmux
" From http://vim.wikia.com/wiki/Automatically_set_screen_title
if &term =~ "^screen.*"
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
  " Fonts for MacVim/GVim
  if !exists("g:guifonts")
    let g:guifonts = []
    call add(g:guifonts, ["Envy Code R"     , 16]) " favorite
    call add(g:guifonts, ["Anonymous Pro"   , 16]) " serif style fixed-width
    call add(g:guifonts, ["Inconsolata-dz"  , 14]) " good sharp dense
    call add(g:guifonts, ["Ubuntu Mono"     , 16]) " good bold but maybe too dense
    call add(g:guifonts, ["Consolas"        , 16]) " good
    call add(g:guifonts, ["Monaco"          , 14]) " okay but fat
    call add(g:guifonts, ["Menlo"           , 15]) " too fat
    "call add(g:guifonts, ["Inconsolata"     , 16]) " good sharp dense but silly fonts for quotes
    "call add(g:guifonts, ["Dejavu Sans Mono", 16]) " okay but too fat
    "call add(g:guifonts, ["Liberation Mono" , 16]) " so so too fat
    "call add(g:guifonts, ["Source Code Pro" , 15]) " okay but sparse
    "call add(g:guifonts, ["Droid Sans Mono" , 14]) " bad (0Oo) and a bit wide/fat
    "  adjusting font preference based on OS
    if has("gui_macvim")
      call insert(g:guifonts, ["Envy Code R", 16])
    elseif has("gui_win32")
      call insert(g:guifonts, ["Consolas"   , 16])
    else
      call insert(g:guifonts, ["Inconsolata-dz", 14])
      call insert(g:guifonts, ["Ubuntu Mono", 16])
    endif
    if has("gui_macvim") || has("gui_win32")
      let guifontfmt = 'v:val[0].":h".v:val[1]'
    else
      let guifontfmt = 'v:val[0]." ".v:val[1]'
    endif
    let &guifont = join(map(guifonts, guifontfmt), ",")
    " Colors
    set t_Co=256
    if has("gui_macvim")
      set transparency=5
    endif
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
if !has("gui_running") && &term !~ "^screen.*" && $TERM_PROGRAM == "Apple_Terminal" && $TERM_PROGRAM_VERSION >= 297
  set title titlestring=%(%m\ %)%((%{expand(\"%:~:h\")})%)%a
  set icon iconstring=%{&t_IE}]6;file://%{hostname()}%{expand(\"%:p\")}%{&t_IS}
  set iconstring+=VIM
endif


"------------------------------------------------------------------------------
" Key bindings                                                                -
"------------------------------------------------------------------------------

" Don't use Ex mode, use Q for formatting
map Q gq

" Esc key is becoming scarce, let's get used to a combo that'll never go away
inoremap kj <Esc>

" Shorthand for github.com/netj/remocon
if executable("remocon")
  nnoremap <Space>r  <C-\><C-N>:!remocon put<CR>
  nnoremap <Space>R  <C-\><C-N>:!remocon<CR>
endif

" Shorthand for duplicating current buffer contents in a new buffer
nnoremap <Space>%  <C-\><C-N>:%yank<CR><C-W>n:put<CR>i<C-G>u<C-\><C-N>:call <SID>setupBufferAsDisposable()<CR>
nnoremap <Space>#  <C-\><C-N><C-W>ni<C-R>=expand("#:p")<CR><C-G>u<C-\><C-N>:call <SID>setupBufferAsDisposable()<CR>
" Shorthand for capturing the output in a new buffer of current (executable) file or buffer content
" (when there's no filename, falls back to running current buffer content as shell script)
" TODO use <count> and <bang> with a command or function
nmap <Space>!   <C-\><C-N>:exec "norm 1".(empty(expand("%"))?"<Space>%":"<Space>#")."<Space>!%"<CR>
nmap <Space>!!  <C-\><C-N>:exec "norm 1".(empty(expand("%"))?"<Space>%":"<Space>#")."<Space>!%!"<CR>
nmap <Space>!!! <C-\><C-N>:exec "norm 1".(empty(expand("%"))?"<Space>%":"<Space>#")."<Space>!%!!"<CR>
" Shorthand for running current buffer content as shell script and replacing with the output captured
nnoremap <Space>!%   <C-\><C-N>:silent! %!bash -s 2>/dev/null<CR>:call <SID>setupBufferAsDisposable()<CR>
nnoremap <Space>!%!  <C-\><C-N>:silent! %!bash -s<CR>:call <SID>setupBufferAsDisposable()<CR>
nnoremap <Space>!%!! <C-\><C-N>:silent! %!(cat;echo 'exitStatus=$?')\|bash -sx<CR>:call <SID>setupBufferAsDisposable()<CR>
fun! s:setupBufferAsDisposable()
  set nomodified
  nnoremap <buffer> q :unmap <buffer> q<CR>:close<CR>
endfun

" quickly display mappings of <C-\>, <Space>, <Leader>
nnoremap <Space><C-l>   :map <S<BS>Space><CR>
nnoremap <Leader><C-l>  :map <L<BS>Leader><CR>


" Mode Toggler Keys
let s:modeToggleKeys = {}
fun! ModeToggleKey(...)
  let fmt = '%-20s <C-\>%s'
  if a:0 == 2
    let otn = a:1
    let lhs = a:2
    let s:modeToggleKeys[otn] = lhs
    for [prefix,cmd] in [['<C-\>','setlocal'], ['<C-\><C-G>', 'set']]
      exec 'nnoremap '.prefix.lhs.' :'.cmd.' '.otn.'!<CR>'
            \                     .':'.cmd.' '.otn.'?<CR>'
      exec 'imap     '.prefix.lhs.' <C-\><C-N>'.prefix.lhs.'gi'
      exec 'vmap     '.prefix.lhs.' <C-\><C-N>'.prefix.lhs.'gv'
    endfor
  elseif a:0 == 1
    echo printf(fmt, a:1, s:modeToggleKeys[a:1])
  else
    for otn in sort(keys(s:modeToggleKeys))
      echo printf(fmt, otn, s:modeToggleKeys[otn])
    endfor
  endif
endfun
command! -nargs=* -complete=option ModeToggleKey  :call ModeToggleKey(<f-args>)
nnoremap <C-\><C-l>     :ModeToggleKey<CR>

" toggle options with <C-\> followed by the individual key
ModeToggleKey autoread        <C-e>
ModeToggleKey autowrite       <C-w>
ModeToggleKey autowriteall    W
ModeToggleKey binary          @
ModeToggleKey cursorbind      .
ModeToggleKey cursorline      :
ModeToggleKey cursorcolumn    ,
ModeToggleKey diff            <C-d>
ModeToggleKey foldenable      <C-z>
ModeToggleKey hlsearch        *
ModeToggleKey list            <Space>
ModeToggleKey list            <C-Space>
ModeToggleKey list            <C-@>
ModeToggleKey modifiable      <C-m>
ModeToggleKey number          1
ModeToggleKey paste           <C-]>
ModeToggleKey readonly        <C-r>
ModeToggleKey ruler           %
ModeToggleKey scrollbind      +
ModeToggleKey spell           =
ModeToggleKey swapfile        $
ModeToggleKey undofile        <C-u>
ModeToggleKey winfixwidth     \|
ModeToggleKey winfixheight    _
ModeToggleKey wrap            <C-\>

" helper function to cycle thru options
fun! s:cycle(opt, values)
  exec "let oldValue = &". a:opt
  let idx = (index(a:values, oldValue) + 1) % len(a:values)
  let newValue = a:values[idx]
  exec "setlocal ". a:opt ."=". newValue
  exec "setlocal ". a:opt ."?"
endfun

" Fold method
nnoremap <Space>z      :call <SID>cycle("foldmethod", split("manual indent syntax"))<CR>

" Virtualedit
nnoremap <Space>v      :call <SID>cycle("virtualedit", insert(split("all block insert onemore"), ""))<CR>

" Fix syntax highlighting by doing it from start of file
" See: http://vim.wikia.com/wiki/Fix_syntax_highlighting
nnoremap <Space>s      :syntax sync fromstart<CR>

" Toggle hlsearch (highlight search matches).
nnoremap <Space>*      :nohlsearch<CR>

" Easy open and close of the QuickFix window
nnoremap <Space>q      :copen<CR>
nnoremap <Space>l      :lopen<CR>
au BufWinEnter *
      \ if index(["quickfix", "nofile"], &buftype) >= 0 |
      \   nnoremap <buffer> <silent> q :close<CR>|
      \ endif
" XXX is above the best way to close with q? why don't BufAdd, BufNew work?

" Arrows for moving cursor based on displayed lines
" (v:count idea from https://www.hillelwayne.com/post/intermediate-vim/)
nnoremap <expr> <Up>   (v:count == 0 ? 'gk' : '<Up>')
nnoremap <expr> <Down> (v:count == 0 ? 'gj' : '<Down>')
nnoremap <expr> <Home> (v:count == 0 ? 'g0' : '<Home>')
nnoremap <expr> <End>  (v:count == 0 ? 'g$' : '<End>')

" Opt/Alt+Left/Right similar to macOS's behavior
noremap <Esc><Left>  <C-\><C-N>b
noremap <Esc><Right> <C-\><C-N>w
if has("mac")
  noremap <M-Left>  <C-\><C-N>b
  noremap <M-Right> <C-\><C-N>w
endif

" Window resize for Mac (to be mapped to pinch in/out gestures)
if has("mac")
  nnoremap <M-C-D-+>        16<C-w>>
  inoremap <M-C-D-+>   <C-o>16<C-w>>
  nnoremap <M-C-D-->        16<C-w><
  inoremap <M-C-D-->   <C-o>16<C-w><
  nnoremap <C-D-+>           8<C-w>+
  inoremap <C-D-+>      <C-o>8<C-w>+
  nnoremap <C-D-->           8<C-w>-
  inoremap <C-D-->      <C-o>8<C-w>-
endif

" Enhance "goto file" (gf, <C-W>f, <C-W>gf) for nonexistent files
if !exists("*s:gotoFileOrEditNew")
  fun! s:gotoFileOrEditNew(keysGoto, cmdEditNew)
    try
      " XXX need double exec to support special key syntax, e.g., <C-W>
      exec 'exec "normal! '.escape(a:keysGoto,"<").'f"'
    catch /^Vim\%((\a\+)\)\=:E447/
      let fname = expand("<cfile>")
      if index(["/", "~"], fname[0]) == -1
        " resolve relative paths with current file's directory
        let fname = expand("%:h")."/".fname
      endif
      exec a:cmdEditNew." ".fnameescape(fname)
    endtry
  endfun
  nnoremap <silent>      gf :call <SID>gotoFileOrEditNew(        "g",    "edit")<CR>
  nnoremap <silent>  <C-W>f :call <SID>gotoFileOrEditNew( "<"."C-W>",   "split")<CR>
  nnoremap <silent> <C-W>gf :call <SID>gotoFileOrEditNew("<"."C-W>g", "tabedit")<CR>
endif

" Continue editing file:line in PyCharm/IntelliJ/JetBrains IDE
for cmd in ["pycharm", "charm", "idea"]
  if executable(cmd)
    map <Space>j  :silent exec(":!".cmd." ".expand("%").":".line("."))<CR>
    if has("mac")
      map <C-D-E> :silent exec(":!".cmd." ".expand("%").":".line("."))<CR>
    endif
    break
  endif
endfor

"------------------------------------------------------------------------------
" Abbreviations                                                               -
"------------------------------------------------------------------------------

" My name + email address.
iab netj>    Jaeho Shin <netj@sparcs.org>
iab netj@cs> Jaeho Shin <netj@cs.stanford.edu>
iab jshin>   Jaeho.Shin@Stanford.EDU

" Frequently typed lines.
iab Created:    Created: <C-R>=system("date +%Y-%m-%d")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Scripts/Plugins managed by Vundle                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
SourceOptional ~/.vim/bundle.vim


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

  " Play nice with crontab: "temp file must be edited in place"
  autocmd FileType crontab setlocal nobackup nowritebackup

  " Don't worry about typos and spelling errors in Git commit messages
  autocmd FileType gitcommit setlocal spell

endif " has("autocmd")

" use bash highlighting by default (see also: https://stackoverflow.com/questions/47563208/vim-bash-syntax-highlighting-with-modeline)
let g:is_bash = 1

" vimpager has problem with <Space> mappings
if exists("vimpager")
  set timeout timeoutlen=0
endif


" Use a split window for viewing man-pages
runtime ftplugin/man.vim
nnoremap K  :Man <C-R>=expand("<cword>")<CR><CR>
nnoremap gK K
au FileType man nnoremap <buffer> q <C-w>q


" Tmux like split direction (which feels very unintuitive for long-time Vim
" users, hence changing .tmux.conf is recommended for long time Vim users)
"set splitbelow splitright


" Selecting right after pasting text
" See: http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp 'p`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <expr> gP 'P`[' . strpart(getregtype(), 0, 1) . '`]'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local settings                                                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source a local configuration file if available.
SourceOptional ~/.vim_local


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings after loading addons
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Quickly explore directory with Netrw, positioning cursor to the last file
" See: http://youtu.be/MGmIJyTf8pg for source of inspiration (tpope)
" See: http://superuser.com/a/320514 for escaping
" Apply some minimal fixes to netrw unless tpope's vinegar plugin is already loaded
" See: https://github.com/tpope/vim-vinegar
if !exists("g:loaded_vinegar") && empty(filter(split(&rtp, ','), "v:val =~ 'vinegar'"))
  let g:netrw_banner = 0
  let g:netrw_sort_sequence = '*,\%(' . join(map(split(&suffixes, ','), 'escape(v:val, ".*$~")'), '\|') . '\)[*@]\=$'
  " mix dotfiles with regular ones when sorting
  au FileType netrw  let g:netrw_sort_options = 'i/['.g:netrw_sepchr.'._]\+/'
                  \| let g:netrw_list_hide = '^\.\.\=/\=$,^\.'
  let g:netrw_hide = 0
endif

" Adjust GVim's &guifont for GTK2
if has("gui_running") && has("gui_gtk2")
  let existing_font = "monospace"
  for font in split(&guifont, ",")
    let fontname = substitute(font, " \\+\\d\\+", "", "")
    if system("fc-list ".shellescape(fontname)." | wc -l") > 0
      let existing_font = font
      break
    endif
  endfor
  let &guifont = existing_font
endif

" Source a local configuration file at the very end if available.
SourceOptional ~/.vim_local.after

delcommand SourceOptional | delfunction SourceOptional

" vim:sw=2:sts=2:ts=8
