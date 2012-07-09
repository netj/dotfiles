if exists("*SetupAddons") | finish | endif

fun! SetupAddons()

  """ Look and Feels
  " See Also: http://www.quora.com/Which-are-the-best-vim-plugins
  " See Also: http://stevelosh.com/blog/2010/09/coming-home-to-vim/
  " See for more available schemes in ColorSamplerPack: http://www.vi-improved.org/color_sampler_pack/
  " dark-lo: desertEx anotherdark darkZ inkpot jellybeans herald railscasts fruity dante wombat256 ChocolateLiquor clarity freya xoria256 twilight darkslategray darkblue2
  " dark-hi: candycode asu1dark jammy lettuce darkspectrum desert256 leo vibrantink vividchalk guardian torte darkbone
  " light-hi: summerfruit256 eclipse nuvola fruit
  " light-lo: spring autumn sienna
  " fun: matrix borland golden camo
  ActivateAddons Color_Sampler_Pack molokai
  ActivateAddons git:git://gist.github.com/1432015.git
    if has("gui_running")
      " scroll among my favorites with VimTip341
      let g:mySetColors = split('jellybeans molokai inkpot desertEx darkZ lettuce vibrantink vividchalk chocolateliquor matrix golden camo spring autumn sienna summerfruit256 fruit')
      " let g:mySetColors=split('desertEx anotherdark darkZ inkpot jellybeans herald railscasts fruity dante wombat256 chocolateliquor clarity freya xoria256 twilight darkslategray darkblue2  candycode asu1dark jammy lettuce darkspectrum desert256 leo vibrantink vividchalk guardian torte darkbone  eclipse nuvola fruit  spring autumn autumn2 siena  matrix borland golden camo')
      colorscheme jellybeans
    else
      if &t_Co >= 256
        " many color schemes only work well on GVim
        let g:mySetColors = split('jellybeans molokai inkpot lettuce summerfruit256')
        colorscheme jellybeans
      else
        let g:mySetColors = split('default')
        colorscheme default
      endif
    endif
    " let g:mySetColors=split('desertEx anotherdark darkZ inkpot jellybeans herald railscasts fruity dante wombat256 chocolateliquor clarity freya xoria256 twilight darkslategray darkblue2  candycode asu1dark jammy lettuce darkspectrum desert256 leo vibrantink vividchalk guardian torte darkbone  eclipse nuvola fruit  spring autumn autumn2 siena  matrix borland golden camo')

  """ Productivity boosters
  ActivateAddons Gundo
  ActivateAddons bufexplorer.zip
  ActivateAddons Tagbar

  ActivateAddons Tabular
  ActivateAddons surround
  ActivateAddons rainbow_parentheses
    nnoremap <F7> :RainbowParenthesesToggleAll<CR>
    inoremap <F7> <C-o>:RainbowParenthesesToggleAll<CR>

  """ CamelCase stuff
  " Shougo's NeoComplCache is really nice!
  ActivateAddons neocomplcache vimproc
    let g:acp_enableAtStartup = 0
    " XXX Rather than enabling at startup, I use special key combo Cmd-Shift-D to turn it on
    "let g:neocomplcache_enable_at_startup = 1
    map <D-D> :NeoComplCacheEnable<CR>:NeoComplCacheCachingBuffer<CR>:NeoComplCacheCachingInclude<CR>
    "let g:neocomplcache_enable_smart_case = 1
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
  ActivateAddons The_NERD_tree
  ActivateAddons snipmate
  "ActivateAddons vmark.vim_Visual_Bookmarking " XXX beware: <F2>/<F3> is overrided
  " TODO let b:vm_guibg = yellow
  "if has("ruby")
  "  ActivateAddons tips
  "end

  """ Git, Github
  ActivateAddons fugitive
  ActivateAddons Gist WebAPI
    let g:gist_clip_command = 'pbcopy'
    let g:gist_open_browser_after_post = 1


  """ Some file types
  let g:sparkup = {}
    let g:sparkup.lhs_expand = '<C-\><C-e>'
    let g:sparkup.lhs_jump_next_empty_tag = '<C-\><C-n>'
  ActivateAddons sparkup
  ActivateAddons vim-less
  ActivateAddons xmledit
    let g:xml_jump_string = "`"

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
    au! BufRead,BufNewFile *.applescript setfiletype applescript
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

  " Tell VAM which plugins to fetch & load:
  call vam#ActivateAddons(['vim-addon-manager'], {'auto_install' : 1})
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


" vim:sw=2
