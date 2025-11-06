-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab settings - use spaces instead of tabs
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.tabstop = 2           -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2        -- Number of spaces for auto-indent
vim.opt.softtabstop = 2       -- Number of spaces for <Tab> key
vim.opt.smartindent = true    -- Smart auto-indenting

-- Use system clipboard for yank/paste
vim.opt.clipboard = "unnamedplus"

-- Load plugins
require("lazy").setup("plugins")

-- Cmd-C to copy in visual mode (for terminal that sends <D-c>)
vim.keymap.set('v', '<D-c>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('v', '<D-x>', '"+d', { desc = 'Cut to clipboard' })
vim.keymap.set('n', '<D-v>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('i', '<D-v>', '<C-r>+', { desc = 'Paste from clipboard' })

-- Terminal keybindings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Go to right window' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })

-- Buffer navigation (see also the Telescope buffers below)
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<S-h>', ':bprev<CR>', { silent = true, desc = 'Previous buffer' })

-- Pick a buffer by typing its letter
vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { silent = true, desc = 'Pick buffer' })

-- Close all buffers except current
vim.keymap.set('n', '<leader>bo', ':BufferLineCloseOthers<CR>', { silent = true, desc = 'Close other buffers' })

-- Go to buffer by number
vim.keymap.set('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', { silent = true })
vim.keymap.set('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', { silent = true })
vim.keymap.set('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', { silent = true })
vim.keymap.set('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', { silent = true })
vim.keymap.set('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', { silent = true })
vim.keymap.set('n', '<leader>6', ':BufferLineGoToBuffer 6<CR>', { silent = true })
vim.keymap.set('n', '<leader>7', ':BufferLineGoToBuffer 7<CR>', { silent = true })
vim.keymap.set('n', '<leader>8', ':BufferLineGoToBuffer 8<CR>', { silent = true })
vim.keymap.set('n', '<leader>9', ':BufferLineGoToBuffer 9<CR>', { silent = true })

-- Telescope keybindings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', { desc = 'Recent files' })

-- Andrew's Weird Habits / A crutch for me!
vim.api.nvim_create_user_command('Q', function(opts)
  vim.cmd(opts.bang and 'q!' or 'q')
end, { bang = true })
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.opt.nrformats = { "bin", "hex", "octal" }

-- Toggle Relative line numbers
vim.keymap.set('n', '<leader>rn', ':set relativenumber!<CR>', { desc = 'Toggle relative numbers' })

-- Auto enter insert mode when entering terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Auto-open nvim-tree when opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- Check if the argument is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if directory then
      -- Change to the directory
      vim.cmd.cd(data.file)

      -- Close the alpha dashboard if it's open
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, 'filetype') == 'alpha' then
          vim.api.nvim_buf_delete(buf, {force = true})
        end
      end

      -- Open nvim-tree
      require("nvim-tree.api").tree.open()
    end
  end
})

-- Telescope: find directories only in current project
vim.keymap.set('n', '<leader>fd', function()
  require('telescope.builtin').find_files({
    prompt_title = 'Find Directories',
    find_command = {'fd', '--type', 'd', '--hidden', '--exclude', '.git'},
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      -- Override default selection to focus nvim-tree on the directory
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Change to directory and update nvim-tree
        vim.cmd('cd ' .. vim.fn.fnameescape(selection.path))
        require('nvim-tree.api').tree.change_root(selection.path)
        require('nvim-tree.api').tree.focus()
        print('Opened project: ' .. selection.path)
      end)

      return true
    end
  })
end, { desc = 'Find directories' })

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})
