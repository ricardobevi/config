-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- ## OPTIONS ##
vim.opt.rtp:prepend(lazypath)

vim.opt.number = true
vim.opt.relativenumber = true

-- Settings for folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99 -- Start with all folds open

-- ## LAZY ##
-- Setup plugins
require("lazy").setup({
  -- Add the Tokyo Night colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        -- A list of parser names, or "all"
        -- For your notes.md file, `markdown` and `markdown_inline` are good choices
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- Enable syntax highlighting
        highlight = {
          enable = true,
        },
        folding = {
          enable = true,
        },
      })
    end,
  },
  -- Add the auto-save plugin
  {
    "pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        -- You can configure events triggers and conditions here
        trigger_events = { "InsertLeave", "TextChanged" } -- Save on leaving insert mode or when text changes
      })
    end,
  },
    -- Add neo-tree and its dependencies
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
   -- Add the terminal plugin
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- You can change the direction of the terminal here
        direction = "float", -- Other options: 'vertical', 'horizontal'
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', -- or latest stable
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
})

vim.cmd.colorscheme "tokyonight"

-- ## MAPPINGS ##
-- Set <space> as the leader key
-- MUST BE SET BEFORE THE FIRST MAPPING
vim.g.mapleader = ' '

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find Grep' })

-- Create a mapping for saving the file
-- 'n' means normal mode, <leader>w is the shortcut, :w<cr> is the command
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Write/save file', silent = true })
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle file explorer', silent = true })
vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>', { desc = 'Toggle terminal', silent = true })
-- Add this new mapping for exiting terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode', silent = true })
-- Add this new mapping for closing the terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:ToggleTerm<CR>', { desc = 'Close terminal', silent = true })
vim.keymap.set('n', '<leader>d', ":put ='# ' . strftime('%Y-%m-%d')<CR>", { desc = 'Insert date as title' })


