vim.lsp.config['test'] = {
  cmd = {
    '/home/kausthubh/GitHub/cuda-autocompletes/bin/main',
  },
  filetypes = { 'markdown' },
}

vim.lsp.enable 'test'
-- vim.lsp.set_log_level 'debug'
