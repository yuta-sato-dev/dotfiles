local wezterm = require("wezterm")
local act = wezterm.action

-- Windows では Win(SUPER)キーの多くがOSに予約されているため、
-- macOS の Cmd 系ショートカットは Ctrl+Shift に置き換える
local MOD = "CTRL|SHIFT"

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

local keys = {
  {
    -- workspaceの切り替え
    key = "w",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
  },
  {
    -- workspaceの名前変更
    key = "$",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine({
      description = "(wezterm) Set workspace title:",
      action = wezterm.action_callback(function(win, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  {
    -- workspaceの新規作成
    key = "W",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine({
      description = "(wezterm) Create new workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
  },
  -- コマンドパレット表示 (Cmd+p → Ctrl+Shift+p)
  { key = "p", mods = MOD, action = act.ActivateCommandPalette },
  -- Tab移動
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
  -- Tab入れ替え
  { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
  -- Tab新規作成 (Cmd+t → Ctrl+Shift+t)
  { key = "t", mods = MOD, action = act.SpawnTab("CurrentPaneDomain") },
  -- Tabを閉じる (Cmd+w → Ctrl+Shift+w)
  { key = "w", mods = MOD, action = act.CloseCurrentTab({ confirm = true }) },

  -- 画面フルスクリーン切り替え
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

  -- コピーモード
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  -- コピー (Cmd+c → Ctrl+Shift+c ※Ctrl+c はプロセス中断に使うため)
  { key = "c", mods = MOD, action = act.CopyTo("Clipboard") },
  -- 貼り付け (Cmd+v → Ctrl+Shift+v)
  { key = "v", mods = MOD, action = act.PasteFrom("Clipboard") },

  -- Pane作成 leader + r or d
  { key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- Paneを閉じる leader + x
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  -- Pane移動 leader + hlkj
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  -- Pane選択
  { key = "[", mods = "CTRL|SHIFT", action = act.PaneSelect },
  -- 選択中のPaneのみ表示
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  -- フォントサイズ切替（JIS/USどちらでも効くよう複数登録）
  { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "+", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = ";", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  -- フォントサイズのリセット
  { key = "0", mods = "CTRL", action = act.ResetFontSize },
  -- ファイル名検索 (Ctrl+p)
  { key = "p", mods = "CTRL", action = act.SpawnCommandInNewTab({ args = { "fzf" } }) },
  -- ファイル内テキスト検索 (Ctrl+f)
  { key = "f", mods = "CTRL", action = act.SpawnCommandInNewTab({ args = { "bash", "-c", "rg --line-number . | fzf" } }) },
  -- 設定再読み込み
  { key = "r", mods = MOD, action = act.ReloadConfiguration },
  -- キーテーブル用
  { key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
  },
}

-- タブ切替 (Cmd+数字 → Alt+数字)
for i = 1, 8 do
  table.insert(keys, { key = tostring(i), mods = "ALT", action = act.ActivateTab(i - 1) })
end
table.insert(keys, { key = "9", mods = "ALT", action = act.ActivateTab(-1) })

return {
  keys = keys,
  -- キーテーブル
  -- https://wezfurlong.org/wezterm/config/key-tables.html
  key_tables = {
    -- Paneサイズ調整 leader + s
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
      -- Enter / Escape で終了
      { key = "Enter", action = "PopKeyTable" },
      { key = "Escape", action = "PopKeyTable" },
    },
    activate_pane = {
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
    -- copyモード leader + [
    copy_mode = {
      -- 移動
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      -- 最初と最後に移動
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      -- 左端に移動
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      -- 単語ごと移動
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      -- ジャンプ機能 t f
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      -- 一番下へ / 一番上へ
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      -- viewport
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      -- スクロール
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      -- 範囲選択モード
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      -- コピー
      { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },
      -- コピーモードを終了
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }),
      },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    },
  },
}