require("nvchad.configs.lspconfig").defaults()


      local lspconfig = require('lspconfig')

      lspconfig.lua_ls.setup ({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.clangd.setup ({})
      lspconfig.eslint.setup ({})
      lspconfig.rome.setup ({})
      lspconfig.pyre.setup ({})
      lspconfig.pyre.setup ({})


      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()

          vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

-- local servers = { "html", "cssls" }
-- vim.lsp.enable(servers)

local servers = {
  html = {},
  awk_ls = {},
  bashls = {},

  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          typeCheckingMode = "basic",
        },
      },
    },
  },
}

-- vim.lsp.enable("")

-- read :h vim.lsp.config for changing options of lsp servers 

for name, opts in pairs(servers) do
  vim.lsp.enable(name)  -- nvim v0.11.0 or above required
  vim.lsp.config(name, opts) -- nvim v0.11.0 or above required
end

-- This function will be called for every buffer that gets an LSP attached.
-- This is where we will define our keymaps.
local on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Binds a key to a command in the current buffer, only when the LSP is active.
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
  end

  -- Your desired navigation keymaps
  map('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  map('n', 'gr', vim.lsp.buf.references, '[G]oto [R]eferences')
  map('n', '<leader>th', vim.lsp.buf.type_hierarchy, '[T]ype [H]ierarchy')

  -- Keymaps for navigating symbol occurrences (your <Space>n / <Space>p request)
  -- The LSP highlights all occurrences of the symbol under your cursor.
  -- These keymaps jump between those highlighted symbols.
  map('n', '<Space>n', function()
    vim.lsp.buf.document_highlight()
    vim.cmd.normal { ']c', bang = true } -- ']c' is a motion to jump to the next change/highlight
  end, 'Next Occurrence')

  map('n', '<Space>p', function()
    vim.lsp.buf.document_highlight()
    vim.cmd.normal { '[c', bang = true } -- '[c' is a motion to jump to the previous change/highlight
  end, 'Previous Occurrence')

  -- Other useful LSP keymaps
  map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  map('n', 'gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  map('n', '<leader>sh', vim.lsp.buf.signature_help, '[S]ignature [H]elp')
  map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
end

-- -- Tell lspconfig to set up the servers that mason installs
-- local lspconfig = require('lspconfig')
-- local capabilities = require('cmp_nvim_lsp').default_capabilities() -- If you use a completion plugin

-- Loop through the servers installed by mason-lspconfig and attach the keymaps
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Set keymaps for Telescope
local map = vim.keymap.set
-- map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = '[F]ind [F]iles' })
-- map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = '[F]ind by [G]rep' })
-- map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = '[F]ind [B]uffers' })
map('n', '<leader><leader>', '<cmd>Telescope resume<cr>', { desc = 'Resume Telescope' })
map('n', '<leader>fs', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', { desc = 'Find Dynamic Workspace Symbols' })
map('n', '<leader>fS', '<cmd>Telescope lsp_document_symbols<cr>', { desc = '[F]ind [S]ymbols in Document' })
map('n', '<leader>fss', '<cmd>Telescope lsp_workspace_symbols<cr>', { desc = '[F]ind [S]ymbols in Workspace' })


-- This autocmd will restore cursor position on file open
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})
