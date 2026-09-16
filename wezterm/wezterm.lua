local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true

----------------------------------------------------
-- Windows 固有設定
----------------------------------------------------
-- 起動シェル（好みで切り替え）
config.default_prog = { "powershell.exe", "-NoLogo" }
-- PowerShell 7 を使う場合
-- config.default_prog = { "pwsh.exe", "-NoLogo" }
-- WSL を使う場合
-- config.default_domain = "WSL:Ubuntu"

-- フォント（日本語フォールバック付き）
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"BIZ UDGothic",
	"Meiryo",
})

-- 背景の透過とぼかし（macOS の macos_window_background_blur の代わり）
-- "Acrylic" / "Mica" / "Tabbed" / "Disable" から選択
config.win32_system_backdrop = "Acrylic"
config.window_background_opacity = 0.3
----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
-- Windowsでは "RESIZE" のみだとウィンドウをドラッグで移動しにくいため、
-- タブバー上に最小化/最大化/閉じるボタンを統合する
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
-- (INTEGRATED_BUTTONS を使う場合、false にしておくとウィンドウ移動が常に可能)
config.hide_tab_bar_if_only_one_tab = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
	colors = { "#000000" },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- タブの閉じるボタンを非表示
-- config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

-- タブの形をカスタマイズ
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"
	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end
	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
