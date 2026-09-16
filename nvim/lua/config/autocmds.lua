-- Autocmds は VeryLazy イベントで自動読み込みされる
-- LazyVim 標準のデフォルトはこちら:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("WebDevConfig", { clear = true })

-- .mjs / .cjs も javascript として認識させる
vim.filetype.add({
  extension = {
    mjs = "javascript",
    cjs = "javascript",
  },
})

-- 保存時にファイル末尾の余分な空行を削除
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\n\+\%$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
