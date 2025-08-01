local no_weak_machine = require("config.weakmachine")
return {
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    enabled = no_weak_machine,
    -- opts = {}
  },
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --   },
  --   lazy = false,
  --   branch = "regexp",
  --   keys = {
  --     { ",v", "<cmd>VenvSelect<cr>" },
  --   },
  --   opts = {
  --     picker = "native",
  --     -- Your settings go here
  --   },
  -- },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    opts = {
      code = { border = "thick" },
      html = { comment = { conceal = false } },
    },
  },
  -- {
  -- 	"goerz/jupytext.nvim",
  -- 	version = "0.2.0",
  -- 	opts = {}, -- see Options
  -- },
  {
    "snacks.nvim",
    opts = {
      scratch = { enabled = true },
      scroll = { enabled = true },
    },
    keys = {
      {
        "<leader>j",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>fs",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
    },
  },
  {
    "folke/edgy.nvim",
    enabled = false,
    opts = function(_, opts)
      opts.right = opts.right or {}

      for _, entry in ipairs(opts.right) do
        if entry.title == "Database" then
          -- vim.notify("Database entry found", vim.log.levels.INFO)
          entry.pinned = false
        end
      end

      table.insert(opts.right, {
        ft = "codecompanion",
        title = "Code Companion",
        filter = function()
          return true
        end,
        size = { width = 80 },
      })

      opts.left = opts.left or {}
      table.insert(opts.left, {
        ft = "undotree",
        title = "Undoo Tree",
        filter = function()
          return true
        end,
        size = { width = 35 },
      })

      opts.animate = opts.animate or {}
      opts.animate.enabled = false
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    enabled = no_weak_machine,
    keys = {
      { "<leader>k", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request", ft = "http" },
    },
    opts = {
      additional_curl_options = { "--location", "-k" },
    },
  },
  -- -- Telescope is needed because of venvselect
  -- { "nvim-telescope/telescope.nvim" },
  {
    "folke/noice.nvim",
    enabled = no_weak_machine,
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          -- event = "msg_show",
          -- kind = "",
          any = {
            { find = "[.]*L, [.]*B" },
            { find = "%d fewer lines" },
            { find = "written" },
            { find = "%d more lines" },
            { find = "%d lines <ed %d time[s]?" },
            { find = "%d lines >ed %d time[s]?" },
            { find = "%d lines yanked" },
          },
        },
        opts = { skip = true },
      })
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = ".-Registered '.-' with .- LSP",
        },
      })
      opts.lsp.progress = { enabled = false }
      opts.presets.bottom_search = false
    end,
  },
  {
    "echasnovski/mini.indentscope",
    cond = no_weak_machine,
    keys = {
      {
        "<leader>uG",
        function()
          vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
        end,
        noremap = true,
        silent = true,
        desc = "toggle mini indent guide",
      },
    },
    init = function()
      vim.g.miniindentscope_disable = false
    end,
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>m",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Close current buffer",
        silent = true,
      },
    },
  },
  {
    "zk-org/zk-nvim",
    enabled = no_weak_machine,
    keys = {
      {
        "<leader>zn",
        "<Cmd>ZkNew <CR>",
        noremap = false,
        silent = true,
        desc = "New note",
      },
      {
        "<leader>zo",
        "<Cmd>ZkNotes { sort = { 'modified' }}<CR>",
        noremap = false,
        silent = true,
        desc = "Open notes",
      },
      {
        "<leader>zt",
        "<Cmd>ZkTags<CR>",
        noremap = false,
        silent = true,
        desc = "Open notes associated with the selected tags.",
      },
      {
        "<leader>zf",
        "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') }}<CR>",
        noremap = false,
        silent = true,
        desc = "Search for the notes matching a given query.",
      },
    },
    config = function()
      require("zk").setup({})
    end,
  },
  {
    "gbprod/yanky.nvim",
    keys = { { "<leader>y", ":YankyRingHistory<ENTER>", desc = "Yank Ring history" }, { "<leader>p", false } },
    opts = {
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 500,
      },
      system_clipboard = {
        sync_with_ring = true,
      },
    },
  },
  {
    "mbbill/undotree",
    keys = { { "<leader>U", vim.cmd.UndotreeToggle, desc = "Undo tree toggle" } },
    init = function()
      vim.g.undotree_DiffAutoOpen = 0
    end,
  },
  "lambdalisue/suda.vim",
}
