-- 背景透過
local function set_transparent()
	local groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"LineNr",
		"CursorLineNr",
		"EndOfBuffer",
		"StatusLine",
		"StatusLineNC",
		"TabLine",
		"TabLineFill",
		"WinSeparator",
		"FoldColumn",
		-- Neo-tree
		"NeoTreeNormal",
		"NeoTreeNormalNC",
		"NeoTreeEndOfBuffer",
	}
	for _, g in ipairs(groups) do
		-- 既存の設定（文字色など）を残して背景だけ透過
		local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
		hl.bg = nil
		hl.ctermbg = nil
		vim.api.nvim_set_hl(0, g, hl)
	end
end

-- カラースキームを変更しても透過が維持されるようにする
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparent })
set_transparent()

-- 補完メニューやフロートウィンドウを少し透かす（0〜100）
vim.opt.pumblend = 10
vim.opt.winblend = 10

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
