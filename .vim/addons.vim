version 7.3
set nocompatible

if exists("*SetupAddons") | finish | endif

fun! SetupAddons()
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
  ActivateAddons hybrid jellybeans molokai Colour_Sampler_Pack
    let g:jellybeans_overrides = {
          \    'Todo': { 'guifg': '101010', 'guibg': 'fad07a',
          \              'ctermfg': 'Black', 'ctermbg': 'Yellow',
          \              'attr': 'bold' },
          \}
  " scroll among my favorites with VimTip341
  ActivateAddons git:git://gist.github.com/1432015.git
    let s:mySetColorsSet = []
    let s:mySetColorsSetDiff = []
    fun! s:addColorSet(reversed, name, ...)
      let colors = a:000 | if a:reversed | let colors = reverse(copy(colors)) | endif
      if stridx(a:name, "'diff") >= 0
        let s:mySetColorsSetDiff += [colors]
      else
        let s:mySetColorsSet += [colors]
      endif
    endfun
    command! -nargs=+ -bar -bang AddColorSet  call s:addColorSet(<bang>0, <f-args>)
    if has("gui_running")
      AddColorSet  'darkLo'     hybrid         desertEx    lucius       camo      dante      candy           " jellybeans brookstream
      AddColorSet  'creativity' spring         clarity     navajo-night sea       oceandeep  breeze          " dusk       tabula      darkblue2
      AddColorSet  'darkHi'     fruity         oceanblack  jammy        northland lettuce    molokai         " neon       vibrantink  vividchalk colorer  torte
      AddColorSet  'bright'     summerfruit256 buttercream PapayaWhip   nuvola    habiLight  fruit           " eclipse    earendel
      AddColorSet! 'precision'  autumn         railscasts  Guardian     candycode inkpot     ChocolateLiquor
      AddColorSet  'diff'       xoria256       candycode   hybrid                                            " jellybeans inkpot          ChocolateLiquor lucius     railscasts  northland  blacksea
      AddColorSet  'diffLight'  PapayaWhip     taqua       silent
    else
      if &t_Co >= 256
        " many color schemes only work well on GUI
        AddColorSet 'lo'     hybrid         wombat256       lettuce    dante
        AddColorSet 'hi'     jellybeans     inkpot          molokai    navajo-night
        AddColorSet 'bright' summerfruit256 lucius          tabula
        AddColorSet 'diff'   xoria256       calmar256-light maroloccio inkpot       ChocolateLiquor " candycode calmar256-dark PapayaWhip lettuce blacksea
        " desertEx colorer vividchalk candycode nuvola earendel
      else
        AddColorSet 'fallback' default
        AddColorSet 'diff'  default
      endif
    endif
    " XXX tlib seems not working, so workaround
    "ActivateAddons tlib
    "let g:mySetColors = tlib#list#RemoveAll(tlib#list#Flatten(tlib#list#Zip(g:mySetColorsSet)),'')
    let g:mySetColorsNormal = s:stripeLists(s:mySetColorsSet)
    let g:mySetColorsDiff   = s:stripeLists(s:mySetColorsSetDiff)
    let g:mySetColors       = g:mySetColorsNormal
    exec 'colorscheme' g:mySetColors[0]
    " use separate colorscheme for viewing diffs
    " See: http://superuser.com/questions/157676/change-color-scheme-when-calling-vimdiff-inside-vim
    let g:diff_colors_name  = g:mySetColorsDiff[0]
    let g:prior_colors_name = g:colors_name
    fun! s:DetectDiffColorScheme()
      if &diff && g:mySetColors is g:mySetColorsNormal
        let g:prior_colors_name = g:colors_name
        let g:mySetColors = g:mySetColorsDiff
        exec 'colorscheme' g:diff_colors_name
      elseif !&diff && g:mySetColors is g:mySetColorsDiff
        let g:diff_colors_name = g:colors_name
        let g:mySetColors = g:mySetColorsNormal
        exec 'colorscheme' g:prior_colors_name
      endif
      if exists("*Powerline") | doautoall Powerline BufEnter,ColorScheme | endif
    endfun
    command! DetectDiffColorScheme call s:DetectDiffColorScheme()
    autocmd FilterWritePost,BufEnter,WinEnter,WinLeave *  DetectDiffColorScheme
    nnoremap <Space>d :diffoff \| DetectDiffColorScheme<CR>
  if has("gui_running") && 0
    ActivateAddons powerline

    set laststatus=2 noshowmode showcmd
    let &guifont = join(map(split(&guifont,","),
          \ 'split(v:val,":")[0]." for Powerline:".split(v:val,":")[1]'),",")
    " using colorscheme from localvimrc can screw up powerline, hence below:
    autocmd VimEnter * doautoall Powerline BufEnter,ColorScheme
  endif


  """ Productivity boosters
  if has("python")
  ActivateAddons Gundo
    let g:gundo_close_on_revert = 1
    nnoremap <Space>u :GundoToggle<CR>
  endif
  "ActivateAddons bufexplorer.zip
  ActivateAddons tselectbuffer
    nnoremap <Space>b :TSelectBuffer<CR>
  ActivateAddons Tagbar
    nnoremap <Space>t :TagbarOpenAutoClose<CR>
    nnoremap <Space>T :TagbarToggle<CR>
  ActivateAddons ack
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
  if has("gui")
    " Ctrl-Click in MacVim needs: defaults write org.vim.MacVim MMTranslateCtrlClick 0
    " See: http://stackoverflow.com/a/10148278/390044
    noremap <C-LeftMouse>  <C-\><C-N><LeftMouse>:call <SID>jumpToTagWithQuickFix(expand("<cword>"))<CR>
    noremap <C-RightMouse> <C-\><C-N><LeftMouse>:call <SID>ackWord(expand("<cword>"))<CR>
  endif
  " unimpaired quickfix access with [q, ]q, [Q, ]Q
  ActivateAddons unimpaired
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
    

    " Align%294's \m= collides with Mark%2666 unless already mapped
    map <Leader>tm= <Plug>AM_m=
  ActivateAddons Align%294
  ActivateAddons surround repeat
  ActivateAddons speeddating
  ActivateAddons commentary
  ActivateAddons vim-visual-star-search
  ActivateAddons EasyMotion
    let g:EasyMotion_leader_key = '<Space>w'
  ActivateAddons matchit.zip
  ActivateAddons rainbow_parentheses
    fun! RainbowParenthesesLoadAndToggleAll()
      exec 'RainbowParenthesesLoadRound'
      exec 'RainbowParenthesesLoadSquare'
      exec 'RainbowParenthesesLoadBraces'
      exec 'RainbowParenthesesLoadChevrons'
      exec 'RainbowParenthesesToggleAll'
    endfun
    nnoremap <C-\>0      :call RainbowParenthesesLoadAndToggleAll()<CR>
    inoremap <C-\>0 <C-o>:call RainbowParenthesesLoadAndToggleAll()<CR>

  " ActivateAddons RltvNmbr
  ActivateAddons DrawIt
  " ActivateAddons MixCase

  ActivateAddons Mark%2666
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
  ActivateAddons neocomplcache vimproc
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
  ActivateAddons CamelCaseComplete CompleteHelper
  ActivateAddons camelcasemotion
    " recover default ,
    nnoremap ,, ,
    xnoremap ,, ,
    onoremap ,, ,
  ActivateAddons abolish

  "ActivateAddons slime
  ActivateAddons The_NERD_tree
    nnoremap <Space>e :NERDTreeFind<CR>
    let g:NERDTreeQuitOnOpen = 1
    let g:NERDTreeShowHidden = 1
    let g:NERDTreeChDirMode  = 1
    let g:NERDTreeSortOrder = ['*', '\.swp$', '\.bak$', '\~$'] " don't put directories on top
    let g:NERDTreeIgnore = ['^.*\.sw[p-z]$', '^\..*\.un\~'] " ignore vim swap and undo files
    " easier preview key mapping
    autocmd BufEnter NERD_tree_* map <buffer> <Space><Space> go
    autocmd BufEnter NERD_tree_* map <buffer> <Space>s       gi
    autocmd BufEnter NERD_tree_* map <buffer> <Space>v       gv
  "ActivateAddons FuzzyFinder
  "  nnoremap <Space>f :FufFileWithCurrentBufferDir<CR>
  "ActivateAddons Command-T
  "  nnoremap <Space>f :CommandT<CR>
  ActivateAddons ctrlp
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlPMixed'
    let g:ctrlp_mruf_relative = 1
    let g:ctrlp_custom_ignore = {
          \ "dir": '\v[\/]\@prefix\@$'
          \ }
  ActivateAddons renamer
  ActivateAddons recover
  "ActivateAddons snipmate
  "ActivateAddons vmark.vim_Visual_Bookmarking " XXX beware: <F2>/<F3> is overrided
  " TODO let b:vm_guibg = yellow
  "if has("ruby")
  "  ActivateAddons tips
  "end
  ActivateAddons localvimrc
    let g:localvimrc_persistent = 1
    let g:localvimrc_sandbox = 0

  """ Git, Github
  ActivateAddons fugitive
    " tips from vimcasts.org
    autocmd User fugitive
      \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
      \   nnoremap <buffer> .. :edit %:h<CR> |
      \ endif
    autocmd BufReadPost fugitive://* set bufhidden=delete
    set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
    " some shorthands
    nnoremap <Space>gg :Gstatus<CR>
    nnoremap <Space>gd :Gdiff<CR>
    nnoremap <Space>gD :Gdiff HEAD<CR>
    nnoremap <Space>gb :Gblame<CR>
    nnoremap <Space>gl :Glog<CR>:copen<CR>
    nnoremap <Space>gL :Glog --<CR>
    nnoremap <Space>ge :Gedit<CR>
    nnoremap <Space>gE :Gedit 
  ActivateAddons gitv
    nnoremap <Space>gv :Gitv --all<CR>
    nnoremap <Space>gV :Gitv! --all<CR>
    vnoremap <Space>gV :Gitv! --all<CR>
    set lazyredraw
  ActivateAddons git:git://github.com/airblade/vim-gitgutter.git
    let g:gitgutter_enabled = 1
    nnoremap <Space><C-g><C-g> :GitGutterToggle<CR>
    nnoremap <Space><C-g>g     :GitGutterLineHighlightsToggle<CR>
    nnoremap ]g :GitGutterNextHunk<CR>
    nnoremap [g :GitGutterPrevHunk<CR>
  ActivateAddons Gist WebAPI
    let g:gist_clip_command = 'pbcopy'
    let g:gist_open_browser_after_post = 1
    nnoremap <Space>GL :Gist -l<CR>
    nnoremap <Space>GA :Gist -la<CR>
    nnoremap <Space>GS :Gist -ls<CR>


  """ Some file types
  let g:sparkup = {}
    let g:sparkup.lhs_expand = '<C-\><C-e>'
    let g:sparkup.lhs_jump_next_empty_tag = '<C-\><C-f>'
  ActivateAddons sparkup
  ActivateAddons vim-less
  ActivateAddons xmledit
    let g:xml_jump_string = "`"
  ActivateAddons ragtag

  ActivateAddons markdown@tpope " Markdown vim-ft-markdown_fold
    " Marked
    au FileType markdown
      \ setlocal spell |
    if has("mac")
      au FileType markdown
        \ nnoremap <D-e> :exec "!open -a Marked ".shellescape(expand("%"))<CR><CR>|
        \ noremap! <D-e> <C-\><C-N><D-e>gi|
        \ call sparkup#Setup()|
    endif
  ActivateAddons JSON
    au BufEnter *.json setfiletype json

  ActivateAddons vim-coffee-script
    au BufEnter *.coffee syntax sync fromstart
    " CoffeeScript autocompilation
    "autocmd BufWritePost *.coffee silent CoffeeMake! | cwindow
  ActivateAddons jade
  ActivateAddons applescript
    au BufEnter *.applescript setfiletype applescript
  ActivateAddons vim-addon-scala
    " Scala (See: http://mdr.github.com/scalariform/)
    au BufEnter *.scala setl formatprg=scalariform\ --forceOutput
  ActivateAddons octave%3600
    au BufEnter *.oct,*.m setlocal filetype=octave

  " Vim-LaTeX is a comprehensive plugin for working with LaTeX
  " See: http://vim-latex.sourceforge.net/documentation/latex-suite/
  ActivateAddons LaTeX-Suite_aka_Vim-LaTeX
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
    fun! s:LaTeX_BuildAndView()
      call s:LaTeX_Build()
      set filetype=tex
      call Tex_ForwardSearchLaTeX()
    endfun
    command! LaTeXBuild        call s:LaTeX_Build()
    command! LaTeXBuildAndView call s:LaTeX_BuildAndView()
    fun! s:LaTeX_Setup()
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
      let suffixes = ".pdf,.dvi,.ps,.ps.gz"
                  \.",.aux,.bbl,.blg,.log,.out,.ent"
                  \.",.fdb_latexmk,.fls,.brf,.synctex.gz"
      if stridx(&suffixes, suffixes) == -1
        exec "setlocal suffixes+=".suffixes
        let patt = '\('. join(map(split(suffixes,','),
              \                   '"\\".v:val'), '\|') .'\)$'
        let g:NERDTreeSortOrder += [patt]
      endif
      " better LaTeX formatting, perhaps with a custom formatprg
      "   See: http://stackoverflow.com/questions/5706820/using-vim-isnt-there-a-more-efficient-way-to-format-latex-paragraphs-according
      "   See: http://stackoverflow.com/questions/1451827/vim-make-gq-treat-as-the-end-of-a-sentence
      let &l:formatprg = '~/.vim/format-latex.pl'
      "   See: http://denihow.com/vim-gq-command-to-re-wrap-paragraph-and-latex/
      "   See: http://superuser.com/questions/422214/vim-gq-command-to-re-wrap-paragraph-and-latex
      let &l:formatlistpat = '^\s*\\\ze\(end\|item\)\>'
      setlocal formatoptions+=n
      " Use LaTeX folds
      nmap <buffer><silent> <Space>z  <Plug>Tex_RefreshFolds
      " Use latexmk and enable synctex
      for fmt in split("pdf ps dvi")
        let g:Tex_CompileRule_{fmt}="~/.vim/latexmk.sh ".fmt." $*"
      endfor
      if has("mac")
        " Use Skim as our PDF viewer and latexmk to compile
        TCTarget pdf
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
        let keyMappings[  '<D-CR>'] = 'LaTeXBuild'
        let keyMappings['<S-D-CR>'] = 'LaTeXBuildAndView'
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
  "ActivateAddons AutomaticLaTeXPlugin
  "ActivateAddons LaTeX_Box

endfun

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Rest of this file borrowed from :help VAM-installation """""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! EnsureVamIsOnDisk(vam_install_path)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
  if !filereadable(a:vam_install_path.'/vim-addon-manager/.git/config')
    " \&& 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
    "" I'm sorry having to add this reminder. Eventually it'll pay off.
    "call confirm("Remind yourself that most plugins ship with ".
    "            \"documentation (README*, doc/*.txt). It is your ".
    "            \"first source of knowledge. If you can't find ".
    "            \"the info you're looking for in reasonable ".
    "            \"time ask maintainers to improve documentation")
    call mkdir(a:vam_install_path, 'p')
    call system('git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager')
    " VAM runs helptags automatically when you install or update 
    " plugins
    exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
  endif
endf

fun! SetupVAM()
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager['key'] = value

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager['drop_git_sources'] = !executable('git')

  " Default VAM settings
  if !exists("g:vim_addon_manager") | let g:vim_addon_manager = {} | endif
  call extend(g:vim_addon_manager, {
        \'known_repos_activation_policy': 'yes',
        \'auto_install': 1,
        \'shell_commands_run_method': 'system',
        \'log_to_buf': 0,
        \}, 'keep')

  " VAM install location:
  let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
  call EnsureVamIsOnDisk(vam_install_path)
  exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

  " Tell VAM which plugins to fetch & load:
  let more = &more | set nomore
  call vam#ActivateAddons(['vim-addon-manager'])
  call SetupAddons()
  let &more = more
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

  " Addons are put into vam_install_path/plugin-name directory
  " unless those directories exist. Then they are activated.
  " Activating means adding addon dirs to rtp and do some additional
  " magic

  " How to find addon names?
  " - look up source from pool
  " - (<c-x><c-p> complete plugin names):
  " You can use name rewritings to point to sources:
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
try
call SetupVAM()
endtry
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]


" vim:sw=2:undofile
