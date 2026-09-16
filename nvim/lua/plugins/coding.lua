return {
  -- JSX/TSXで開始タグを編集すると終了タグも自動で追従する
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- Treesitter に必要なパーサを web 開発向けに追加
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "typescript",
        "tsx",
        "css",
        "scss",
        "html",
        "json",
        "graphql",
        "prisma",
      })
    end,
  },
}
