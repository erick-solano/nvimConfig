-- ============================================================
-- PACKAGE MANAGEMENT (vim.pack)
-- ============================================================
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site")
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

-- add packages
vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/folke/flash.nvim.git',
  'https://github.com/catppuccin/nvim.git',
  'https://github.com/folke/which-key.nvim.git',
  'https://github.com/nvim-lua/plenary.nvim.git',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/luukvbaal/statuscol.nvim.git',
  'https://github.com/lukas-reineke/indent-blankline.nvim.git',
  'https://github.com/kylechui/nvim-surround.git',
  'https://github.com/nvim-mini/mini.misc.git',
  "https://github.com/sphamba/smear-cursor.nvim",
  "https://github.com/sindrets/diffview.nvim.git",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/ibhagwan/fzf-lua.git",
  "https://github.com/stevearc/oil.nvim.git",
})

-- ============================================================
-- smear cursor
-- ============================================================
local cursor = require('smear_cursor')
cursor.setup({
  stiffness = 0.3,
  trailing_stiffness = 0.4,
  matrix_pixel_threshold = 0.5,
})

-- ============================================================
-- MINI.MISC
-- ============================================================
MiniMisc = require("mini.misc")
MiniMisc.setup()
MiniMisc.setup_auto_root({".git"})

-- ============================================================
-- COLORSCHEME (catppuccin)
-- ============================================================
-- Change Theme to Mocha flavor of catppuccin
vim.g.catppuccin_flavour = "mocha"
vim.cmd([[colorscheme catppuccin]])

-- ============================================================
-- FLASH.NVIM (with red labels)
-- ============================================================
local flash = require("flash")

-- 's' in normal, visual, operator-pending
vim.keymap.set({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash jump" })

-- 'S' in normal mode → multi-window jump
vim.keymap.set("n", "S", function()
  flash.jump({ search = { multi_window = true } })
end, { desc = "Flash jump across windows" })

-- Set the highlight for Flash labels (keys to press)
-- Must be here because theme messes with the labels
vim.api.nvim_set_hl(0, "FlashLabel", {
  fg = "#FFFFFF", bg = "#ff017c", bold = true
})

-- ============================================================
-- LEADER KEY
-- ============================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- ============================================================
-- FOLDING (treesitter-based)
-- ============================================================
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "2"
vim.opt.fillchars = {
    fold = "▸",
    foldopen = "▾",
    foldsep = "│",
}

-- ============================================================
-- LINE NUMBERS / SIGN COLUMN
-- ============================================================
vim.opt.number=true
vim.opt.relativenumber=true
vim.opt.signcolumn="yes"

-- ============================================================
-- INDENT-BLANKLINE
-- ============================================================
require("ibl").setup()

-- ============================================================
-- INDENTATION / TABS
-- ============================================================
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.scrolloff = 8

-- ============================================================
-- LSP (via nvim-cmp capabilities)
-- ============================================================
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lua LSP
vim.lsp.config('luals', {
  cmd = {'lua-language-server'},
  filetypes = {'lua'},
  root_markers = {'.luarc.json', '.luarc.jsonc', '.git'},
  capabilities = capabilities,
})

vim.diagnostic.config({ update_in_insert = true })
vim.lsp.enable('luals')

-- C/C++ LSP (clangd)
vim.lsp.config('clangd', {
  cmd = {'clangd'},
  filetypes = {'c', 'cpp'},
  root_markers = {'.git', 'compile_commands.json'}, capabilities = capabilities,
})
vim.diagnostic.config({ update_in_insert = true })
vim.lsp.enable('clangd')

-- Diagnostics keymap
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent = true, desc = "Hover Error/Warning Info" })

-- ============================================================
-- nvim-surround (custom "," mappings instead of default "s")
-- ============================================================
vim.g.nvim_surround_no_mappings = 1
vim.keymap.set("n", "y,", "<Plug>(nvim-surround-normal)", { remap = true, desc = "Surround add with ," })
vim.keymap.set("n", "y,,", "<Plug>(nvim-surround-normal-cur)", { remap = true, desc = "Surround current word/line with ," })

vim.keymap.set("n", "d,", "<Plug>(nvim-surround-delete)", { remap = true, desc = "Surround delete with ," })
vim.keymap.set("n", "c,", "<Plug>(nvim-surround-change)", { remap = true, desc = "Surround change with ," })

-- Visual mode
vim.keymap.set("x", ",", "<Plug>(nvim-surround-visual)", { remap = true, desc = "Surround visual selection with ," })

-- Insert mode (optional)
vim.keymap.set("i", "<C-g>,", "<Plug>(nvim-surround-insert)", { remap = true, desc = "Surround in insert mode with ," })

-- ============================================================
-- yank highlight
-- ============================================================
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
  end,
})

-- ============================================================
-- nvim-cmp (autocompletion)
-- ============================================================
local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),

    ['<CR>'] = cmp.mapping.confirm({
      select = true,
    }),
  }),

  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }
})

-- ============================================================
-- FLASH.NVIM (with red labels)
-- ============================================================
local flash = require("flash")

-- 's' in normal, visual, operator-pending
vim.keymap.set({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash jump" })

-- 'S' in normal mode → multi-window jump
vim.keymap.set("n", "S", function()
  flash.jump({ search = { multi_window = true } })
end, { desc = "Flash jump across windows" })

-- Set the highlight for Flash labels (keys to press)
-- Must be here because theme messes with the labels
vim.api.nvim_set_hl(0, "FlashLabel", {
  fg = "#FFFFFF", bg = "#ff017c", bold = true
})
-- ============================================================
-- LSP-CONFIG (Pre-set lsp configurations)
-- ============================================================
-- Lsps will not work unless specified here, and installed. 

-- ============================================================
-- diffview (for git conflicts) 
-- ============================================================

-- ============================================================
-- fzf-lua (Fuzzy-finder/grep)
-- ============================================================
local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>fg", function()
  fzf.live_grep_native()
end, { desc = "Search all files in working directory" }
)

vim.keymap.set("n", "<leader>ff", function()
  fzf.files()
end, { desc = "Find File by Name" }
)
vim.keymap.set("n", "<leader>fi", function()
  fzf.lgrep_curbuf()
end, { desc = "Find in File" }
)
-- ============================================================
-- oil.nvim (file editing/nav)
-- ============================================================
local oil = require("oil").setup()
vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open parent directory" })

