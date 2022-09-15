local execute = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')

local pack_path = fn.stdpath("data") .. "/site/pack"

require("basic")

-- ensure a given plugin from github.com/<user>/<repo> is cloned in the pack/packer/start directory
local function ensure (user, repo)
  local install_path = fmt("%s/packer/start/%s", pack_path, repo)
  if fn.empty(fn.glob(install_path)) > 0 then
    execute(fmt("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    execute(fmt("packadd %s", repo))
  end
end

-- ensure the plugin manager is installed
ensure("wbthomason", "packer.nvim")

require('packer').startup(function(use)
  -- install all the plugins you need here

  -- the plugin manager can manage itself
  use {'wbthomason/packer.nvim'}

  -- lsp config for elixir-ls support
  use {'neovim/nvim-lspconfig'}

  -- cmp framework for auto-completion support
  use {'hrsh7th/nvim-cmp'}

  -- install different completion source
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/cmp-path'}
  use {'hrsh7th/cmp-cmdline'}

  -- you need a snippet engine for snippet support
  -- here I'm using vsnip which can load snippets in vscode format
  use {'hrsh7th/vim-vsnip'}
  use {'hrsh7th/cmp-vsnip'}

  -- treesitter for syntax highlighting and more
  use {'nvim-treesitter/nvim-treesitter'}

  -- git
  use {'tpope/vim-fugitive'}
  use {'airblade/vim-gitgutter'}

  -- file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require'nvim-tree'.setup {} end
  }

  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      adaptive_size = true,
      mappings = {
        list = {
          { key = "u", action = "dir_up" },
          { key = "d", action = "dir_down" },
        },
      },
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
  })

  -- Let's install fzf. `run` is a callback used to install the fzf
  -- executable. This can be optional if you are installing fzf another
  -- way.
  use {"junegunn/fzf",
        run = function()
          vim.fn["fzf#install"]()
        end}
  use "junegunn/fzf.vim"

  -- silver searcher
  use {'gabesoft/vim-ags'}

  -- docker
  use {'ekalinin/dockerfile.vim'}
  use {'kevinhui/vim-docker-tools'}

  -- colorthemes
  -- use {'lmintmate/blue-mood-vim'}
  use {'andreasvc/vim-256noir'}
  use {'wesgibbs/vim-irblack'}
end)

-- `on_attach` callback will be called after a language server
-- instance has been attached to an open buffer with matching filetype
-- here we're setting key mappings for hover documentation, goto definitions, goto references, etc
-- you may set those key mappings based on your own preference
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- setting up the elixir language server
-- you have to manually specify the entrypoint cmd for elixir-ls
require('lspconfig').elixirls.setup {
  cmd = { "/home/eddy/elixir-ls/release/language_server.sh" },
  on_attach = on_attach,
  capabilities = capabilities
}

local cmp = require'cmp'

-- helper functions
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- setting up snippet engine
      -- this is for vsnip, if you're using other
      -- snippet engine, please refer to the `nvim-cmp` guide
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
	cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
	feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
	cmp.complete()
      else
	fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
	cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
	feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'buffer' }
  })
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = {'elixir'},
  sync_install = false,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = { },
  },
}

-- search
-- use ripgrep if exists
if (vim.fn.executable('rg') ~= 0) then
  vim.env.FZF_DEFAULT_COMMAND = 'rg --hidden --files --glob="!.git/*" --glob="!venv/*" --glob="!coverage/*" --glob="!node_modules/*" --glob="!target/*" --glob="!__pycache__/*" --glob="!dist/*" --glob="!build/*" --glob="!*.DS_Store"'
  vim.g.grepprg='rg'
  -- else use the silver searcher if exists
elseif (vim.fn.executable('ag') ~= 0) then
  vim.env.FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore venv/ --ignore coverage/ --ignore node_modules/ --ignore target/  --ignore __pycache__/ --ignore dist/ --ignore build/ --ignore .DS_Store  -g ""'
  vim.g.grepprg='ag --nogroup'
else
  -- else fallback to find
  vim.env.FZF_DEFAULT_COMMAND = [[find * -path '*/\.*' -prune -o -path 'venv/**' -prune -o -path  'coverage/**' -prune -o -path 'node_modules/**' -prune -o -path '__pycache__/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null]]
end


-- mappings
local map = require("mappings").map


map("n", "<c-p>", ":Files<cr>", {silent = true, noremap = true})
map("n", "<c-n>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})
map("n", "<c-f>", ":Ag<cr>", {silent = true, noremap = true})

-- misc, like colorscheme etc
cmd 'colorscheme ir_black'
