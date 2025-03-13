-- local img_previewer = { "chafa", "{file}", "--format=symbols" }
-- local img_previewer = { "wezterm", "imgcat", "{file}", "--width=10", "--height=10" }

return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>-",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>.",
        "<cmd>Yazi<cr>",
        desc = "Open the file manager at current file",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      open_multiple_tabs = true,
      -- future_features = {
      --   -- Whether to use `ya emit reveal` to reveal files in the file manager.
      --   -- Requires yazi 0.4.0 or later (from 2024-12-08).
      --   ya_emit_reveal = true,
      --
      --   -- Use `ya emit open` as a more robust implementation for opening files
      --   -- in yazi. This can prevent conflicts with custom keymappings for the enter
      --   -- key. Requires yazi 0.4.0 or later (from 2024-12-08).
      --   ya_emit_open = true,
      -- },

      keymaps = {
        show_help = "<f1>",
      },
    },
  },
  {
    "aidenlangley/auto-save.nvim",
    event = { "BufReadPre" },
    opts = {
      -- events = { "InsertLeave", "BufLeave" },
      events = { "BufLeave" },
      silent = true,
      exclude_ft = { "neo-tree" },
    },
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     sources = { "filesystem" },
  --     window = {
  --       width = 30,
  --     },
  --   },
  --   keys = {
  --     {
  --       "<leader>e",
  --       function()
  --         if vim.bo.filetype == "snacks_dashboard" then
  --           require("mini.bufremove").delete(0)
  --           --- --- @diagnostic disable-next-line: missing-fields
  --           --- require("snacks").dashboard({ sections = { { section = "keys", gap = 1 } } })
  --         end
  --         require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
  --       end,
  --       desc = "Explorer NeoTree (Root Dir)",
  --     },
  --     {
  --       "<leader>ge",
  --       function()
  --         Snacks.picker("git_status")
  --       end,
  --       desc = "Git status",
  --     },
  --   },
  -- },
  {
    "folke/persistence.nvim",
    keys = {
      {
        "<leader>S",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
    },
  },
}
