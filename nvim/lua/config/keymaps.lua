-- Keymaps は VeryLazy イベントで自動読み込みされる
-- LazyVim 標準のデフォルトはこちら:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- ウィンドウ間移動 (Ctrl+hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ移動" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ移動" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- ビジュアルモードで選択行を上下に移動
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "選択行を下へ移動" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "選択行を上へ移動" })

-- 保存 (ノーマル/インサート/ビジュアル共通)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "保存" })

-- ファイル内の全選択をやめて誤操作を防ぐ y/d をクリップボード連携に
map({ "n", "v" }, "<leader>y", '"+y', { desc = "システムクリップボードへコピー" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "システムクリップボードから貼り付け" })
