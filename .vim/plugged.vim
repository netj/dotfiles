" netj's Vim plugins
version 7.3
if exists("s:LoadedBundles") | finish | endif
try

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto-install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  if executable("git")
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
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

" Initialize vim-plug
call plug#begin()
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
Plug 'w0ng/vim-hybrid'
"let g:hybrid_custom_term_colors = 1
"let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
"Plug 'kristijanhusak/vim-hybrid-material'
let g:enable_bold_font = 1
let g:enable_italic_font = 1
let g:hybrid_transparent_background = 1
let g:airline_theme = "hybrid"

" Plug 'junegunn/seoul256.vim'  " https://github.com/junegunn/seoul256.vim
Plug 'nanotech/jellybeans.vim'
Plug 'tomasr/molokai'
Plug 'vim-scripts/Colour-Sampler-Pack'
  let g:jellybeans_overrides = {
        \    'Todo': { 'guifg': '101010', 'guibg': 'fad07a',
        \              'ctermfg': 'Black', 'ctermbg': 'Yellow',
        \              'attr': 'bold' },
        \}
" scroll among my favorites with VimTip341
Plug 'https://gist.github.com/1432015.git'
  let s:mySetColorsSet = []
  fun! s:addColorSet(reversed, name, ...)
    let colors = a:000 | if a:reversed | let colors = reverse(copy(colors)) | endif
    let s:mySetColorsSet += [colors]
  endfun
  command! -nargs=+ -bar -bang AddColorSet  call s:addColorSet(<bang>0, <f-args>)
  if has("gui_running")
    AddColorSet  'darkLo'     hybrid         desertEx    lucius       camo      dante      candy           " jellybeans brookstream
    AddColorSet  'darkHi'     fruity         oceanblack  jammy        northland lettuce    molokai         " neon       vibrantink  vividchalk colorer  torte
    AddColorSet  'creativity' spring         clarity     navajo-night sea       oceandeep  breeze          " dusk       tabula      darkblue2
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

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  let g:airline#extensions#whitespace#enabled = 0
  set laststatus=2 noshowmode showcmd
if has("gui_running")
  let g:airline_powerline_fonts = 1
  " fun! s:fontname(nameSize)
  "   return substitute(a:nameSize, "\\(:h\\|  *\\)[0-9]\\+$", "", "i")
  " endfun
  " let guifonts = reverse(map(split(&guifont,","), '[s:fontname(v:val), v:val[len(s:fontname(v:val)):]]'))
  " let suffixes = reverse([
  "       \  " for Powerline",
  "       \  " Powerline",
  "       \  " derivative Powerline",
  "       \])
  " for [name,size] in guifonts
  "   for suffix in suffixes
  "     let &guifont = name.suffix.size .",". &guifont
  "   endfor
  " endfor
  " using colorscheme from localvimrc can screw up powerline, hence below:
  autocmd VimEnter * doautoall airline BufEnter,ColorScheme

  if has("gui_gtk2")
    " quick font resize for GVim
    Plug 'vim-scripts/fontsize'
      nmap <silent> <M-=> <Leader><Leader>+
      nmap <silent> <M--> <Leader><Leader>-
  endif
endif


