return {
  {
    "catppuccin/nvim",
    enabled = true,
    name = "catppuccin",
    priority = 1,
    lazy = true,
    -- opts = { transparent_background = not vim.g.neovide },
  },
  {
    "projekt0n/github-nvim-theme",
    enabled = false,
    lazy = false,
    priority = -999,
    config = function()
      require("github-theme").setup({})
      -- vim.cmd("colorscheme github_dark_dimmed")
    end,
  },
  -- { "ellisonleao/gruvbox.nvim", priority = 100, lazy = false, config = true },
  {
    "folke/tokyonight.nvim",
    priority = 10000,
    enabled = true,
    -- lazy = false,
    opts = {
      transparent = false,
      hide_inactive_statusline = true,
      on_highlights = function(hl, c)
        -- vim.notify(vim.inspect(hl))
        hl.BufferLineIndicatorSelected = {
          bg = "#FFFFFF",
          fg = "#000000",
        }
      end,
    },
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    init = function()
      local snacks = require("snacks")
      snacks
        .toggle({
          id = "transparency",
          name = "Transparency",
          get = function()
            return vim.g.transparent_enabled
          end,
          set = function(enabled)
            vim.g.transparent_enabled = enabled
          end,
        })
        :map("<leader>uo")
    end,
    opts = {
      extra_groups = {
        "FloatBorder",
        "LSPInfoBorder",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NormalFloat",
        "NotifyDEBUGBody",
        "NotifyDEBUGBorder",
        "NotifyERRORBody",
        "NotifyERRORBorder",
        "NotifyINFOBody",
        "NotifyINFOBorder",
        "NotifyTRACEBody",
        "NotifyTRACEBorder",
        "NotifyWARNBody",
        "NotifyWARNBorder",
        "WhichKeyFloat",
      },
      exclude_groups = {},
    },
  },
}
-- { "rebelot/kanagawa.nvim", enabled = true, priority = 1, lazy = false },
-- Or with configuration
-- {
--   "oxfist/night-owl.nvim",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1, -- make sure to load this before all the other start plugins
--   -- config = function()
--   --   require("night-owl").setup()
--   -- end,
-- },
-- {
--   "kepano/flexoki-neovim",
--   name = "flexoki",
--   lazy = false,
--   config = function()
--     require("flexoki").setup({})
--   end,
-- },
-- { "EdenEast/nightfox.nvim" },
