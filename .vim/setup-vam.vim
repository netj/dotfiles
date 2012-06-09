if ! exists("*SetupVAM")
fun SetupVAM()
  " YES, you can customize this vam_install_path path and everything still works!
  let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
  exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

  " * unix based os users may want to use this code checking out VAM
  " * windows users want to use http://mawercer.de/~marc/vam/index.php
  "   to fetch VAM, VAM-known-repositories and the listed plugins
  "   without having to install curl, unzip, git tool chain first
  " -> BUG [4] (git-less installation)
  if !filereadable(vam_install_path.'/vim-addon-manager/.git/config') && 1 == confirm("git clone VAM into ".vam_install_path."?","&Y\n&N")
    " I'm sorry having to add this reminder. Eventually it'll pay off.
    call confirm("Remind yourself that most plugins ship with documentation (README*, doc/*.txt). Its your first source of knowledge. If you can't find the info you're looking for in reasonable time ask maintainers to improve documentation")
    exec '!p='.shellescape(vam_install_path).'; mkdir -p "$p" && cd "$p" && git clone --depth 1 git://github.com/MarcWeber/vim-addon-manager.git'
    " VAM run helptags automatically if you install or update plugins
    exec 'helptags '.fnameescape(vam_install_path.'/vim-addon-manager/doc')
  endif

  " Example drop git sources unless git is in PATH. Same plugins can
  " be installed form www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager['drop_git_sources'] = !executable('git')

  let addons=[] | command! -nargs=* ActivateAddons let addons+=[<f-args>]
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  """ Look and Feels
  " See Also: http://www.quora.com/Which-are-the-best-vim-plugins
  " See Also: http://stevelosh.com/blog/2010/09/coming-home-to-vim/
  ActivateAddons Color_Sampler_Pack
  ActivateAddons ScrollColors

  """ Productivity boosters
  ActivateAddons surround
  ActivateAddons rainbow_parentheses
    nnoremap <F7> :RainbowParenthesesToggle<CR>
    inoremap <F7> <C-o>:RainbowParenthesesToggle<CR>

  """ CamelCase stuff
  " Shougo's NeoComplCache is really nice!
  ActivateAddons neocomplcache vimproc
    let g:acp_enableAtStartup = 0 
    " XXX Rather than enabling at startup, I use special key combo Cmd-Shift-D to turn it on
    "let g:neocomplcache_enable_at_startup = 1
    map <D-D> :NeoComplCacheEnable<CR>:NeoComplCacheCachingBuffer<CR>:NeoComplCacheCachingInclude<CR>
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_enable_camel_case_completion = 1 
    let g:neocomplcache_enable_underbar_completion = 1
    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  " CamelCaseComplete is less convenient (CTRL-X CTRL-C), yet lightweight
  ActivateAddons CamelCaseComplete CompleteHelper
  ActivateAddons camelcasemotion

  "ActivateAddons ack
  "ActivateAddons slime
  "ActivateAddons The_NERD_tree
  ActivateAddons snipmate

  """ Git, Github
  ActivateAddons fugitive
  ActivateAddons Gist


  """ Some file types
  ActivateAddons sparkup
  ActivateAddons vim-less
  ActivateAddons xmledit

  ActivateAddons Markdown
  "ActivateAddons vim-ft-markdown_fold
    " Marked
    au! FileType markdown
      \ setlocal spell |
      \ map <D-e> :!open -a Marked '%'<CR><CR>
  ActivateAddons JSON
    au! BufRead,BufNewFile *.json setfiletype json

  ActivateAddons vim-coffee-script
    " CoffeeScript autocompilation
    "autocmd BufWritePost *.coffee silent CoffeeMake! | cwindow
  ActivateAddons applescript
  ActivateAddons vim-addon-scala
    " Scala (See: http://mdr.github.com/scalariform/)
    au BufEnter *.scala setl formatprg=scalariform\ --forceOutput

  " Vim-LaTeX
  " See-Also: http://michaelgoerz.net/refcards/vimlatexqrc.pdf
  ActivateAddons vim-latex
    au! FileType tex
      \ setlocal spell textwidth=76 |
      \ map  <D-e>   <F5>| map! <D-e>   <F5>|
      \ map  <D-E> <S-F5>| map! <D-E> <S-F5>|
      \ map  <D-r>   <F7>| map! <D-r>   <F7>|
      \ map  <D-R> <S-F7>| map! <D-R> <S-F7>|
      \ map  <D-®>   <F9>| map! <D-®>   <F9>|
      \ imap <D-j> <Plug>IMAP_JumpBack|
      \ set suffixes+=.pdf,.dvi,.ps,.ps.gz,.aux,.bbl,.blg,.log,.out,.ent,.fdb_latexmk,.brf " TeX by-products




  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  call vam#ActivateAddons(addons, {'auto_install' : 1})
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
  "  - look up source from pool (<c-x><c-p> complete plugin names):
  "    ActivateAddons(["foo",  ..
  "  - name rewritings: 
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()
" experimental: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]
endif
" vim:sw=2
