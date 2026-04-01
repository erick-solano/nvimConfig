vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })
--add packages

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/folke/flash.nvim.git',
  'https://github.com/catppuccin/nvim.git',
  'https://github.com/folke/which-key.nvim.git',
  'https://github.com/nvim-telescope/telescope.nvim.git',
  'https://github.com/nvim-lua/plenary.nvim.git',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/luukvbaal/statuscol.nvim.git',
  'https://github.com/lukas-reineke/indent-blankline.nvim.git',
})


-- Flash.nvim with red labels
local flash = require("flash")



-- 's' in normal, visual, operator-pending
vim.keymap.set({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash jump" })

-- 'S' in normal mode → multi-window jump
vim.keymap.set("n", "S", function()
  flash.jump({ search = { multi_window = true } })
end, { desc = "Flash jump across windows" })


--Change Theme to Mocha flavor of catppuccin
vim.g.catppuccin_flavour = "mocha"
vim.cmd([[colorscheme catppuccin]])
--Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
--Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

--Treesitter
vim.opt.foldlevel = 99
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

--CMP setup: 
--autocomplete = false, -- manual trigger only
local cmp = require("cmp")
cmp.setup({
  completion = {
    autocomplete = { cmp.TriggerEvent.TextChanged },  -- auto popup on typing
  },

  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),  -- Enter confirms selected item
    ['<C-e>'] = cmp.mapping.abort(),                     -- Ctrl+e cancels menu
    ['<Tab>'] = cmp.mapping.select_next_item(),          -- optional Tab navigation
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  },

  sources = {
    { name = 'buffer' },
    { name = 'path' },
  },
})
-- Subtle yank highlight like LazyVim
vim.api.nvim_set_hl(0, 'YankHighlight', { bg = '#ff966c', fg = nil })  -- light yellow background, keep text color
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })
  end
})



-- Set the highlight for Flash labels (keys to press) Must be here because theme messes with the labels
vim.api.nvim_set_hl(0, "FlashLabel", { 
  fg = "#FFFFFF", bg = "#ff017c", bold = true 
})
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
vim.opt.number=true
vim.opt.relativenumber=true
vim.opt.signcolumn="yes"
require("ibl").setup()
