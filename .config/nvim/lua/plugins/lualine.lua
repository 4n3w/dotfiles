return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'rose-pine',
        component_separators = { left = '', right = '' },
        section_separators = { left = '\u{e0b4}', right = '\u{e0b6}' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,  -- Single status line across all windows
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {
          {
            'mode',
            separator = { left = '\u{e0b6}', right = '\u{e0b4}' },
            right_padding = 2,
          },
        },
        lualine_b = {
          {
            'branch',
            separator = { left = '\u{e0b6}', right = '\u{e0b4}' },
          },
          'diff',
          'diagnostics'
        },
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {
          {
            'progress',
            separator = { left = '\u{e0b6}', right = '\u{e0b4}' },
          }
        },
        lualine_z = {
          {
            'location',
            separator = { left = '\u{e0b6}', right = '\u{e0b4}' },
            left_padding = 2,
          },
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  end,
}
