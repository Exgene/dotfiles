require 'keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- My Custom Plugin Stuff
require 'custom'
--

vim.filetype.add {
  extension = {
    mdx = 'markdown',
    journal = 'hledger',
  },
}

require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  require 'plugins.lsp', -- done
  require 'plugins.telescope', -- done
  require 'plugins.fff',
  require 'plugins.conform', --done
  require 'plugins.whichkey', --done
  require 'plugins.mini', -- done
  -- require 'plugins.treesitter', --done
  require 'plugins.colorscheme', -- done
  require 'plugins.harpoon', -- done
  require 'plugins.indent_line',
  require 'plugins.lint', -- done
  require 'plugins.autopairs', --done
  require 'plugins.neo-tree', -- done
  require 'plugins.gitsigns', -- done
  require 'plugins.md',
  require 'plugins.leetcode',
  require 'plugins.treesitter',
  require 'plugins.smear',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
