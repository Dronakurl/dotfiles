return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        html = { "prettierd" },
        css = { "prettierd" },
        rust = { "rustfmt" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        latex = { "latexindent" },
        cmake = { "cmakelang" },
      },
    },
  },
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
}
