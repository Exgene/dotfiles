local function exists(value)
  local hidden = { 'node_modules', '.git' }
  for _, x in ipairs(hidden) do
    if value == x then
      return true
    end
  end
  return false
end

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return exists(name)
      end,
    },
    columns = {
      'icon',
    },
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
}