""" Productivity boosters
" open-browser for broken netrw gx (cf. https://github.com/vim/vim/issues/4738)
Plug 'tyru/open-browser.vim'
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
if has("python")
Plug 'sjl/gundo.vim'
  let g:gundo_close_on_revert = 1
  nnoremap <Space>u :GundoToggle<CR>
endif
Plug 'jlanzarotta/bufexplorer'
  nnoremap <Space>b :BufExplorerHorizontalSplit<CR>
"Plug 'tselectbuffer'
"  nnoremap <Space>b :TSelectBuffer<CR>
Plug 'majutsushi/tagbar'
  nnoremap <Space>t :TagbarOpenAutoClose<CR>
  nnoremap <Space>T :TagbarToggle<CR>
  " See also: https://ctags.io or brew install --HEAD universal-ctags/universal-ctags/universal-ctags
Plug 'mileszs/ack.vim'
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
Plug 'tpope/vim-unimpaired'
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
Plug 'tommcdo/vim-exchange'

  " Align%294's \m= collides with Mark%2666 unless already mapped
  map <Leader>tm= <Plug>AM_m=
Plug 'vim-scripts/Align'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-speeddating' " FIXME doesn't work with 7.4-1589
Plug 'tpope/vim-commentary'
Plug 'bronson/vim-visual-star-search'
Plug 'easymotion/vim-easymotion'
  let g:EasyMotion_leader_key = '<Space>w'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/closeb'  " CTRL-_ to close complex brackets/tags
Plug 'kien/rainbow_parentheses.vim'
  fun! RainbowParenthesesLoadAndToggleAll()
    exec 'RainbowParenthesesLoadRound'
    exec 'RainbowParenthesesLoadSquare'
    exec 'RainbowParenthesesLoadBraces'
    exec 'RainbowParenthesesLoadChevrons'
    exec 'RainbowParenthesesToggleAll'
  endfun
  nnoremap <C-\>0      :call RainbowParenthesesLoadAndToggleAll()<CR>
  inoremap <C-\>0 <C-o>:call RainbowParenthesesLoadAndToggleAll()<CR>

" Plug 'RltvNmbr'
Plug 'vim-scripts/DrawIt'
" Plug 'MixCase'
Plug 'junegunn/vim-emoji'

Plug 'inkarkat/vim-ingo-library'  " required by vim-mark
Plug 'inkarkat/vim-mark'
  let g:mw_no_mappings = 1  " disable default mappings to use custom ones below
  let g:mwHistAdd       = '' " '/@'
  let g:mwAutoLoadMarks = 1
  let g:mwAutoSaveMarks = 1
  set viminfo+=!  " Save and restore global variables.
  nmap <Space>m <Plug>MarkSet
  xmap <Space>m <Plug>MarkSet
  nmap <Space>M <Plug>MarkClear
  xmap <Space>M <Plug>MarkClear
  nmap <Space>n <Plug>MarkSearchNext
  nmap <Space>N <Plug>MarkSearchPrev

""" CamelCase stuff
" Shougo's NeoComplCache is really nice!
if $USER != "root"
Plug 'Shougo/neocomplcache'
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
Plug 'vim-scripts/CamelCaseComplete' 
Plug 'vim-scripts/CompleteHelper'
Plug 'bkad/CamelCaseMotion'
  " recover default ,
  nnoremap ,, ,
  xnoremap ,, ,
  onoremap ,, ,
Plug 'tpope/vim-abolish'

"Plug 'slime'
Plug 'scrooloose/nerdtree'
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
Plug 'netj/vim-vinegar'  " XXX using personal fork of 'tpope/vim-vinegar'
  let g:NERDTreeHijackNetrw = 0
"Plug 'FuzzyFinder'
"  nnoremap <Space>f :FufFileWithCurrentBufferDir<CR>
"Plug 'Command-T'
"  nnoremap <Space>f :CommandT<CR>

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <Space>fg :GFiles<CR>
nnoremap <Space>ff :Files<CR>
nnoremap <Space>ft :Tags<CR>
set tags+=.git/tags
nnoremap <Space>fo :History<CR>
" TODO fzf history if possible?
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

Plug 'kien/ctrlp.vim'
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlPMixed'
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_custom_ignore = {
        \ "dir": '\v[\/]\@prefix\@$'
        \ }
Plug 'qpkorr/vim-renamer'
Plug 'chrisbra/Recover.vim'
"Plug 'snipmate'
"Plug 'vmark.vim_Visual_Bookmarking' " XXX beware: <F2>/<F3> is overrided
" TODO let b:vm_guibg = yellow
"if has("ruby")
"  Plug 'tips'
"end
Plug 'tpope/vim-eunuch' " for :Move, :SudoWrite, etc.

