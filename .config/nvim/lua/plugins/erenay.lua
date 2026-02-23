return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
  --  {
  --    "nvim-tree/nvim-tree.lua",
  --    config = function()
  --      require("nvim-tree").setup()
  --    end,
  --  },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_save_enabled = true,
        auto_restore_enabled = true,
      })
    end,
  },
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    config = function()
      require("presence").setup({
        auto_update = true,
        neovim_image_text = "The One True Text Editor",
        main_image = "neovim",
        client_id = "793271441293967371",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = false,
        blacklist = {},
        buttons = true,
        file_assets = {},
        show_time = true,
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Reading %s",
        workspace_text = "Working on %s",
        line_number_text = "Line %s out of %s",
      })
    end,
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
  {
    "alexpasmantier/krust.nvim",
    ft = "rust",
  },
  {
    "tokyonight.nvim",
  opts = {
        transparent = true,
        styles = {
           sidebars = "transparent",
           floats = "transparent",
        },
  }
},
{
  "nvimdev/dashboard-nvim",
  opts = function(_, opts)
    local logo = [[
      ███████╗██████╗ ███████╗███╗   ██╗ █████╗ ██╗   ██╗
      ██╔════╝██╔══██╗██╔════╝████╗  ██║██╔══██╗╚██╗ ██╔╝
      █████╗  ██████╔╝█████╗  ██╔██╗ ██║███████║ ╚████╔╝ 
      ██╔══╝  ██╔══██╗██╔══╝  ██║╚██╗██║██╔══██║  ╚██╔╝  
      ███████╗██║  ██║███████╗██║ ╚████║██║  ██║   ██║   
      ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝   
    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"
    
    opts = opts or {}
    opts.config = opts.config or {}
    opts.config.header = vim.split(logo, "\n")
    opts.config.footer = function()
      return { "erenaydev.com.tr :)" }
    end
    
    return opts
  end,
},
{
  "skardyy/neo-img",
  build = ":NeoImg Install",
  opts = {
    backend = "kitty",
    size = "80%",
    center = true,
    auto_open = true,
    oil_preview = false,
    resizeMode = "Fit",
    ttyimg = "local",
  },
  },
 {
  "wfxr/minimap.vim",
  event = "VeryLazy",
  init = function()
    vim.g.minimap_auto_start = 1
  end,
},
{
  "mrcjkb/rustaceanvim",
  ft = { "rust" },
  opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<leader>cR", function()
          vim.cmd.RustLsp("codeAction")
        end, { desc = "Code Action", buffer = bufnr })
        vim.keymap.set("n", "<leader>dr", function()
          vim.cmd.RustLsp("debuggables")
        end, { desc = "Rust Debuggables", buffer = bufnr })
      end,
      default_settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          check = {
            command = "clippy",
            extraArgs = { "--target-dir", "target/check" },
          },
          diagnostics = {
            enable = true,
          },
          procMacro = {
            enable = true,
          },
          files = {
            exclude = {
              ".direnv",
              ".git",
              ".jj",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
            watcher = "client",
          },
        },
      },
    },
  },
  config = function(_, opts)
    if LazyVim.has("mason.nvim") then
      local codelldb = vim.fn.exepath("codelldb")
      local codelldb_lib_ext = io.popen("uname"):read("*l") == "Linux" and ".so" or ".dylib"
      local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
      }
    end
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    if vim.fn.executable("rust-analyzer") == 0 then
      LazyVim.error(
        "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
        { title = "rustaceanvim" }
      )
    end
  end,
},
{
  "amitds1997/remote-nvim.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("remote-nvim").setup({
      ssh_config = {
        ssh_config_file_paths = { "$HOME/.ssh/config" },
      },
      remote = {
        copy_dirs = {
          config = {
            base = vim.fn.stdpath("config"),
            dirs = "*",
            compression = {
              enabled = true,
              additional_opts = { "--exclude-vcs", "--exclude=.git" },
            },
          },
          data = {
            base = vim.fn.stdpath("data"),
            dirs = { "lazy" },
            compression = {
              enabled = true,
            },
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>rc", "<cmd>RemoteStart<cr>", desc = "Remote Connect" },
    { "<leader>rs", "<cmd>RemoteStop<cr>", desc = "Remote Stop" },
    { "<leader>ri", "<cmd>RemoteInfo<cr>", desc = "Remote Info" },
    { "<leader>rd", "<cmd>RemoteCleanup<cr>", desc = "Remote Cleanup" },
  },
}
}
