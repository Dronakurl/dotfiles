local no_weak_machine = require("config.weakmachine")
if no_weak_machine == false then
  vim.notify("Weak machine mode enabled", vim.log.levels.WARN)
end
return {
  {
    "nvim-neotest/neotest",
    -- dependencies = {
    --   "rosstang/neotest-catch2",
    --   "Shatur/neovim-tasks",
    -- },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          args = { "-s", "--no-header", "--log-cli-level=DEBUG" },
        },
        -- "neotest-catch2",
      },
      quickfix = { open = false },
      status = { virtual_text = true },
    },
    keys = {
      {
        "<leader>k",
        function()
          vim.cmd("w")
          require("neotest").run.run()
        end,
        desc = "neotest Run Nearest test",
        noremap = true,
      },
    },
  },
}
