" netj's Vim plugins
version 7.3
if exists("s:LoadedBundles") | finish | endif
try

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !isdirectory($HOME.'/.vim/bundle/Vundle.vim/autoload')
  if executable("git")
    let s:self = expand("<sfile>")
    fun! s:BootstrapVundle()
      exec 'silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'
      delcommand PluginInstall
      exec 'source '.s:self
      PluginInstall
    endfun
    command! -nargs=* -bang PluginInstall call s:BootstrapVundle()
  endif
  finish
endif

fun! s:setLocalOptionsForWriting()
  setlocal spell autowrite textwidth=0 formatoptions-=t formatoptions-=c
  if has("linebreak")
    setlocal wrap linebreak showbreak=...\  cpoptions+=n
    " See: http://stackoverflow.com/questions/5706820/using-vim-isnt-there-a-more-efficient-way-to-format-latex-paragraphs-according
    if has("gui") | let &l:showbreak="\u21aa   " | endif " use a better unicode character:↪
    " Move cursor based on displayed lines
    for key in split("j k 0 $")
      exec 'noremap <buffer>  '.key.' g'.key
      exec 'noremap <buffer> g'.key.'  '.key
    endfor
  endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" More info about Vim plugins
" See Also: http://www.catonmat.net/series/vim-plugins-you-should-know-about
" See Also: http://www.drchip.org/astronaut/vim/
" See Also: http://pinboard.in/u:netj/t:vim/t:tweaks

""" Look and Feels
" See Also: http://www.quora.com/Which-are-the-best-vim-plugins
" See Also: http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" See for more available schemes in ColorSamplerPack: http://www.vi-improved.org/color_sampler_pack/
" dark-lo: desertEx inkpot anotherdark jellybeans herald railscasts dante wombat256 ChocolateLiquor clarity freya xoria256 twilight darkslategray darkblue2
" dark-hi: fruity candycode asu1dark jammy lettuce vibrantink vividchalk guardian torte darkZ
" light-hi: summerfruit256 eclipse nuvola fruit
" light-lo: spring autumn sienna
" fun: matrix borland golden camo
" bright: summerfruit256 buttercream PapayaWhip nuvola habiLight fruit eclipse earendel
Plugin 'w0ng/vim-hybrid'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'Colour-Sampler-Pack'
  let g:jellybeans_overrides = {
        \    'Todo': { 'guifg': '101010', 'guibg': 'fad07a',
        \              'ctermfg': 'Black', 'ctermbg': 'Yellow',
        \              'attr': 'bold' },
        \}
" scroll among my favorites with VimTip341
Plugin 'https://gist.github.com/1432015.git'
  let s:mySetColorsSet = []
  fun! s:addColorSet(reversed, name, ...)
    let colors = a:000 | if a:reversed | let colors = reverse(copy(colors)) | endif
    let s:mySetColorsSet += [colors]
  endfun
  command! -nargs=+ -bar -bang AddColorSet  call s:addColorSet(<bang>0, <f-args>)
  if has("gui_running")
    AddColorSet  'darkLo'     hybrid         desertEx    lucius       camo      dante      candy           " jellybeans brookstream
    AddColorSet  'creativity' spring         clarity     navajo-night sea       oceandeep  breeze          " dusk       tabula      darkblue2
    AddColorSet  'darkHi'     fruity         oceanblack  jammy        northland lettuce    molokai         " neon       vibrantink  vividchalk colorer  torte
    AddColorSet  'bright'     summerfruit256 buttercream PapayaWhip   nuvola    habiLight  fruit           " eclipse    earendel
    AddColorSet! 'precision'  autumn         railscasts  Guardian     candycode inkpot     ChocolateLiquor
  else
    if &t_Co >= 256
      " many color schemes only work well on GUI
      AddColorSet 'lo'     hybrid         wombat256       lettuce    dante
      AddColorSet 'hi'     jellybeans     inkpot          molokai    navajo-night
      AddColorSet 'bright' summerfruit256 lucius          tabula
      " desertEx colorer vividchalk candycode nuvola earendel
    else
      AddColorSet 'fallback' default
    endif
  endif

Plugin 'bling/vim-airline'
  let g:airline#extensions#whitespace#enabled = 0
  set laststatus=2 noshowmode showcmd
if has("gui_running")
  let g:airline_powerline_fonts = 1
  fun! s:fontname(nameSize)
    return substitute(a:nameSize, "\\(:h\\|  *\\)[0-9]\\+$", "", "i")
  endfun
  let guifonts = reverse(map(split(&guifont,","), '[s:fontname(v:val), v:val[len(s:fontname(v:val)):]]'))
  let suffixes = reverse([
        \  " for Powerline",
        \  " Powerline",
        \  " derivative Powerline",
        \])
  for [name,size] in guifonts
    for suffix in suffixes
      let &guifont = name.suffix.size .",". &guifont
    endfor
  endfor
  " using colorscheme from localvimrc can screw up powerline, hence below:
  autocmd VimEnter * doautoall airline BufEnter,ColorScheme

  if has("gui_gtk2")
    " quick font resize for GVim
    Plugin 'fontsize'
      nmap <silent> <M-=> <Leader><Leader>+
      nmap <silent> <M--> <Leader><Leader>-
  endif
endif


""" Productivity boosters
if has("python")
Plugin 'Gundo'
  let g:gundo_close_on_revert = 1
  nnoremap <Space>u :GundoToggle<CR>
