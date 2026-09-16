return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night", -- WezTermの "Tokyo Night" と統一
      transparent = false,
      styles = {
        comments = { italic = true },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
