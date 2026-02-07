return {
  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('tokyonight').setup {
  --       styles = {},
  --     }
  --
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'
  --   end,
  -- },
  -- {
  --   'rose-pine/neovim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'rose-pine'
  --
  --     -- You can configure highlights by doing something like:
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  --   config = function()
  --     local rose_pine = require 'rose-pine'
  --     rose_pine.setup {
  --       variant = 'moon', -- Options: 'moon', 'dawn', 'rose-pine', 'base'
  --     }
  --   end,
  -- },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    init = function()
      require('gruvbox').setup {
      --   overrides = {
      --     ['@lsp.type.method'] = { bg = '#ff9900' },
      --     ['@comment.lua'] = { bg = '#000000' },
      --   },
      }
      vim.cmd 'colorscheme gruvbox'
    end,
  },
}
