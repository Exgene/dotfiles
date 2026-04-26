return {
  'kawre/leetcode.nvim',
  cmd = 'Leet',
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('leetcode').setup {
      lang = 'python3',
      logging = true,
      cache = {
        update_interval = 60 * 60 * 24 * 7,
      },
    }
  end,
}
