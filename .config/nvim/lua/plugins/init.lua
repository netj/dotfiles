return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  -- ========== MIGRATED FROM VIM BUNDLE.VIM ==========

  -- Color schemes (additional to base46)
  {
    "w0ng/vim-hybrid",
    config = function()
      vim.g.enable_bold_font = 1
      vim.g.enable_italic_font = 1
      vim.g.hybrid_transparent_background = 1
    end,
  },
  {
    "nanotech/jellybeans.vim",
    config = function()
      vim.g.jellybeans_overrides = {
        Todo = { guifg = '101010', guibg = 'fad07a', ctermfg = 'Black', ctermbg = 'Yellow', attr = 'bold' },
      }
    end,
  },
  { "tomasr/molokai" },
  { "chriskempson/vim-tomorrow-theme" },

  -- Productivity plugins
  {
    "tyru/open-browser.vim",
    config = function()
      vim.g.netrw_nogx = 1
      vim.keymap.set("n", "gx", "<Plug>(openbrowser-smart-search)")
      vim.keymap.set("v", "gx", "<Plug>(openbrowser-smart-search)")
    end,
  },

  -- {
  --   "simnalamburt/vim-mundo", -- Modern alternative to Gundo
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   cmd = { "MundoToggle" },
  --   config = function()
  --     vim.g.mundo_close_on_revert = 1
  --     vim.keymap.set("n", "<Space>u", ":MundoToggle<CR>")
  --   end,
  -- },

  -- -- Buffer explorer (NvChad has telescope for this)
  -- {
  --   "jlanzarotta/bufexplorer",
  --   cmd = { "BufExplorer", "BufExplorerHorizontalSplit" },
  --   config = function()
  --     vim.keymap.set("n", "<Space>b", ":BufExplorerHorizontalSplit<CR>")
  --   end,
  -- },

  -- Tagbar (symbols outline)
  {
    "preservim/tagbar",
    cmd = { "TagbarToggle", "TagbarOpenAutoClose" },
    config = function()
      vim.keymap.set("n", "<Space>t", ":TagbarOpenAutoClose<CR>")
      vim.keymap.set("n", "<Space>T", ":TagbarToggle<CR>")
    end,
  },

  -- Search (ack/rg) - NvChad has telescope-live-grep
  -- {
  --   "mileszs/ack.vim",
  --   cmd = "Ack",
  --   config = function()
  --     if vim.fn.executable("rg") == 1 then
  --       vim.g.ackprg = "rg --vimgrep --smart-case"
  --     end
  --   end,
  -- },

  -- Unimpaired - useful bracket mappings
  { "tpope/vim-unimpaired" },

  -- Exchange plugin
  { "tommcdo/vim-exchange" },

  -- Text manipulation
  { "godlygeek/tabular" }, -- Alternative to Align
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "tpope/vim-commentary" }, -- Note: NvChad might have comment.nvim
  { "bronson/vim-visual-star-search" },

  -- Motion plugins
  {
    "phaazon/hop.nvim", -- Modern alternative to EasyMotion
    branch = "v2",
    cmd = { "HopWord", "HopLine", "HopChar1", "HopChar2" },
    config = function()
      require("hop").setup()
      vim.keymap.set("n", "<Space>w", ":HopWord<CR>")
    end,
  },

  -- -- Rainbow parentheses (treesitter might handle this)
  -- {
  --   "HiPhish/rainbow-delimiters.nvim",
  --   event = "BufRead",
  --   config = function()
  --     local rainbow_delimiters = require("rainbow-delimiters")
  --     vim.g.rainbow_delimiters = {
  --       strategy = {
  --         [''] = rainbow_delimiters.strategy['global'],
  --       },
  --       query = {
  --         [''] = 'rainbow-delimiters',
  --       },
  --     }
  --   end,
  -- },

  -- Drawing
  { "vim-scripts/DrawIt", cmd = "DrawIt" },

  -- Mark plugin - text highlighting
  {
    "inkarkat/vim-mark",
    dependencies = { "inkarkat/vim-ingo-library" },
    config = function()
      vim.g.mwHistAdd = ''
      vim.g.mwAutoLoadMarks = 1
      vim.g.mwAutoSaveMarks = 1
      vim.opt.viminfo:append("!")
      vim.keymap.set("n", "<Space>m", "<Leader>m")
      vim.keymap.set("x", "<Space>m", "<Leader>m")
      vim.keymap.set("n", "<Space>M", "<Leader>n")
      vim.keymap.set("x", "<Space>M", "<Leader>n")
      vim.keymap.set("n", "<Space>n", "<Leader>*")
      vim.keymap.set("n", "<Space>N", "<Leader>/")
    end,
  },

  -- CamelCase motion
  {
    "bkad/CamelCaseMotion",
    config = function()
      vim.keymap.set("n", ",,", ",") -- recover default ,
      vim.keymap.set("x", ",,", ",")
      vim.keymap.set("o", ",,", ",")
    end,
  },

  -- Text objects and case conversion
  { "tpope/vim-abolish" },

  -- File system utilities
  { "tpope/vim-eunuch" },

  -- Tmux integration
  {
    "christoomey/vim-tmux-navigator",
    cond = function()
      return vim.env.TMUX ~= nil
    end,
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      -- Key mappings for tmux navigation
      vim.keymap.set("n", "<Esc><C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
      vim.keymap.set("n", "<Esc><C-j>", ":TmuxNavigateDown<CR>", { silent = true })
      vim.keymap.set("n", "<Esc><C-k>", ":TmuxNavigateUp<CR>", { silent = true })
      vim.keymap.set("n", "<Esc><C-l>", ":TmuxNavigateRight<CR>", { silent = true })
      vim.keymap.set("n", "<Esc><C-\\>", ":TmuxNavigatePrevious<CR>", { silent = true })
      -- Quick splits
      vim.keymap.set("n", "<Esc><C-v>", "<C-w>v", { silent = true })
      vim.keymap.set("n", "<Esc><C-s>", "<C-w>s", { silent = true })
    end,
  },

  {
    "preservim/vimux",
    cond = function()
      return vim.env.TMUX ~= nil
    end,
    config = function()
      vim.keymap.set("n", "<Esc><C-]>", ":wall|VimuxPromptCommand<CR>", { silent = true })
      vim.keymap.set("n", "<Esc><Return>", ":wall|VimuxRunLastCommand<CR>", { silent = true })
      vim.keymap.set("n", "<Esc><C-x>", ":VimuxInspectRunner<CR>", { silent = true })
      vim.keymap.set("n", "<Esc><C-z>", ":VimuxZoomRunner<CR>", { silent = true })
    end,
  },

  -- Git plugins (NvChad has gitsigns, but these add more git functionality)
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" }, -- GitHub integration
  {
    "junegunn/gv.vim", -- Modern alternative to gitv
    cmd = "GV",
    config = function()
      vim.keymap.set("n", "<Space>gv", ":GV --all<CR>")
      vim.keymap.set("n", "<Space>gV", ":GV! --all<CR>")
      vim.keymap.set("v", "<Space>gV", ":GV! --all<CR>")
    end,
  },

  -- Web/markup plugins
  { "tpope/vim-endwise" },
  {
    "rstacruz/sparkup",
    build = "cd vim && make",
    config = function()
      vim.g.sparkup = {
        lhs_expand = '<C-\\><C-e>',
        lhs_jump_next_empty_tag = '<C-\\><C-f>',
      }
    end,
  },
  { "sukima/xmledit" },
  { "tpope/vim-ragtag" },

  -- Language-specific plugins
  { "tpope/vim-markdown", ft = "markdown" },
  { "elzr/vim-json", ft = "json" },
  { "vito-c/jq.vim", ft = "jq" },
  { "tpope/vim-jdaddy", ft = "json" },
  { "GEverding/vim-hocon", ft = "hocon" },

  -- Programming language support
  { "leafgarland/typescript-vim", ft = "typescript" },
  { "ianks/vim-tsx", ft = { "typescript", "tsx" } },
  { "hashivim/vim-terraform", ft = "terraform" },
  { "kchmck/vim-coffee-script", ft = "coffee" },
  { "digitaltoad/vim-pug", ft = "pug" }, -- Modern jade.vim
  { "derekwyatt/vim-scala", ft = "scala" },
  { "vim-scripts/octave.vim--", ft = "octave" },
  { "nvie/vim-flake8", ft = "python" },
  { "tell-k/vim-autopep8", ft = "python" },
  { "cespare/vim-toml", ft = "toml" },

  -- Alternative file switching
  {
    "kana/vim-altr",
    config = function()
      vim.keymap.set("n", "<Space><Tab>", "<Plug>(altr-forward)")
      vim.keymap.set("n", "<Space><S-Tab>", "<Plug>(altr-backward)")
    end,
  },

  -- Local vimrc
  {
    "MarcWeber/vim-addon-local-vimrc",
    config = function()
      vim.g.local_vimrc = { names = { '.lvimrc', '.vimrc' }, hash_fun = 'LVRHashOfFile' }
    end,
  },

  -- Clipboard utilities
  { "vim-scripts/Decho" },

  -- File recovery
  { "chrisbra/Recover.vim" },

  -- Rename utility
  { "qpkorr/vim-renamer", cmd = "Renamer" },
}
