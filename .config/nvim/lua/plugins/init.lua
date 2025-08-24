return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript",
        "python", "bash", "json", "yaml", "markdown"
      },
    },
  },

  -- Essential plugins from original .vim setup
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiff", "Glog", "Gedit", "Gread", "Gwrite" },
    keys = {
      { "<Space>gg", ":Git<CR>", desc = "Git status" },
      { "<Space>gd", ":Gdiff<CR>", desc = "Git diff" },
      { "<Space>gb", ":Git blame<CR>", desc = "Git blame" },
    },
  },

  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },

  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  {
    "tpope/vim-commentary",
    keys = {
      { "gc", mode = {"n", "v"}, desc = "Comment toggle" },
      { "gcc", desc = "Comment line" },
    },
  },

  {
    "tpope/vim-unimpaired",
    event = "VeryLazy",
  },

  {
    "tpope/vim-abolish",
    cmd = { "Abolish", "Subvert", "S" },
  },

  {
    "airblade/vim-gitgutter",
    event = "VeryLazy",
    config = function()
      vim.g.gitgutter_enabled = 1
      -- Key mappings
      vim.keymap.set('n', ']g', ':GitGutterNextHunk<CR>', { desc = 'Next hunk' })
      vim.keymap.set('n', '[g', ':GitGutterPrevHunk<CR>', { desc = 'Previous hunk' })
      vim.keymap.set('n', '<Space>gh', ':GitGutterPreviewHunk<CR>', { desc = 'Preview hunk' })
      vim.keymap.set('n', '[G', ':GitGutterStageHunk<CR>', { desc = 'Stage hunk' })
      vim.keymap.set('n', ']G', ':GitGutterUndoHunk<CR>', { desc = 'Undo hunk' })
    end,
  },

  -- Colorschemes from original setup
  {
    "w0ng/vim-hybrid",
    lazy = false,
    priority = 900,  -- Lower than NvChad themes but available
  },

  {
    "nanotech/jellybeans.vim",
    lazy = true,
    config = function()
      vim.g.jellybeans_overrides = {
        Todo = {
          guifg = '101010',
          guibg = 'fad07a',
          ctermfg = 'Black',
          ctermbg = 'Yellow',
          attr = 'bold'
        }
      }
    end,
  },

  {
    "tomasr/molokai",
    lazy = true,
  },

  -- Tmux integration (conditional on $TMUX)
  {
    "christoomey/vim-tmux-navigator",
    cond = vim.env.TMUX ~= nil,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window" },
    },
  },

  -- Useful utilities
  {
    "tyru/open-browser.vim",
    keys = {
      { "gx", "<Plug>(openbrowser-smart-search)", mode = {"n", "v"}, desc = "Open browser" },
    },
    config = function()
      vim.g.netrw_nogx = 1  -- Disable netrw's gx mapping
    end,
  },

  {
    "qpkorr/vim-renamer",
    cmd = "Renamer",
  },

  {
    "chrisbra/Recover.vim",
    event = "VeryLazy",
  },
}
