return {
  "tpope/vim-fugitive",
  lazy = false,
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
    vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { desc = 'Git add current file' })
    vim.keymap.set('n', '<leader>gr', ':Git pull --rebase --autostash<CR>', { desc = 'Git pull rebase autostash' })
    vim.keymap.set('n', '<leader>g+', ':Git stash pop<CR>', { desc = 'Git stash pop' })
    vim.keymap.set('n', '<leader>g-', ':Git stash drop<CR>', { desc = 'Git stash drop' })
    vim.api.nvim_create_user_command('GitAcceptTheirs', function()
      vim.cmd('!git diff --name-only --diff-filter=U | xargs git checkout --theirs && git diff --name-only --diff-filter=U | xargs git add')
      vim.cmd('Git') -- Refresh fugitive status
    end, {})
    vim.keymap.set('n', '<leader>gt', ':GitAcceptTheirs<CR>', { desc = 'Accept Theirs for all conflicts'})
    vim.keymap.set('n', '<leader>gu', ':Git restore --staged %<CR>', { desc = 'Git unstage current file' })
    vim.keymap.set('n', '<leader>gU', ':Git restore %<CR>', { desc = 'Git restore current file (discard changes)' })
  end,
}
