return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      git = {
        enable = true,
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        -- Load default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Custom mapping: <leader>cd to change working directory and open folder as project
        vim.keymap.set('n', '<leader>cd', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.type == 'directory' then
            -- Change working directory
            vim.cmd('cd ' .. vim.fn.fnameescape(node.absolute_path))
            -- Close nvim-tree and reopen at new root
            api.tree.change_root(node.absolute_path)
            print('Opened project: ' .. node.absolute_path)
          elseif node and node.type == 'file' then
            -- If it's a file, cd to its parent directory
            local parent = vim.fn.fnamemodify(node.absolute_path, ':h')
            vim.cmd('cd ' .. vim.fn.fnameescape(parent))
            api.tree.change_root(parent)
            print('Opened project: ' .. parent)
          end
        end, { buffer = bufnr, desc = 'Open directory as project' })
      end,
    }
    -- Keybindings
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true, desc = 'Toggle file tree' })
    vim.keymap.set('n', '<leader>o', ':NvimTreeFocus<CR>', { silent = true, desc = 'Focus file tree' })
  end,
}
