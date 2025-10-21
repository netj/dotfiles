-- Set leader key to Space. MUST be done before any <leader> mappings are used.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "nvchad.options"

local opt = vim.opt

opt.backspace = { "indent", "eol", "start" }
opt.autoindent = true
opt.copyindent = true
opt.preserveindent = true
opt.backup = false
opt.history = 1024
opt.ruler = true
opt.showcmd = true
opt.showmode = true
opt.title = true
opt.mouse = "a"
opt.clipboard = ""
opt.wrap = false
opt.scrolloff = 2
opt.modeline = true
opt.modelines = 5

opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.encoding = "utf-8"
opt.fileencodings = { "ucs-bom", "utf-8", "korea" }

opt.softtabstop = 4
opt.tabstop = 8
opt.shiftwidth = 4
opt.expandtab = true
opt.listchars = { tab = ">.", eol = "$" }

opt.wildmode = "list:full"
opt.wildchar = 9
if vim.fn.has "wildignorecase" == 1 then
  opt.wildignorecase = true
end

opt.suffixes:remove ".h"
opt.suffixes:append {
  ".o",
  ".d",
  ".a",
  ".class",
  "#",
  ".hi",
  ".cmi",
  ".cmo",
  ".cmx",
  ".cma",
  ".cmxa",
  ".blg",
  ".annot",
  "DS_Store",
}

local data_dir = vim.fn.stdpath "data"
opt.directory = { data_dir .. "/swap//", "." }
opt.undodir = { data_dir .. "/undo//", "." }

if vim.fn.has "syntax" == 1 then
  vim.cmd "syntax on"
  opt.hlsearch = true
end

opt.guifont = "EnvyCodeR Nerd Font:h13"
