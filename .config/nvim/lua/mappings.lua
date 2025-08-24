require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>", { desc = "Alternative escape mapping" })

-- Format text with Q (similar to vim's gq)
map("n", "Q", "gq", { desc = "Format text" })

-- Search and quickfix window management
map("n", "<Space>*", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<Space>q", ":copen<CR>", { desc = "Open quickfix window" })
map("n", "<Space>l", ":lopen<CR>", { desc = "Open location list" })

-- Fix syntax highlighting
map("n", "<Space>s", ":syntax sync fromstart<CR>", { desc = "Fix syntax highlighting" })

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

-- Mode toggles with Ctrl-\
map("n", "<C-\\><Space>", ":setlocal list!<CR>:setlocal list?<CR>", { desc = "Toggle list mode" })
map("n", "<C-\\>1", ":setlocal number!<CR>:setlocal number?<CR>", { desc = "Toggle line numbers" })
map("n", "<C-\\>*", ":setlocal hlsearch!<CR>:setlocal hlsearch?<CR>", { desc = "Toggle search highlight" })
map("n", "<C-\\>=", ":setlocal spell!<CR>:setlocal spell?<CR>", { desc = "Toggle spell check" })
map("n", "<C-\\><C-\\>", ":setlocal wrap!<CR>:setlocal wrap?<CR>", { desc = "Toggle line wrap" })
map("n", "<C-\\>:", ":setlocal cursorline!<CR>:setlocal cursorline?<CR>", { desc = "Toggle cursor line" })
map("n", "<C-\\>,", ":setlocal cursorcolumn!<CR>:setlocal cursorcolumn?<CR>", { desc = "Toggle cursor column" })
map("n", "<C-\\><C-]>", ":setlocal paste!<CR>:setlocal paste?<CR>", { desc = "Toggle paste mode" })

-- Selecting after pasting
map("n", "gp", function()
  local regtype = vim.fn.getregtype()
  return "p`[" .. string.sub(regtype, 1, 1) .. "`]"
end, { expr = true, desc = "Paste and select" })

map("n", "gP", function()
  local regtype = vim.fn.getregtype()
  return "P`[" .. string.sub(regtype, 1, 1) .. "`]"
end, { expr = true, desc = "Paste before and select" })

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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
