-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = 'Telescope',
  keys = {
    { '<leader>?', function() require('telescope.builtin').oldfiles() end, desc = 'Recent files' },
    { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = 'Buffers' },
    { '<leader>sb', function() require('telescope.builtin').buffers() end, desc = 'Search buffers' },
    { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = 'Search diagnostics' },
    { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = 'Search files' },
    { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = 'Search grep' },
    { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = 'Search help' },
    { '<leader>sm', function() require('telescope.builtin').marks() end, desc = 'Search marks' },
    { '<leader>sr', function() require('telescope.builtin').resume() end, desc = 'Search resume' },
    { '<leader>sw', function() require('telescope.builtin').grep_string() end, desc = 'Search current word' },
    { '<leader>s.', function() require('telescope.builtin').oldfiles() end, desc = 'Search recent files' },
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      desc = 'Search open files',
    },
    {
      '<leader>sds',
      function()
        require('telescope.builtin').lsp_document_symbols {
          symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
        }
      end,
      desc = 'Search document symbols',
    },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = false,
        })
      end,
      desc = 'Search current buffer',
    },
    { '<leader>gb', function() require('telescope.builtin').git_branches() end, desc = 'Git branches' },
    { '<leader>gc', function() require('telescope.builtin').git_commits() end, desc = 'Git commits' },
    { '<leader>gcf', function() require('telescope.builtin').git_bcommits() end, desc = 'Git file commits' },
    { '<leader>gf', function() require('telescope.builtin').git_files() end, desc = 'Git files' },
    { '<leader>gs', function() require('telescope.builtin').git_status() end, desc = 'Git status picker' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',

    -- Useful for getting pretty icons, but requires a Nerd Font.
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous, -- move to prev result
            ['<C-j>'] = actions.move_selection_next,     -- move to next result
            ['<C-l>'] = actions.select_default,          -- open file
          },
          n = {
            ['q'] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { 'node_modules', '.git', '.venv' },
          hidden = true,
        },
        buffers = {
          initial_mode = 'normal',
          sort_lastused = true,
          -- sort_mru = true,
          mappings = {
            n = {
              ['d'] = actions.delete_buffer,
              ['l'] = actions.select_default,
            },
          },
        },
      },
      live_grep = {
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
        additional_args = function(_)
          return { '--hidden' }
        end,
      },
      path_display = {
        filename_first = {
          reverse_directories = true,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
      git_files = {
        previewer = false,
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
  end,
}
