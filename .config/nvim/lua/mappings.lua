require "nvchad.mappings"

-- netj's custom mappings from .vimrc
local map = vim.keymap.set

-- NvChad defaults we'll keep
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Essential mappings from .vimrc
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })  -- Original .vimrc mapping

-- Don't use Ex mode, use Q for formatting (from .vimrc)
map("n", "Q", "gq", { desc = "Format text" })

-- Arrows for moving cursor based on displayed lines (from .vimrc)
map("n", "<Up>", function() return vim.v.count == 0 and "gk" or "<Up>" end, { expr = true })
map("n", "<Down>", function() return vim.v.count == 0 and "gj" or "<Down>" end, { expr = true })
map("n", "<Home>", function() return vim.v.count == 0 and "g0" or "<Home>" end, { expr = true })
map("n", "<End>", function() return vim.v.count == 0 and "g$" or "<End>" end, { expr = true })

-- Alt+Left/Right for word movement (from .vimrc)
map({"n", "i", "v"}, "<M-Left>", "<C-\\><C-N>b")
map({"n", "i", "v"}, "<M-Right>", "<C-\\><C-N>w")

-- Toggle hlsearch (from .vimrc)
map("n", "<Space>*", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quick fix and location list (from .vimrc)
map("n", "<Space>q", ":copen<CR>", { desc = "Open quickfix" })
map("n", "<Space>l", ":lopen<CR>", { desc = "Open location list" })

-- Selecting right after pasting text (from .vimrc)
map("n", "gp", function()
  return "p`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
end, { expr = true, desc = "Paste and select" })
map("n", "gP", function()
  return "P`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
end, { expr = true, desc = "Paste before and select" })

-- Git shortcuts (if fugitive is available)
map("n", "<Space>gg", ":Git<CR>", { desc = "Git status" })
map("n", "<Space>gd", ":Gdiff<CR>", { desc = "Git diff" })
map("n", "<Space>gD", ":Gdiff HEAD<CR>", { desc = "Git diff HEAD" })
map("n", "<Space>gb", ":Git blame<CR>", { desc = "Git blame" })
map("n", "<Space>gl", ":Glog<CR>:copen<CR>", { desc = "Git log" })
map("n", "<Space>ge", ":Gedit<CR>", { desc = "Git edit" })

-- Terminal mappings (Neovim specific)
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-v><Esc>", "<Esc>", { desc = "Send escape to terminal" })

-- Buffer and file operations (essential from .vimrc workflow)
map("n", "<Space>f", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<Space>F", ":Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<Space>b", ":Telescope buffers<CR>", { desc = "Find buffers" })

-- Continue editing in external editor (from .vimrc)
if vim.fn.executable("code") == 1 then
  map("n", "<Space>j", function()
    local file = vim.fn.expand("%")
    local line = vim.fn.line(".")
    vim.cmd("silent exec ':!code --goto " .. file .. ":" .. line .. "'")
  end, { desc = "Open in VS Code" })
end