endif
Plugin 'bufexplorer.zip'
  nnoremap <Space>b :BufExplorerHorizontalSplit<CR>
"Plugin 'tselectbuffer'
"  nnoremap <Space>b :TSelectBuffer<CR>
Plugin 'majutsushi/tagbar'
  nnoremap <Space>t :TagbarOpenAutoClose<CR>
  nnoremap <Space>T :TagbarToggle<CR>
  " See also: https://ctags.io or brew install --HEAD universal-ctags/universal-ctags/universal-ctags
Plugin 'ack.vim'
fun! s:jumpToTagWithQuickFix(w)
  exec "ltag" a:w
  keepjumps call setqflist(getloclist(0))
  " TODO copen | let w:quickfix_title = ":tag ". a:w | close
  let @/ = "\\<". a:w ."\\>" | keepjumps norm n
  set hlsearch
endfun
fun! s:ackWord(w)
  exec "keepjumps Ack!" "'\\b". a:w ."\\b'"
  let @/ = "\\<". a:w ."\\>" | keepjumps norm n
  set hlsearch
  cfirst
endfun
if has("gui") || has("mouse")
  " Ctrl-Click in MacVim needs: defaults write org.vim.MacVim MMTranslateCtrlClick 0
  " See: http://stackoverflow.com/a/10148278/390044
  noremap <C-LeftMouse>  <C-\><C-N><LeftMouse>:call <SID>jumpToTagWithQuickFix(expand("<cword>"))<CR>
  noremap <C-RightMouse> <C-\><C-N><LeftMouse>:call <SID>ackWord(expand("<cword>"))<CR>
endif
" unimpaired quickfix access with [q, ]q, [Q, ]Q
Plugin 'tpope/vim-unimpaired'
  " Eclipse-style movement
  nmap <M-Up>   V<M-Up>
  nmap <M-Down> V<M-Down>
  vmap <M-Up>   [egv
  vmap <M-Down> ]egv
  imap <M-Up>   <C-\><C-N>[egi
  imap <M-Down> <C-\><C-N>]egi
  if has("mac")
    let g:macvim_skip_cmd_opt_movement = 1 " http://superuser.com/questions/310364/switch-buffers-in-macvim
  endif

" exchange.vim for cx, cxx, cxc, v_X. See: http://vimcasts.org/episodes/swapping-two-regions-of-text-with-exchange-vim/
Plugin 'tommcdo/vim-exchange'

  " Align%294's \m= collides with Mark%2666 unless already mapped
  map <Leader>tm= <Plug>AM_m=
