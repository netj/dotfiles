return {
    { "tpope/vim-fugitive",
        lazy = false,
        keys = {
            { "<leader>G", "<cmd>Git<cr>", desc = "fugitive" },
        },
    },

    { "tpope/vim-rhubarb" }, -- GitHub integration

    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit" },
            -- { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    -- {
    --     "kdheepak/lazygit.nvim",
    --     lazy = false,
    --     cmd = {
    --         "LazyGit",
    --         "LazyGitConfig",
    --         "LazyGitCurrentFile",
    --         "LazyGitFilter",
    --         "LazyGitFilterCurrentFile",
    --     },
    --     -- optional for floating window border decoration
    --     dependencies = {
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-lua/plenary.nvim",
    --     },
    --     config = function()
    --         require("telescope").load_extension("lazygit")
    --     end,
    -- },
    -- autocmd BufEnter * :lua require('lazygit.utils').project_root_dir()


  -- -- Git plugins (NvChad has gitsigns, but these add more git functionality)
  -- {
  --   "junegunn/gv.vim", -- Modern alternative to gitv
  --   cmd = "GV",
  --   config = function()
  --     vim.keymap.set("n", "<Space>gv", ":GV --all<CR>")
  --     vim.keymap.set("n", "<Space>gV", ":GV! --all<CR>")
  --     vim.keymap.set("v", "<Space>gV", ":GV! --all<CR>")
  --   end,
  -- },

}
