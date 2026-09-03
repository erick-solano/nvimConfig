
-- PACKAGE MANAGEMENT (vim.pack)
-- ============================================================
-- add packages
vim.pack.add({
  'https://github.com/folke/flash.nvim.git',
  "https://github.com/ibhagwan/fzf-lua.git",
})

-- ============================================================
-- Basic Settings
-- ============================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"

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
-- LINE NUMBERS / SIGN COLUMN
-- ============================================================
vim.opt.number = true
vim.opt.relativenumber = true
-- ============================================================
-- INDENTATION / TABS
-- ============================================================

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.scrolloff = 8

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
