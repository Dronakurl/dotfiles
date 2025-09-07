local M = {
  -- {
  --   "mrcjkb/rustaceanvim",
  --   opts = {
  --     server = {
  --       default_settings = {
  --         ["rust-analyzer"] = {
  --           procMacro = {
  --             ignored = {
  --               ["async-trait"] = vim.NIL,
  --               ["leptos_macro"] = {
  --                 -- optional: --
  --                 -- "component",
  --                 ["server"] = vim.NIL,
  --               },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        html = { "prettierd" },
        css = { "prettierd" },
        rust = { "rustfmt", "leptosfmt" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        latex = { "latexindent" },
        typst = { "typstyle" },
        -- cmake = { "cmake-format" },
        cmake = { "cmakelang" },
      },
    },
  },
}

local no_weak_machine = require("config.weakmachine")
if no_weak_machine == true then
  table.insert(M, 1, {
    {
      "neovim/nvim-lspconfig",
      ---@class PluginLspOpts
      opts = {
        inlay_hints = { enabled = false },
        servers = {
          basedpyright = {
            settings = {
              basedpyright = {
                analysis = {
                  ignorePatterns = { "*.pyi" },
                  diagnosticSeverityOverrides = {
                    reportCallIssue = "warning",
                    reportUnreachable = "warning",
                    reportUnusedImport = "none",
                    reportUnusedCoroutine = "warning",
                  },
                  -- diagnosticMode = "workspace",
                  diagnosticMode = "openFilesOnly",
                  typeCheckingMode = "basic",
                  reportCallIssue = "none",
                  disableOrganizeImports = true,
                },
              },
            },
          },
        },
      },
    },
  })
end
return M
