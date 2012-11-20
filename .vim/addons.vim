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
  ActivateAddons Colour_Sampler_Pack molokai
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
    command -nargs=+ -bar -bang AddColorSet  call s:addColorSet(<bang>0, <f-args>)
    if has("gui_running")
      AddColorSet  'darkLo'     jellybeans     desertEx    lucius       camo      dante     candy           "      brookstream
      AddColorSet  'creativity' spring         clarity     navajo-night sea       oceandeep breeze          "      dusk        tabula     darkblue2
      AddColorSet  'darkHi'     fruity         oceanblack  jammy        northland lettuce   molokai         "      neon        vibrantink vividchalk colorer torte
      AddColorSet  'bright'     summerfruit256 buttercream PapayaWhip   nuvola    habiLight fruit           "      eclipse     earendel
      AddColorSet! 'precision'  autumn         railscasts  Guardian     candycode inkpot    ChocolateLiquor
      AddColorSet  'diff'       xoria256       candycode   jellybeans   "         inkpot    ChocolateLiquor lucius railscasts  northland  blacksea
      AddColorSet  'diffLight'  PapayaWhip     taqua       silent
    else
      if &t_Co >= 256
        " many color schemes only work well on GUI
        AddColorSet 'hi'     jellybeans inkpot          molokai         navajo-night
        AddColorSet 'lo'     lucius          lettuce         dante        wombat256
        AddColorSet 'bright' tabula     summerfruit256
        AddColorSet 'diff'   xoria256 calmar256-light maroloccio inkpot ChocolateLiquor " candycode calmar256-dark PapayaWhip lettuce blacksea
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
    autocmd FilterWritePost,BufEnter,WinEnter,WinLeave *
          \ if &diff && g:mySetColors is g:mySetColorsNormal |
          \   let g:prior_colors_name = g:colors_name |
          \   let g:mySetColors = g:mySetColorsDiff   |
          \   exec 'colorscheme' g:diff_colors_name |
          \ elseif !&diff && g:mySetColors is g:mySetColorsDiff |
          \   let g:diff_colors_name = g:colors_name |
          \   let g:mySetColors = g:mySetColorsNormal |
          \   exec 'colorscheme' g:prior_colors_name |
          \ endif


  """ Productivity boosters
  ActivateAddons Gundo
    let g:gundo_close_on_revert = 1
    nnoremap <Space>u :GundoToggle<CR>
  ActivateAddons bufexplorer.zip
    nnoremap <Space>b :BufExplorerHorizontalSplit<CR>
  ActivateAddons Tagbar
    nnoremap <Space>t :TagbarOpenAutoClose<CR>
    nnoremap <Space>T :TagbarToggle<CR>
  " unimpaired quickfix access with [q, ]q, [Q, ]Q
  ActivateAddons unimpaired

    " Align%294's \m= collides with Mark%2666 unless already mapped
    map <Leader>tm= <Plug>AM_m=
  ActivateAddons Align%294
  ActivateAddons surround
  ActivateAddons repeat
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

  "ActivateAddons ack
  "ActivateAddons slime
  ActivateAddons The_NERD_tree
    nnoremap <Space>e :NERDTreeFind<CR>
    let g:NERDTreeQuitOnOpen = 1
    let g:NERDTreeShowHidden = 1
    let g:NERDTreeChDirMode  = 2
    let g:NERDTreeSortOrder = ['*', '\.swp$', '\.bak$', '\~$'] " don't put directories on top
    let g:NERDTreeIgnore = ['^.*\.sw[p-z]$', '^\..*\.un\~'] " ignore vim swap and undo files
    " easier preview key mapping
    autocmd BufEnter NERD_tree_* map <buffer> <Space><Space> go
    autocmd BufEnter NERD_tree_* map <buffer> <Space>s       gi
    autocmd BufEnter NERD_tree_* map <buffer> <Space>v       gv
  ActivateAddons renamer
  ActivateAddons snipmate
  "ActivateAddons vmark.vim_Visual_Bookmarking " XXX beware: <F2>/<F3> is overrided
  " TODO let b:vm_guibg = yellow
  "if has("ruby")
  "  ActivateAddons tips
  "end

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

  ActivateAddons Markdown
  "ActivateAddons vim-ft-markdown_fold
    " Marked
    au! FileType markdown
      \ setlocal spell |
    if has("mac")
      au! FileType markdown
        \ map <D-e> :!open -a Marked '%'<CR><CR>
    endif
  ActivateAddons JSON
    au! BufRead,BufNewFile *.json setfiletype json

  ActivateAddons vim-coffee-script
    " CoffeeScript autocompilation
    "autocmd BufWritePost *.coffee silent CoffeeMake! | cwindow
  ActivateAddons applescript
    au! BufRead,BufNewFile *.applescript setfiletype applescript
  ActivateAddons vim-addon-scala
    " Scala (See: http://mdr.github.com/scalariform/)
    au BufEnter *.scala setl formatprg=scalariform\ --forceOutput

  " Vim-LaTeX
  " See-Also: http://michaelgoerz.net/refcards/vimlatexqrc.pdf
  ActivateAddons LaTeX-Suite_aka_Vim-LaTeX
    au! FileType tex
      \ setlocal spell textwidth=76 |
      \ set suffixes+=.pdf,.dvi,.ps,.ps.gz,.aux,.bbl,.blg,.log,.out,.ent,.fdb_latexmk,.brf " TeX by-products
    if has("mac")
      " Use Skim as our PDF viewer and latexmk to compile
      let g:Tex_ViewRule_pdf="Skim"
      " In Skim's preferences, use the following for PDF-TeX Sync Support
      " Command: /opt/homebrew/bin/mvim
      " Arguments: $(osascript -e 'tell application "MacVim" to get name of front window' | sed 's/.* - /--servername /') --remote-silent +":%line|silent!.foldopen!|" "%file"
      " Command must be a full path name to mvim unless you put it in a system location such as /usr/bin.
      " Arguments has a fancy applescript to open on the active MacVim window.
      for fmt in split("pdf ps dvi")
        let g:Tex_CompileRule_{fmt}=""
              \."source ~/.bashrc && cd \"$(dirname $*)\" && "
              \."latexmk"
              \." -latexoption='-synctex=1 -interaction=nonstopmode'"
              \." -".fmt
              \." $*"
      endfor
      " for quick compile/view/sync with latexmk
      fun! g:LaTeX_Build()
        write
        let oldmore=&more | set nomore
        exec "make ".escape(Tex_GetMainFileName(),' \')
        let &more=oldmore
      endfun
      fun! g:LaTeX_BuildAndView()
        call g:LaTeX_Build()
        set filetype=tex
        call Tex_ForwardSearchLaTeX()
      endfun
      " and some key bindings with Command-key
      fun! s:LaTeX_SetupKeyBindings()
        map <D-e>   <F5>| map! <D-e>   <F5>
        map <D-E> <S-F5>| map! <D-E> <S-F5>
        map <D-r>   <F7>| map! <D-r>   <F7>
        map <D-R> <S-F7>| map! <D-R> <S-F7>
        map <D-®>   <F9>| map! <D-®>   <F9>
        imap <D-j> <Plug>IMAP_JumpBack
        let keyMappings = {}
        let keyMappings[  '<D-CR>'] = 'g:LaTeX_Build'
        let keyMappings['<S-D-CR>'] = 'g:LaTeX_BuildAndView'
        for [key,fn] in items(keyMappings)
          exec 'nnoremap '.key.'           :call '.fn.'()<CR><CR>:cwindow<CR>'
          exec 'xnoremap '.key.'           :call '.fn.'()<CR><CR>gv'
          exec 'inoremap '.key.' <C-\><C-N>:call '.fn.'()<CR><CR>gi'
        endfor
      endfun
      au! FileType tex call s:LaTeX_SetupKeyBindings()
    endif

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
     \&& 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
    " I'm sorry having to add this reminder. Eventually it'll pay off.
    call confirm("Remind yourself that most plugins ship with ".
                \"documentation (README*, doc/*.txt). It is your ".
                \"first source of knowledge. If you can't find ".
                \"the info you're looking for in reasonable ".
                \"time ask maintainers to improve documentation")
    call mkdir(a:vam_install_path, 'p')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
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

  " VAM install location:
  let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
  call EnsureVamIsOnDisk(vam_install_path)
  exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

  let g:vim_addon_manager = {}
  let g:vim_addon_manager['auto_install'] = 1
  " Tell VAM which plugins to fetch & load:
  call vam#ActivateAddons(['vim-addon-manager'])
  call SetupAddons()
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
call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]


" vim:sw=2:undofile
