-- XXX nvchad shadows too many good ole vim mappings, so selectively bringing in
-- require "nvchad.mappings"
local map = vim.keymap.set

--[[
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
--]]

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

--[[
map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
--]]

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

--[[
-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })
--]]

--[[
-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)
--]]

--[[
-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })
--]]

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })


--------------------------------------------------------------------------------
-- add yours here
--------------------------------------------------------------------------------
-- local map = vim.keymap.set

-- Some mappings for less punishing maps
vim.api.nvim_create_user_command("W", "write", {})  -- allow both :w and :W
-- map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>", { desc = "Alternative Esc key combo for weird keyboards" })

-- nvchad corrections
-- EMACS/BASH/readline and/or macOS key bindings in input mode instead of useless default
map("i", "<C-a>", "<C-\\><C-N>^", { desc = "move to beginning of the line" })
map("i", "<C-e>", "<C-\\><C-N>$", { desc = "move to end of the line" })
map("i", "<C-b>", "<Left>", { desc = "move backward" })
map("i", "<C-f>", "<Right>", { desc = "move forward" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>N", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- tabufline
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })
map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })
map("n", "<leader><tab>", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<leader><S-tab>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- terminal
if vim.fn.has("gui_running") then
    map("n", "<C-z>", ":split term://%:h//bash<enter>a")
end

-- nvimtree
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })
-- Quickly browse surrounding files
map("n", "-", function()
  local dir = vim.fn.expand("%:h")
  if dir == "" then dir = vim.fn.expand("$PWD") end
  return "<cmd>chdir " .. dir .. "<CR><cmd>NvimTreeFocus<CR>"
end, { expr = true, desc = "Open parent or working dir in NvimTree" })

-- Search and quickfix window management
-- map("n", "<Space>*", ":nohlsearch<CR>", { desc = "Clear search highlights" })


-- easier finding and tracking things
map("n", "<Space>q", ":copen<CR>", { desc = "Open quickfix window" })
map("n", "<Space>l", ":lopen<CR>", { desc = "Open location list" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- Close quickfix/location windows with q
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    local buftype = vim.bo.buftype
    if buftype == "quickfix" or buftype == "nofile" then
      vim.keymap.set("n", "q", ":close<CR>", { buffer = true, silent = true })
    end
  end,
})

-- Selecting after pasting
map("n", "gp", function()
  local regtype = vim.fn.getregtype()
  return "p`[" .. string.sub(regtype, 1, 1) .. "`]"
end, { expr = true, desc = "Paste and select" })
map("n", "gP", function()
  local regtype = vim.fn.getregtype()
  return "P`[" .. string.sub(regtype, 1, 1) .. "`]"
end, { expr = true, desc = "Paste before and select" })

-- Easier Cut/Copy/Paste for Neovide macOS
map({ "n", "v" }, "<D-c>", "\"+y", { desc = "Cut to macOS pasteboard" })
map({ "n", "v" }, "<D-x>", "\"+x", { desc = "Copy to macOS pasteboard" })
map("v", "<D-v>", "\"+p", { desc = "Replace from macOS pasteboard" })
map("n", "<D-v>", "\"+gp", { desc = "Paste from macOS pasteboard" })
map("i", "<D-v>", "<C-o>:setlocal paste<CR><C-r>+<C-o>:setlocal paste&<CR>", { desc = "Paste from macOS pasteboard" })

-- XXX Fix syntax highlighting
-- map("n", "<Space>s", ":syntax sync fromstart<CR>", { desc = "Fix syntax highlighting" })

-- Display line movement with arrow keys
map("n", "<Up>", function()
  return vim.v.count == 0 and "gk" or "<Up>"
end, { expr = true, desc = "Move up by display line" })
map("n", "<Down>", function()
  return vim.v.count == 0 and "gj" or "<Down>"
end, { expr = true, desc = "Move down by display line" })
map("n", "<Home>", function()
  return vim.v.count == 0 and "g0" or "<Home>"
end, { expr = true, desc = "Go to beginning of display line" })
map("n", "<End>", function()
  return vim.v.count == 0 and "g$" or "<End>"
end, { expr = true, desc = "Go to end of display line" })

-- Word movement (Alt+Left/Right)
map({ "n", "i", "v" }, "<M-Left>", function()
  if vim.fn.mode() == "i" then
    return "<C-o>b"
  else
    return "b"
  end
end, { expr = true, desc = "Move word backward" })
map({ "n", "i", "v" }, "<M-Right>", function()
  if vim.fn.mode() == "i" then
    return "<C-o>w"
  else
    return "w"
  end
end, { expr = true, desc = "Move word forward" })

-- (netj's legacy) Mode toggles with Ctrl-\
map("n", "<C-\\><Space>", ":setlocal list!<CR>:setlocal list?<CR>", { desc = "Toggle list mode" })
map("n", "<C-\\>1", ":setlocal number!<CR>:setlocal number?<CR>", { desc = "Toggle line numbers" })
map("n", "<C-\\>*", ":setlocal hlsearch!<CR>:setlocal hlsearch?<CR>", { desc = "Toggle search highlight" })
map("n", "<C-\\>=", ":setlocal spell!<CR>:setlocal spell?<CR>", { desc = "Toggle spell check" })
map("n", "<C-\\><C-\\>", ":setlocal wrap!<CR>:setlocal wrap?<CR>", { desc = "Toggle line wrap" })
map("n", "<C-\\>:", ":setlocal cursorline!<CR>:setlocal cursorline?<CR>", { desc = "Toggle cursor line" })
map("n", "<C-\\>,", ":setlocal cursorcolumn!<CR>:setlocal cursorcolumn?<CR>", { desc = "Toggle cursor column" })
map("n", "<C-\\><C-]>", ":setlocal paste!<CR>:setlocal paste?<CR>", { desc = "Toggle paste mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

--[[ TODO migrate
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
    for [prefix,cmd] in [['<C-\>','setlocal'], ['<C-\><C-G>', 'set'] ]
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
--]]
