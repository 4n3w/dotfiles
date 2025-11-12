return {
  "tpope/vim-fugitive",
  cmd = {
    "G",
    "Git",
    "Gdiffsplit",
    "Gread",
    "Gwrite",
    "Ggrep",
    "GMove",
    "GDelete",
    "GBrowse",
    "GRemove",
    "GRename",
    "Glgrep",
    "Gedit"
  },
  ft = {"fugitive"},
  config = function()
    -- Keybindings for fugitive
    vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Git status' })
    vim.keymap.set('n', '<leader>gc', function()
      vim.cmd('terminal export GPG_TTY=$(tty) && git commit')
      vim.cmd('startinsert')
    end, { desc = 'Git commit' })
    vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'Git push' })
    vim.keymap.set('n', '<leader>gl', ':Git log --oneline<CR>', { desc = 'Git log' })
    vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git blame' })
    vim.keymap.set('n', '<leader>gd', ':Gdiffsplit<CR>', { desc = 'Git diff' })
    vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { desc = 'Git add current file' })
  end,
}
