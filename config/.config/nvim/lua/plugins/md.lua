local function is_lsp_float(buf)
  if vim.bo[buf].filetype ~= 'markdown' then
    return false
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      local ok = pcall(vim.api.nvim_win_get_var, win, 'lsp_floating_bufnr')
      if ok then
        return true
      end
    end
  end

  return vim.bo[buf].bufhidden == 'wipe' and not vim.bo[buf].modifiable
end

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  ft = { 'markdown' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { 'markdown' },
    ignore = function(buf)
      return is_lsp_float(buf)
    end,
  },
}