Plugin 'Align'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
"Plugin 'tpope/vim-speeddating' " FIXME doesn't work with 7.4-1589
Plugin 'tpope/vim-commentary'
Plugin 'bronson/vim-visual-star-search'
Plugin 'Lokaltog/vim-easymotion'
  let g:EasyMotion_leader_key = '<Space>w'
Plugin 'matchit.zip'
Plugin 'closeb'  " CTRL-_ to close complex brackets/tags
Plugin 'kien/rainbow_parentheses.vim'
  fun! RainbowParenthesesLoadAndToggleAll()
    exec 'RainbowParenthesesLoadRound'
    exec 'RainbowParenthesesLoadSquare'
    exec 'RainbowParenthesesLoadBraces'
    exec 'RainbowParenthesesLoadChevrons'
    exec 'RainbowParenthesesToggleAll'
  endfun
  nnoremap <C-\>0      :call RainbowParenthesesLoadAndToggleAll()<CR>
  inoremap <C-\>0 <C-o>:call RainbowParenthesesLoadAndToggleAll()<CR>

" Plugin 'RltvNmbr'
Plugin 'DrawIt'
" Plugin 'MixCase'
Plugin 'junegunn/vim-emoji'

Plugin 'Mark'
  let g:mwHistAdd       = '' " '/@'
  let g:mwAutoLoadMarks = 1
  let g:mwAutoSaveMarks = 1
  set viminfo+=!  " Save and restore global variables. 
  nmap <Space>m <Leader>m
  xmap <Space>m <Leader>m
  nmap <Space>M <Leader>n
  xmap <Space>M <Leader>n
  nmap <Space>n <Leader>*
  nmap <Space>N <Leader>/

