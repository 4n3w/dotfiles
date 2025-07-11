return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      
      -- Basic telescope setup
      telescope.setup({})
      
      -- Keybindings
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
      
      -- Project/directory finder that actually works
      vim.keymap.set('n', '<leader>fd', function()
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local conf = require('telescope.config').values
        
        pickers.new({}, {
          prompt_title = "Open Project Directory",
          finder = finders.new_oneshot_job({ "find", ".", "-type", "d", "-name", ".git", "-exec", "dirname", "{}", ";" }, {
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry,
                ordinal = entry,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              
              -- Change directory and open file tree
              vim.cmd('cd ' .. vim.fn.fnameescape(selection.value))
              vim.cmd('NvimTreeClose')
              vim.cmd('NvimTreeOpen')
              
              print("Opened project: " .. selection.value)
            end)
            return true
          end,
        }):find()
      end, { desc = 'Find and open project directories' })
      
      -- Alternative: simple directory browser
      vim.keymap.set('n', '<leader>fp', function()
        builtin.find_files({
          prompt_title = "Browse Directories",
          cwd = vim.fn.expand("~"),
          hidden = false,
          find_command = { "find", ".", "-type", "d", "-maxdepth", "3" },
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              
              vim.cmd('cd ' .. vim.fn.fnameescape(selection.path or selection.value))
              vim.cmd('NvimTreeClose')
              vim.cmd('NvimTreeOpen')
              
              print("Changed to: " .. (selection.path or selection.value))
            end)
            return true
          end,
        })
      end, { desc = 'Browse and open directories' })
    end,
  }
}
