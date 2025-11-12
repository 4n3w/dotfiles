return {
  {
    "3rd/image.nvim",
    dependencies = {
      "leafo/magick", -- Lua ImageMagick bindings
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
      },
      max_width = 100,
      max_height = 12,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
    },
    config = function(_, opts)
      require("image").setup(opts)

      -- Add toggle keymap
      vim.keymap.set('n', '<leader>ti', function()
        local image = require("image")
        image.clear()
      end, { desc = 'Clear images' })

      vim.keymap.set('n', '<leader>tr', function()
        local image = require("image")
        -- Trigger a buffer reload to re-render images
        vim.cmd('edit!')
      end, { desc = 'Reload images' })
    end,
  },
}