""" CamelCase stuff
" Shougo's NeoComplCache is really nice!
if $USER != "root"
Plugin 'Shougo/neocomplcache'
Plugin 'Shougo/vimproc'
  let g:acp_enableAtStartup = 0
  " XXX Rather than enabling at startup, I use special key combo Cmd-Shift-D to turn it on
  "let g:neocomplcache_enable_at_startup = 1
  noremap <Space><C-n> :NeoComplCacheEnable<CR>
  "let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_enable_underbar_completion = 1
  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
endif
" CamelCaseComplete is less convenient (CTRL-X CTRL-C), yet lightweight
Plugin 'CamelCaseComplete' 
Plugin 'CompleteHelper'
Plugin 'camelcasemotion'
  " recover default ,
  nnoremap ,, ,
  xnoremap ,, ,
  onoremap ,, ,
Plugin 'tpope/vim-abolish'

"Plugin 'slime'
Plugin 'scrooloose/nerdtree'
  nnoremap <Space>e :NERDTreeFind<CR>
  nnoremap <Space>E :let g:NERDTreeQuitOnOpen=!g:NERDTreeQuitOnOpen<CR>:NERDTreeFind<CR>
  let g:NERDTreeQuitOnOpen = 1
  let g:NERDTreeShowHidden = 1
  let g:NERDTreeChDirMode  = 1
  " take &suffixes option into account
  let s:suffixesAsRegexes = map(split(&suffixes, ','), 'escape(v:val, '."'".'\\/.*$^~[]'."'".') . "$"')
  let g:NERDTreeSortOrder = ['*'] + s:suffixesAsRegexes + ['\.swp$', '\.bak$', '\~$']
  let g:NERDTreeIgnore = ['^.*\.sw[p-z]$', '^\..*\.un\~'] " ignore vim swap and undo files
  let g:NERDTreeCaseSensitiveSort = 0
  let g:NERDTreeSortHiddenFirst = 0
  " easier preview key mapping
  autocmd BufEnter NERD_tree_* map <buffer> <Space><Space> go
  autocmd BufEnter NERD_tree_* map <buffer> <Space>s       gi
  autocmd BufEnter NERD_tree_* map <buffer> <Space>v       gv
" tpope doesn't like complex/heavy NERD_tree, but recommends netrw
" Moreover, see what Drew Neil says about project drawer vs. explorer
" See: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
  let g:netrw_sort_dirs_first = 0
  let g:netrw_sort_dotfiles_first = 0
  let g:netrw_sort_case_sensitive = 0
  let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+' " all dotfiles
  let g:netrw_hide = 0
Plugin 'netj/vim-vinegar'  " XXX using personal fork of 'tpope/vim-vinegar'
  let g:NERDTreeHijackNetrw = 0
"Plugin 'FuzzyFinder'
"  nnoremap <Space>f :FufFileWithCurrentBufferDir<CR>
"Plugin 'Command-T'
"  nnoremap <Space>f :CommandT<CR>
Plugin 'kien/ctrlp.vim'
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlPMixed'
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_custom_ignore = {
        \ "dir": '\v[\/]\@prefix\@$'
        \ }
Plugin 'qpkorr/vim-renamer'
Plugin 'chrisbra/Recover.vim'
"Plugin 'snipmate'
"Plugin 'vmark.vim_Visual_Bookmarking' " XXX beware: <F2>/<F3> is overrided
" TODO let b:vm_guibg = yellow
"if has("ruby")
"  Plugin 'tips'
"end
Plugin 'tpope/vim-eunuch' " for :Move, :SudoWrite, etc.

" Vim and Tmux even better together: https://blog.bugsnag.com/tmux-and-vim/
if exists("$TMUX")  " activate only in a tmux session
  Plugin 'christoomey/vim-tmux-navigator'
  let g:tmux_navigator_no_mappings = 1
  " quicker move between windows with Ctrl+Alt+h/j/k/l and backslash
  nnoremap <silent> <Esc><C-h> :TmuxNavigateLeft<CR>
  nnoremap <silent> <Esc><C-j> :TmuxNavigateDown<CR>
  nnoremap <silent> <Esc><C-k> :TmuxNavigateUp<CR>
  nnoremap <silent> <Esc><C-l> :TmuxNavigateRight<CR>
  nnoremap <silent> <Esc><C-\> :TmuxNavigatePrevious<CR>
  " quicker splits
  nnoremap <silent> <Esc><C-v> <C-w>v
  nnoremap <silent> <Esc><C-s> <C-w>s
  " NOTE MacVim settings are not easy with Ctrl+Alt+keys, so relying on BetterTouchTool
  " (neither do <C-M-*> nor <C-D-*> works)

  Plugin 'benmills/vimux'
  noremap <silent> <Esc><C-]>    :wall\|VimuxPromptCommand<CR>
  noremap <silent> <Esc><Return> :wall\|VimuxRunLastCommand<CR>
  noremap <silent> <Esc><C-x>    :VimuxInspectRunner<CR>
  " vimux zooming tmux pane and returning, a la suspending Vim w/ Ctrl-Z
  noremap <silent> <Esc><C-z>    :VimuxZoomRunner<CR>

  " ignore the prefix sent by Tmux for uniform behavior across INSERT-NORMAL modes
  nnoremap <silent> <C-\><C-o>   <C-g>
endif

""" Git, Github
Plugin 'tpope/vim-fugitive'
  if exists("*fugitive#buffer")
    " tips from vimcasts.org
    autocmd User fugitive
      \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
      \   nnoremap <buffer> .. :edit %:h<CR> |
      \ endif
    autocmd BufReadPost fugitive://* set bufhidden=delete
    set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
  endif
  " some shorthands
  nnoremap <Space>gg :Gstatus<CR>
  nnoremap <Space>gd :Gdiff<CR>
  nnoremap <Space>gD :Gdiff HEAD<CR>
  nnoremap <Space>gb :Gblame<CR>
  nnoremap <Space>gl :Glog<CR>:copen<CR>
  nnoremap <Space>gL :Glog --<CR>
  nnoremap <Space>ge :Gedit<CR>
  nnoremap <Space>gE :Gedit 
Plugin 'tpope/vim-rhubarb'
Plugin 'gregsexton/gitv'
  nnoremap <Space>gv :Gitv --all<CR>
  nnoremap <Space>gV :Gitv! --all<CR>
  vnoremap <Space>gV :Gitv! --all<CR>
  set lazyredraw
