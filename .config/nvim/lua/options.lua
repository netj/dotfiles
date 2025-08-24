require "nvchad.options"

-- netj's custom options from .vimrc
local opt = vim.opt
local g = vim.g

-- Basic editor settings (from .vimrc)
opt.autoindent = true
opt.copyindent = true
opt.preserveindent = true
opt.backup = false
opt.writebackup = false
opt.history = 1024
opt.ruler = true
opt.showcmd = true
opt.title = true
opt.mouse = "a"
opt.clipboard = ""  -- Don't use system clipboard by default
opt.wrap = false  -- No line wrapping
opt.scrolloff = 2
opt.modeline = true
opt.modelines = 5

-- Search settings (from .vimrc)
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Tab settings (from .vimrc)
opt.softtabstop = 4
opt.tabstop = 8
opt.shiftwidth = 4
opt.expandtab = true
opt.listchars = { tab = ">.", eol = "$" }

-- Wildmode settings (from .vimrc)
opt.wildmode = "list:full"
opt.wildignorecase = true

-- Swap and undo directories (adapted from .vimrc)
local data_dir = vim.fn.stdpath("data")
local tmp_dir = data_dir .. "/tmp"
if vim.fn.isdirectory(tmp_dir) == 0 then
  vim.fn.mkdir(tmp_dir, "p")
end
opt.directory = { tmp_dir .. "//", "." }
opt.undodir = { tmp_dir .. "//", "." }
opt.undofile = true

-- Neovim-specific enhancements
opt.updatetime = 300
opt.timeoutlen = 400
opt.conceallevel = 0  -- Don't conceal markdown, etc.

-- Global variables from .vimrc
g.is_bash = 1  -- Use bash highlighting by default
