return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "python", "bash", "json", "yaml" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