Plugin 'airblade/vim-gitgutter.git'
  let g:gitgutter_enabled = 1
  nnoremap <Space><C-g><C-g> :GitGutterToggle<CR>
  nnoremap <Space><C-g>g     :GitGutterLineHighlightsToggle<CR>
  nnoremap ]g :GitGutterNextHunk<CR>
  nnoremap [g :GitGutterPrevHunk<CR>
  nnoremap <Space>gh :GitGutterPreviewHunk<CR>
  nnoremap [G :GitGutterStageHunk<CR>
  nnoremap ]G :GitGutterUndoHunk<CR>
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
  let g:gist_clip_command = 'pbcopy'
  let g:gist_open_browser_after_post = 1
  let g:gist_get_multiplefile = 1
  nnoremap <Space>GL :Gist -l<CR>
  nnoremap <Space>GA :Gist -la<CR>
  nnoremap <Space>GS :Gist -ls<CR>


""" Some file types
Plugin 'tpope/vim-endwise'
let g:sparkup = {}
  let g:sparkup.lhs_expand = '<C-\><C-e>'
  let g:sparkup.lhs_jump_next_empty_tag = '<C-\><C-f>'
Plugin 'chrisgeo/sparkup', {'rtp': 'vim/'}
Plugin 'xmledit'
  let g:xml_jump_string = "`"
Plugin 'tpope/vim-ragtag'

Plugin 'tpope/vim-markdown' " Markdown vim-ft-markdown_fold
  " Marked
  au FileType markdown
    \ call s:setLocalOptionsForWriting() |
    \ let &l:formatprg = '~/.vim/format-latex.pl' | " abuse LaTeX formatter on Markdown
    \ setlocal formatoptions+=n |
  if has("mac")
    au FileType markdown
      \ nnoremap <D-e> :exec "!open -a \"Marked 2\" ".shellescape(expand("%"))<CR><CR>|
      \ noremap! <D-e> <C-\><C-N><D-e>gi|
      \ call sparkup#Setup()|
  endif
Plugin 'elzr/vim-json'
  au BufEnter *.json setfiletype json
Plugin 'vito-c/jq.vim'  " jq query language for JSON
Plugin 'tpope/vim-jdaddy' " for aj and ij text objects
Plugin 'GEverding/vim-hocon'  " for HOCON (Human Optimized Configuration Object Notation)

" C/C++ development essentials
if has("python")
Plugin 'Valloric/YouCompleteMe'
" See: https://github.com/Valloric/YouCompleteMe#options
" only activate YCM on a select filetypes (defaults to '*')
let g:ycm_filetype_whitelist = {
      \ 'cpp': 1,
      \}
Plugin 'rdnetto/YCM-Generator'
endif
if executable("clang-format")
  Plugin 'kana/vim-operator-user' " vim-operator-user
  Plugin 'rhysd/vim-clang-format' " vim-clang-format
  let g:clang_format#code_style = "google"
  au FileType c,cpp,objc,objcpp
        \| nmap <Space><C-K> :ClangFormatAutoToggle<CR>
        \| map <C-K> <Plug>(operator-clang-format)
endif
Plugin 'msanders/cocoa.vim' 
Plugin 'b4winckler/vim-objc'
Plugin 'leafgarland/typescript-vim'
Plugin 'ianks/vim-tsx'
Plugin 'Shougo/vimproc.vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'kchmck/vim-coffee-script'
  au BufEnter *.coffee syntax sync fromstart
  " Search for CoffeeScript/JavaScript files, e.g., require "foo"
  au BufRead,BufNewFile *.coffee setl suffixesadd+=.coffee,.js
  " CoffeeScript autocompilation
  "autocmd BufWritePost *.coffee silent CoffeeMake! | cwindow
if has("ruby")
  Plugin 'lukaszkorecki/CoffeeTags'
endif
Plugin 'jade.vim'
Plugin 'kana/vim-altr'
  nmap <Space><Tab>    <Plug>(altr-forward)
  nmap <Space><S-Tab>  <Plug>(altr-backward)
Plugin 'tpope/vim-classpath'
Plugin 'applescript.vim'
  au BufEnter *.applescript setfiletype applescript
Plugin 'vim-scala'
"Plugin 'MarcWeber/vim-addon-scala'
  " Scala (See: http://mdr.github.com/scalariform/)
  "au BufEnter *.scala setl formatprg=scalariform\ --forceOutput
Plugin 'octave.vim--'
  au BufEnter *.oct setlocal filetype=octave  " XXX *.m could be an Objective-C file
Plugin 'SQLUtilities'
  let g:sqlutil_keyword_case='\U'
  let g:sqlutil_align_where=1
  let g:sqlutil_align_comma=0
" Python
Plugin 'nvie/vim-flake8'
Plugin 'tell-k/vim-autopep8'

" Vim-LaTeX is a comprehensive plugin for working with LaTeX
" See: http://vim-latex.sourceforge.net/documentation/latex-suite/
Plugin 'vim-latex/vim-latex'
  let g:Tex_IgnoreLevel = 0
  let g:Tex_IgnoreUnmatched = 0
  let g:Tex_Folding = 1
  let g:Tex_AutoFolding = 0
  fun! s:LaTeX_Build()
    norm m`m[
    let oldmore=&more | set nomore
    exec "silent make! ".escape(Tex_GetMainFileName(),' \')
    let &more=oldmore
    norm m]g``
  endfun
  fun! s:LaTeX_View()
    set filetype=tex
    call Tex_ForwardSearchLaTeX()
  endfun
  fun! s:LaTeX_BuildAndView()
    call s:LaTeX_Build()
    call s:LaTeX_View()
  endfun
  command! LaTeXView         call s:LaTeX_View()
  command! LaTeXBuild        call s:LaTeX_Build()
  command! LaTeXBuildAndView call s:LaTeX_BuildAndView()
  fun! s:LaTeX_Setup()
    let suffixes = ".pdf,.dvi,.ps,.ps.gz"
                \.",.aux,.bbl,.blg,.log,.out,.ent"
                \.",.toc,.lot,.lof"
                \.",.latexmain,.fdb_latexmk,.fls,.brf,.synctex.gz"
    if stridx(&suffixes, suffixes) == -1
      exec "setlocal suffixes+=".suffixes
      let patt = '\('. join(map(split(suffixes,','),
            \                   '"\\".v:val'), '\|') .'\)$'
      let g:NERDTreeSortOrder += [patt]
    endif
    " better LaTeX formatting, perhaps with a custom formatprg
    call s:setLocalOptionsForWriting()
    "   See: http://stackoverflow.com/questions/5706820/using-vim-isnt-there-a-more-efficient-way-to-format-latex-paragraphs-according
    "   See: http://stackoverflow.com/questions/1451827/vim-make-gq-treat-as-the-end-of-a-sentence
    let &l:formatprg = '~/.vim/format-latex.pl'
    "   See: http://denihow.com/vim-gq-command-to-re-wrap-paragraph-and-latex/
    "   See: http://superuser.com/questions/422214/vim-gq-command-to-re-wrap-paragraph-and-latex
    let &l:formatlistpat = '^\s*\\\ze\(end\|item\)\>'
    setlocal formatoptions+=n
    setlocal wrap
    " Use LaTeX folds
    nmap <buffer><silent> <Space>z  <Plug>Tex_RefreshFolds
    " Use latexmk and enable synctex
    for fmt in split("pdf ps dvi")
      let g:Tex_CompileRule_{fmt}="~/.vim/latexmk.sh ".fmt." $*"
    endfor
    if has("mac")
      " Use Skim as our PDF viewer and latexmk to compile
      if exists(":TCTarget")
        TCTarget pdf
      endif
      let g:Tex_ViewRule_pdf="Skim"
      " In Skim's preferences, use the following for Custom PDF-TeX Sync support
      " Command: /Users/YOURUSERNAME/.vim/synctex.skim-macvim.sh
      " Arguments: "%file" %line /path/to/mvim/command
      " Command must be a full path name to mvim unless you put it in a system location such as /usr/bin.
      " Arguments has a fancy applescript to open on the active MacVim window.
      " some key bindings with Command-key
      map  <buffer><silent> <D-e> <Plug>Tex_FastEnvironmentInsert
      map! <buffer><silent> <D-e> <Plug>Tex_FastEnvironmentInsert
      map  <buffer><silent> <D-E> <Plug>Tex_FastEnvironmentChange
      map! <buffer><silent> <D-E> <Plug>Tex_FastEnvironmentChange
      map  <buffer><silent> <D-r> <Plug>Tex_FastCommandInsert
      map! <buffer><silent> <D-r> <Plug>Tex_FastCommandInsert
      map  <buffer><silent> <D-R> <Plug>Tex_FastCommandChange
      map! <buffer><silent> <D-R> <Plug>Tex_FastCommandChange
      map! <buffer><silent>  <Plug>Tex_Completion
      map  <buffer><silent> <D-j> <Plug>IMAP_JumpForward
      map  <buffer><silent> <D-k> <Plug>IMAP_JumpBack
      map! <buffer><silent> <D-j> <Plug>IMAP_JumpForward
      map! <buffer><silent> <D-k> <Plug>IMAP_JumpBack
      " and ones for quick compile/view/sync with latexmk
      let keyMappings = {}
      let keyMappings[  '<C-D-CR>'] = 'LaTeXBuild'
      let keyMappings[  '<S-D-CR>'] = 'LaTeXView'
      let keyMappings['<C-S-D-CR>'] = 'LaTeXBuildAndView'
      for [key,cmd] in items(keyMappings)
        exec 'nnoremap <buffer> '.key.'           :'.cmd.'<CR>:cwindow<CR>'
        exec 'xnoremap <buffer> '.key.' <C-\><C-N>:'.cmd.'<CR><CR>gv'
        exec 'snoremap <buffer> '.key.' <C-\><C-N>:'.cmd.'<CR><CR>gv<C-G>'
        exec 'inoremap <buffer> '.key.' <C-\><C-N>:'.cmd.'<CR><CR>gi'
      endfor
    endif
  endfun
  au FileType tex call s:LaTeX_Setup()
" Automatic LaTeX Plugin for Vim and LaTeX_Box is also nice supporting
" latexmk directly, vim-like motions, mappings, etc.  but I find it a little
" premature yet (e.g., ShowErrors didn't work for me)
" See: http://atp-vim.sourceforge.net
"Plugin 'AutomaticLaTeXPlugin'
"Plugin 'LaTeX_Box'

Plugin 'embear/vim-localvimrc'
"Plugin 'MarcWeber/vim-addon-local-vimrc'
  let g:localvimrc_name = [ ".lvimrc", ".vimrc" ]
  let g:localvimrc_persistent = 1
  let g:localvimrc_sandbox = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" XXX probably not a good idea as it sometimes crashes tmux and macOS Terminal.app
"" git-gutter with vim-emojis
"try
"  if emoji#available()
"    let g:gitgutter_sign_added = emoji#for('bulb')
"    let g:gitgutter_sign_modified = emoji#for('boom')
"    let g:gitgutter_sign_removed = emoji#for('fire')
"    let g:gitgutter_sign_modified_removed = emoji#for('collision')
"  endif
"catch /.*/
"  " silence any error
"endtry

fun! s:stripeLists(lists)
  let stripedList = []
  let added = 1
  let i = 0
  while added
    let added = 0
    for singleList in a:lists
      if i < len(singleList)
        call add(stripedList, singleList[i])
        let added = 1
      endif
    endfor
    let i += 1
  endwhile
  return stripedList
endfun

" TODO key for switching background between dark and bright
set background=dark
" XXX tlib seems not working, so workaround
"Plugin 'tlib'
"let g:mySetColors = tlib#list#RemoveAll(tlib#list#Flatten(tlib#list#Zip(g:mySetColorsSet)),'')
let g:mySetColors       = s:stripeLists(s:mySetColorsSet)
try
exec 'silent! colorscheme' g:mySetColors[0]
endtry

let s:LoadedBundles = 1
endtry
" vim:sw=2:undofile