" Vim and Tmux even better together: https://blog.bugsnag.com/tmux-and-vim/
if exists("$TMUX")  " activate only in a tmux session
  Plug 'christoomey/vim-tmux-navigator'
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

  Plug 'benmills/vimux'
  noremap <silent> <Esc><C-]>    :wall\|VimuxPromptCommand<CR>
  noremap <silent> <Esc><Return> :wall\|VimuxRunLastCommand<CR>
  noremap <silent> <Esc><C-x>    :VimuxInspectRunner<CR>
  " vimux zooming tmux pane and returning, a la suspending Vim w/ Ctrl-Z
  noremap <silent> <Esc><C-z>    :VimuxZoomRunner<CR>

  " ignore the prefix sent by Tmux for uniform behavior across INSERT-NORMAL modes
  nnoremap <silent> <C-\><C-o>   <C-g>
endif

""" Git, Github
Plug 'tpope/vim-fugitive'
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
  nnoremap <Space>gg :Git<CR>
  nnoremap <Space>gd :Gdiff<CR>
  nnoremap <Space>gD :Gdiff HEAD<CR>
  nnoremap <Space>gb :Git blame<CR>
  nnoremap <Space>gl :Glog<CR>:copen<CR>
  nnoremap <Space>gL :Glog --<CR>
  nnoremap <Space>ge :Gedit<CR>
  nnoremap <Space>gE :Gedit 
Plug 'tpope/vim-rhubarb'
Plug 'gregsexton/gitv'
  nnoremap <Space>gv :Gitv --all<CR>
  nnoremap <Space>gV :Gitv! --all<CR>
  vnoremap <Space>gV :Gitv! --all<CR>
  set lazyredraw
Plug 'airblade/vim-gitgutter'
  let g:gitgutter_enabled = 1
  nnoremap <Space><C-g><C-g> :GitGutterToggle<CR>
  nnoremap <Space><C-g>g     :GitGutterLineHighlightsToggle<CR>
  nnoremap ]g :GitGutterNextHunk<CR>
  nnoremap [g :GitGutterPrevHunk<CR>
  nnoremap <Space>gh :GitGutterPreviewHunk<CR>
  nnoremap [G :GitGutterStageHunk<CR>
  nnoremap ]G :GitGutterUndoHunk<CR>
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
  let g:gist_clip_command = 'pbcopy'
  let g:gist_open_browser_after_post = 1
  let g:gist_get_multiplefile = 1
  nnoremap <Space>GL :Gist -l<CR>
  nnoremap <Space>GA :Gist -la<CR>
  nnoremap <Space>GS :Gist -ls<CR>


""" Some file types
Plug 'tpope/vim-endwise'
let g:sparkup = {}
  let g:sparkup.lhs_expand = '<C-\><C-e>'
  let g:sparkup.lhs_jump_next_empty_tag = '<C-\><C-f>'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'vim-scripts/xmledit'
  let g:xml_jump_string = "`"
Plug 'tpope/vim-ragtag'

Plug 'tpope/vim-markdown' " Markdown vim-ft-markdown_fold
  " Marked
  au FileType markdown
    \ call s:setLocalOptionsForWriting() |
    \ let &l:formatprg = '~/.vim/format-latex.pl' | " abuse LaTeX formatter on Markdown
    \ setlocal formatoptions+=n |
  if has("mac")
    au FileType markdown
      \ nnoremap <D-e> :exec "!open -a \"Marked 2\" ".shellescape(expand("%"))<CR><CR>|
      \ noremap! <D-e> <C-\><C-N><D-e>gi|
  endif
Plug 'elzr/vim-json'
  au BufEnter *.json setfiletype json
Plug 'vito-c/jq.vim'  " jq query language for JSON
Plug 'tpope/vim-jdaddy' " for aj and ij text objects
Plug 'GEverding/vim-hocon'  " for HOCON (Human Optimized Configuration Object Notation)

" C/C++ development essentials
if has("python") && exists("$VIM_YCM")
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
" See: https://github.com/Valloric/YouCompleteMe#options
" only activate YCM on a select filetypes (defaults to '*')
let g:ycm_filetype_whitelist = {
      \ 'cpp': 1,
      \}
