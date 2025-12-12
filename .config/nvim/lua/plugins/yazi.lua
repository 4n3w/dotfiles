-- lua/plugins/yazi.lua
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>z", "<cmd>Yazi<cr>", desc = "Open yazi at current file" },
    { "<leader>Z", "<cmd>Yazi cwd<cr>", desc = "Open yazi in cwd" },
  },
  opts = {
    open_for_directories = true,
  },
}
