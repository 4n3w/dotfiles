return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Load your custom header
      local custom_header = require("purplepalms")

      -- Set your custom header
      dashboard.section.header = custom_header

      -- Set menu buttons
      dashboard.section.buttons.val = {
        dashboard.button("e", " 󰈔 [new file] ", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", " 󰈞 [find file home dir] ", ":cd $HOME | Telescope find_files<CR>"),
        dashboard.button("w", " 󰈞 [find file workspace] ", ":cd $HOME/workspace | Telescope find_files<CR>"),
	dashboard.button("p", " 󰉋 Open Project ", ":lua require('telescope.builtin').find_files({prompt_title='Open Project', finder=require('telescope.finders').new_oneshot_job({'find', vim.fn.expand('~/workspace'), '-type', 'd', '-maxdepth', '2', '-not', '-path', '*/.*'}, {entry_maker=function(entry) return {value=entry, display=vim.fn.fnamemodify(entry, ':t')..' ('..entry..')', ordinal=entry} end}), attach_mappings=function(prompt_bufnr, map) require('telescope.actions').select_default:replace(function() local selection=require('telescope.actions.state').get_selected_entry(); require('telescope.actions').close(prompt_bufnr); for _, buf in ipairs(vim.api.nvim_list_bufs()) do if vim.api.nvim_buf_get_option(buf, 'filetype')=='alpha' then vim.api.nvim_buf_delete(buf, {force=true}) end end; vim.cmd('cd '..vim.fn.fnameescape(selection.value)); vim.cmd('%bdelete'); vim.cmd('NvimTreeOpen'); vim.cmd('NvimTreeFocus'); print('Opened project: '..selection.value) end); return true end})<CR>"),
        dashboard.button("r", " 󰈙 [recent] ", ":Telescope oldfiles<CR>"),
        dashboard.button("h", " 󰻠 [htop] ", ":split | terminal htop<CR>"),
	dashboard.button("t", " 󰞷 [terminal] ", ":split | resize 10 | terminal<CR>"),
        dashboard.button("s", " ⚙ [settings] ", ":e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", " 󰈆 [exit]", ":qa<CR>"),
      }

      -- Recent files section
      local function get_recent_files()
        local oldfiles = {}
        local oldfiles_list = vim.v.oldfiles or {}
        local count = 0
        
        for _, file in ipairs(oldfiles_list) do
          if count >= 5 then break end
          
          if file and vim.fn.filereadable(file) == 1 then
            local filename = vim.fn.fnamemodify(file, ':t')
            local filepath = vim.fn.fnamemodify(file, ':~:h')
            if filepath == vim.fn.expand('~') then 
              filepath = '~' 
            else 
              filepath = vim.fn.fnamemodify(filepath, ':~')
            end
            
            table.insert(oldfiles, dashboard.button(
              tostring(count), 
              "  " .. filename .. "  " .. filepath .. " ",
              ":e " .. vim.fn.fnameescape(file) .. "<CR>"
            ))
            count = count + 1
          end
        end
        
        return oldfiles
      end

      -- Tao Te Ching quotes
      local tao_quotes = {
        "The journey of a thousand miles begins with one step.",
        "When I let go of what I am, I become what I might be.",
        "Nature does not hurry, yet everything is accomplished.",
        "He who knows that enough is enough will always have enough.",
        "The wise find pleasure in water; the virtuous find pleasure in hills.",
        "A good man bases his actions on himself; a bad man bases his actions on others.",
        "The sage does not attempt anything very big, and thus achieves greatness.",
        "Be content with what you have; rejoice in the way things are.",
        "If you correct your mind, the rest of your life will fall into place.",
        "The truth is not always beautiful, nor beautiful words the truth.",
        "Empty your mind, be formless, shapeless — like water.",
        "If you understand others you are smart. If you understand yourself you are illuminated.",
      }

      -- Get random quote
      math.randomseed(os.time())
      local random_quote = tao_quotes[math.random(#tao_quotes)]

      -- Set footer with quote
      dashboard.section.footer.val = {
        "",
        "~ " .. random_quote .. " ~"
      }

      -- Button colors
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#191724", bg = "#c4a7e7", bold = true })
      vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f6c177", bg = "#c4a7e7", bold = true })
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#9ccfd8", italic = true })  -- Rose Pine foam, italic

      
      -- Apply colors
      dashboard.section.buttons.opts = {
        hl = "AlphaButtons",
        hl_shortcut = "AlphaShortcut",
        cursor = 5,
        align_shortcut = "right",
        position = "center",
      }

      dashboard.section.footer.opts.hl = "AlphaFooter"

      -- Layout
      dashboard.config.layout = {
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        {
          type = "group",
          val = get_recent_files,
          opts = {
            hl = "AlphaButtons",
            hl_shortcut = "AlphaShortcut",
            spacing = 1,
          }
        },
        { type = "padding", val = 2 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  }
}