Plug 'rdnetto/YCM-Generator'
endif
if executable("clang-format")
  Plug 'kana/vim-operator-user' " vim-operator-user
  Plug 'rhysd/vim-clang-format' " vim-clang-format
  let g:clang_format#code_style = "google"
  au FileType c,cpp,objc,objcpp
        \| nmap <Space><C-K> :ClangFormatAutoToggle<CR>
        \| map <C-K> <Plug>(operator-clang-format)
endif
Plug 'msanders/cocoa.vim' 
Plug 'b4winckler/vim-objc'
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
Plug 'hashivim/vim-terraform'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Quramy/tsuquyomi'
Plug 'kchmck/vim-coffee-script'
  au BufEnter *.coffee syntax sync fromstart
  " Search for CoffeeScript/JavaScript files, e.g., require "foo"
  au BufRead,BufNewFile *.coffee setl suffixesadd+=.coffee,.js
  " CoffeeScript autocompilation
  "autocmd BufWritePost *.coffee silent CoffeeMake! | cwindow
if has("ruby")
  Plug 'lukaszkorecki/CoffeeTags'
endif
Plug 'digitaltoad/vim-pug'  " formerly jade.vim
Plug 'kana/vim-altr'
  nmap <Space><Tab>    <Plug>(altr-forward)
  nmap <Space><S-Tab>  <Plug>(altr-backward)
Plug 'tpope/vim-classpath'
Plug 'vim-scripts/applescript.vim'
  au BufEnter *.applescript setfiletype applescript
Plug 'derekwyatt/vim-scala'
"Plug 'MarcWeber/vim-addon-scala'
  " Scala (See: http://mdr.github.com/scalariform/)
  "au BufEnter *.scala setl formatprg=scalariform\ --forceOutput
Plug 'vim-scripts/octave.vim--'
  au BufEnter *.oct setlocal filetype=octave  " XXX *.m could be an Objective-C file
Plug 'vim-scripts/SQLUtilities'
  let g:sqlutil_keyword_case='\U'
  let g:sqlutil_align_where=1
  let g:sqlutil_align_comma=0
" Python
Plug 'nvie/vim-flake8'
Plug 'tell-k/vim-autopep8'
Plug 'cespare/vim-toml'

" Vim-LaTeX is a comprehensive plugin for working with LaTeX
" See: http://vim-latex.sourceforge.net/documentation/latex-suite/
Plug 'vim-latex/vim-latex'
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
" Automatic LaTeX Plug for Vim and LaTeX_Box is also nice supporting
" latexmk directly, vim-like motions, mappings, etc.  but I find it a little
" premature yet (e.g., ShowErrors didn't work for me)
" See: http://atp-vim.sourceforge.net
"Plug 'AutomaticLaTeXPlug'
"Plug 'LaTeX_Box'

"Plug 'embear/vim-localvimrc'
"  let g:localvimrc_name = [ ".lvimrc", ".vimrc" ]
"  let g:localvimrc_persistent = 1
"  let g:localvimrc_sandbox = 0
Plug 'MarcWeber/vim-addon-local-vimrc'
  let g:local_vimrc = {'names':['.lvimrc', '.vimrc'],'hash_fun':'LVRHashOfFile'}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All of your Plugs must be added before the following line
call plug#end()              " required
filetype plugin indent on    " required
"
" Brief help
" :PlugInstall      - installs plugins
" :PlugUpdate       - update plugins
" :PlugClean        - removes unlisted plugins (confirm removal)
" :PlugUpgrade      - upgrade vim-plug itself
" :PlugStatus       - check the status of plugins
"
" see :h vim-plug for more details
" Put your non-Plug stuff after this line
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
"Plug 'tlib'
"let g:mySetColors = tlib#list#RemoveAll(tlib#list#Flatten(tlib#list#Zip(g:mySetColorsSet)),'')
let g:mySetColors       = s:stripeLists(s:mySetColorsSet)
try
exec 'silent! colorscheme' g:mySetColors[0]
endtry

let s:LoadedBundles = 1
endtry
" vim:sw=2:undofile
