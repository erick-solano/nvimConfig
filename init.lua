
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
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/luukvbaal/statuscol.nvim.git',
  'https://github.com/lukas-reineke/indent-blankline.nvim.git',
  'https://github.com/nvim-mini/mini.surround.git',
  "https://github.com/sphamba/smear-cursor.nvim",
  "https://github.com/sindrets/diffview.nvim.git",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/ibhagwan/fzf-lua.git",
  "https://github.com/stevearc/oil.nvim.git",
  "https://github.com/mason-org/mason.nvim.git",
  "https://github.com/mason-org/mason-lspconfig.nvim.git",
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
local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.diagnostic.config({ update_in_insert = true })
vim.lsp.config("*", {
  capabilities = capabilities
})


-- Only make gd keybind if attatched to lsp.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
  end,

})

-- Diagnostics keymap
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent = true, desc = "Hover Error/Warning Info" })

--vim.keymap.set('n', 'gd', function()
--  vim.lsp.buf.definition()
--end, {silent = true, desc = "Go to Definition" })
-- ============================================================ 
-- mini-ssurround (custom "," mappings instead of default "s")
-- ============================================================

local surround = require('mini.surround').setup({
mappings = {
    add = '<leader>sa', -- Add surrounding in Normal and Visual modes
    delete = '<leader>sd', -- Delete surrounding
    find = '<leader>sf', -- Find surrounding (to the right)
    find_left = '<leader>sF', -- Find surrounding (to the left)
    highlight = '<leader>sh', -- Highlight surrounding
    replace = '<leader>sr', -- Replace surrounding
  },
})

-- ============================================================
-- yank highlight
-- ============================================================
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
  end,
})
vim.opt.clipboard = "unnamedplus"

-- ============================================================
-- Blink.cmp configuration
-- ============================================================
local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  keymap = {
  preset = 'default',
  ['<Tab>'] = { 'select_and_accept', 'fallback'},
},
  completion = { documentation = { auto_show = true }, menu = { auto_show = true }, accept = {auto_brackets = { enabled = true }}},
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer'}},
  fuzzy = { implementation = "prefer_rust" },

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
local oil = require("oil").setup({
  view_options = {
    show_hidden = true
  }
})
vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- ============================================================
-- Mason (package management for LSPs, formatters, etc)
-- ============================================================
local mason = require("mason").setup({
})
local mason_lspconfig = require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "lua_ls","pyright" },
    automatic_enable = true,
}
