-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*",  -- Use the latest tagged version
    opts = {},  -- This causes the plugin setup function to be called
    keys = {
      {"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}, desc = "Add cursor and move down"},
      {"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "x"}, desc = "Add cursor and move up"},
  
      {"<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i", "x"}, desc = "Add cursor and move up"},
      {"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i", "x"}, desc = "Add cursor and move down"},
  
      {"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"n", "i"}, desc = "Add or remove cursor on mouse click"},
      {"<C-Return>", "<Cmd>MultipleCursorsAddDelete<CR>", mode = {"n"}, desc = "Add a locked cursor or remove an existing cursor"},
  
      {"<Leader>m", "<Cmd>MultipleCursorsAddVisualArea<CR>", mode = {"x"}, desc = "Add cursors to the lines of the visual area"},
  
      {"<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = {"n", "x"}, desc = "Add cursors to cword"},
      {"<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = {"n", "x"}, desc = "Add cursors to cword in previous area"},
  
      {"<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = {"n", "x"}, desc = "Add cursor and jump to next cword"},
      {"<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = {"n", "x"}, desc = "Jump to next cword"},
  
      {"<Leader>l", "<Cmd>MultipleCursorsLock<CR>", mode = {"n", "x"}, desc = "Lock virtual cursors"},
    },
  },

{
  "selimacerbas/markdown-preview.nvim",
  dependencies = { "selimacerbas/live-server.nvim" },
  config = function()
    require("markdown-preview").setup({
      -- all optional; sane defaults shown
      instance_mode = "takeover",  -- "takeover" (one tab) or "multi" (tab per instance)
      port = 0,                    -- 0 = auto (8421 for takeover, OS-assigned for multi)
      open_browser = true,
      mermaid_renderer = "rust",
      default_theme = "dark",      -- "dark" or "light"; initial preview theme
      debounce_ms = 300,
    })
  end,
},

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = true },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })

      -- include the default astronvim config that calls the setup call
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    config = function()
      local kanagawa = require "kanagawa"
      kanagawa.setup {
        transparent = true,
        theme = "wave",
      }
    end,
  },
  { "m-pilia/vim-pkgbuild", lazy = false },
  {
    "akinsho/git-conflict.nvim",
    tag = "v2.1.0",
    config = function()
      require("git-conflict").setup {
        default_mappings = false,
      }
    end,
    lazy = false,
  },
  { "folke/zen-mode.nvim", lazy = false },
  { "tpope/vim-fugitive", lazy = false },
  { "Eandrju/cellular-automaton.nvim", lazy = false },
  { "segeljakt/vim-silicon", lazy = false },
  { "TheBlob42/houdini.nvim", lazy = false },
  { "mzlogin/vim-markdown-toc", lazy = false },
  {
    "ruifm/gitlinker.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local gitlinker = require "gitlinker"
      gitlinker.setup()
    end,
    lazy = false,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zjp-CN/nvim-cmp-lsp-rs",
        ---@type cmp_lsp_rs.Opts
        opts = {
          -- Filter out import items starting with one of these prefixes.
          -- A prefix can be crate name, module name or anything an import
          -- path starts with, no matter it's complete or incomplete.
          -- Only literals are recognized: no regex matching.
          unwanted_prefix = { "ratatui::crossterm::style::Stylize", "crossterm", "Styled" },
        },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      hide_target_hack = false,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      legacy_computing_symbols_support = false,
    },
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    config = function() require("crates").setup() end,
  },
  { "wfxr/minimap.vim" },
  { "norcalli/nvim-colorizer.lua" },
  { "alexpasmantier/tv.nvim" },
  {
    "alexpasmantier/krust.nvim",
    ft = "rust",
    opts = {
      keymap = "<leader>k", -- Set a keymap for Rust buffers (default: false)
      float_win = {
        border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
        auto_focus = false, -- Auto-focus float (default: false)
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.config = opts.config or {}
      local ra = opts.config.rust_analyzer or {}
      ra.autostart = false
      opts.config.rust_analyzer = ra
    end,
  },
}
