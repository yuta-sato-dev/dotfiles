-- Options は lazy.nvim の起動前に自動で読み込まれる
-- LazyVim 標準のデフォルトはこちら:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Web開発 (JS/TS/React) は2スペースインデントが一般的
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- 見た目・操作性
opt.relativenumber = true
opt.number = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true

-- ファイル・バックアップ
opt.undofile = true
opt.swapfile = false
opt.updatetime = 200

-- 検索
opt.ignorecase = true
opt.smartcase = true
