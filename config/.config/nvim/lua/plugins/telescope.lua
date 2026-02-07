return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    local netrw_cheat_sheet = {
      'Basic Commands:',
      ':Ex or :Explore        - Open netrw in the current directory',
      ':Sex or :Sexplore      - Open netrw in a horizontal split',
      ':Vex or :Vexplore      - Open netrw in a vertical split',
      ':Tex or :Texplore      - Open netrw in a new tab',
      '',
      'Navigation:',
      'Enter                 - Open the selected file or directory',
      '-                     - Go to the parent directory',
      'u                     - Go to the previous directory',
      'p                     - Go to the next directory',
      'Ctrl-h                - Go to home directory (~)',
      'Ctrl-l                - Refresh the current directory view',
      '',
      'File Operations:',
      '%                     - Create a new file',
      'd                     - Create a new directory',
      'D                     - Delete the file or directory',
      'R                     - Rename the file or directory',
      "x                     - Execute a file in the system's default program",
      '',
      'Sorting:',
      'i                     - Change display style (list, tree, icon view)',
      'r                     - Reverse sort order',
      's                     - Sort by name, time, size, extension',
      'gh                    - Toggle hidden files',
      '',
      'Marks & Bookmarks:',
      'mf                    - Mark a file',
      'mu                    - Unmark a file',
      'mF                    - Mark all files',
      'mb                    - Bookmark the current directory',
      'gb                    - List bookmarks',
      '',
      'File Operations with Marks:',
      'mc                    - Copy marked files',
      'mm                    - Move marked files',
      'mr                    - Rename marked files',
      'md                    - Delete marked files',
      '',
      'Opening Files:',
      'p                     - Preview a file without leaving netrw',
      'P                     - Preview file and navigate list',
      'o                     - Open a file in the current window',
      'v                     - Open a file in a vertical split',
      's                     - Open a file in a horizontal split',
      't                     - Open a file in a new tab',
      '',
      'Miscellaneous:',
      'q                     - Quit netrw',
      ':NetrwSettings         - Show current netrw settings',
      'gh                    - Toggle hidden files',
      '=                     - Toggle between human-readable and byte sizes',
    }

    local actions = require 'telescope.actions'
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values

    -- Function to create the custom picker
    local function open_netrw_cheat_sheet()
      pickers
        .new({}, {
          prompt_title = 'Netrw Cheat Sheet',
          finder = finders.new_table {
            results = netrw_cheat_sheet,
          },
          sorter = conf.generic_sorter {},
          attach_mappings = function(_, map)
            -- Close on Enter
            map('i', '<CR>', actions.close)
            map('n', '<CR>', actions.close)
            return true
          end,
        })
        :find()
    end

    vim.api.nvim_create_user_command('NetrwHelp', open_netrw_cheat_sheet, {})
    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    -- vim.keymap.set('n', '<leader>s/', function()
    --   builtin.live_grep {
    --     grep_open_files = true,
    --     prompt_title = 'Live Grep in Open Files',
    --   }
    -- end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
