return {
  {
    "xvzc/chezmoi.nvim",
    init = function()
      -- run chezmoi edit on file enter
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function()
          if vim.bo.filetype == "sh" then
            return
          end
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
    end,
  },
  {
    "ejrichards/baredot.nvim",
    init = function()
      require("baredot").set(false)
    end,
    opts = {
      git_dir = "~/.cfg", -- Change this path
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    -- dependencies = { "sindrets/diffview.nvim" },
    keys = {
      {
        "<leader>gg",
        ":Gitsigns preview_hunk_inline<CR>",
        noremap = true,
        silent = true,
        desc = "git preview_hunk_inline",
      },
      {
        "<leader>gd",
        function()
          package.loaded.gitsigns.diffthis("~")
        end,
        noremap = true,
        silent = true,
        desc = "git diff to HEAD~",
      },
      {
        "<leader>gR",
        ":Gitsigns reset_hunk<CR>",
        noremap = true,
        silent = true,
        desc = "git reset hunk",
      },
      {
        "<leader>ga",
        ":Gitsigns stage_hunk<CR>",
        noremap = true,
        silent = true,
        desc = "git stage hunk",
      },
      {
        "<leader>gb",
        ":Gitsigns blame_line<CR>",
        noremap = true,
        silent = true,
        desc = "git blame line",
      },
      -- {
      --   "<leader>uG",
      --   ":Gitsigns toggle_current_line_blame <CR>",
      --   noremap = true,
      --   silent = true,
      --   desc = "git blame line",
      -- },
    },
  },
}
