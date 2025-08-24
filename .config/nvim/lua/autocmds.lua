require "nvchad.autocmds"

-- netj's custom autocmds from .vimrc
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- Restore cursor position (from .vimrc)
autocmd("BufReadPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Quickfix and location list auto-close with 'q' (from .vimrc)
autocmd("BufWinEnter", {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.tbl_contains({'quickfix', 'nofile'}, vim.bo.buftype) then
      vim.keymap.set('n', 'q', ':close<CR>', { buffer = true, silent = true })
    end
  end,
})

-- Git commit spell checking (from .vimrc)
autocmd("FileType", {
  group = augroup,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Crontab special handling (from .vimrc)
autocmd("FileType", {
  group = augroup,
  pattern = "crontab",
  callback = function()
    vim.opt_local.backup = false
    vim.opt_local.writebackup = false
  end,
})

-- Terminal mode settings (Neovim specific)
autocmd("TermOpen", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.cmd('startinsert')
  end,
})

-- Highlight yanked text (Neovim feature)
autocmd("TextYankPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 300 })
  end,
})

-- Man page navigation (from .vimrc)
autocmd("FileType", {
  group = augroup,
  pattern = "man",
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>q', { buffer = true })
  end,
})
