local command = "cat " .. vim.fn.expand("$HOME") .. "/.config/openaikey"

local handle = io.popen(command)
API_KEY = nil
if handle ~= nil then
  API_KEY = handle:read("*a"):match("%S+")
  handle:close()
end
if API_KEY ~= nil then
  vim.fn.setenv("OPENAI_API_KEY", API_KEY)
end

local tcommand = "docker inspect --format='{{.State.Running}}' tabby"
local thandle = io.popen(tcommand)
local container_running = false
if thandle then
  container_running = thandle:read("*a"):match("%S+") == "true"
  if container_running then
    vim.notify("Tabby is running! Great! <leader>at will take you!", vim.log.levels.INFO)
  end
  thandle:close()
end

return {
  -- {
  --   "blink-cmp-tabby",
  --   dir = "/home//nvimplugins/blink-cmp-tabby/",
  --   lazy = false,
  -- },
  {
    "TabbyML/vim-tabby",
    enabled = container_running,
    lazy = false,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    init = function()
      vim.g.tabby_agent_start_command = { "npx", "tabby-agent", "--stdio" }
      vim.g.tabby_inline_completion_trigger = "auto"
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "openai" },
          inline = { adapter = "openai" },
        },
        adapters = {
          deepseek = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "deepseek", -- Give this adapter a different name to differentiate it from the default ollama adapter
              schema = {
                model = {
                  -- default = "deepseek-coder-v2:latest",
                  default = "deepseek-r1:8b",
                },
                num_ctx = {
                  default = 16384,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
          tabby = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "http://localhost:8080", -- optional: default value is ollama url http://127.0.0.1:11434
                api_key = "auth_881a958cbb454e1aa87a3fa17e8e9649", -- optional: if your endpoint is authenticated
              },
              chat_url = "/v1/chat/completions", -- optional: default value, override if different
              schema = {
                model = {
                  default = "Qwen2-1.5B-Instruct",
                  choices = { "Qwen2-1.5B-Instruct" },
                },
              },
            })
          end,
        },
      })
    end,
    keys = {
      {
        "<leader>ar",
        ":CodeCompanion ",
        desc = "Quick change (openai)",
        -- icon = "🔀",
        mode = { "n", "v" },
      },
      {
        "<leader>at",
        ":CodeCompanionChat tabby<CR>",
        desc = "Open chat (tabby)",
        -- icon = "🐱",
        mode = { "n", "v" },
      },
      {
        "<leader>ad",
        ":CodeCompanionChat deepseek<CR>",
        desc = "Open chat (deepseek-coder-v2)",
        -- icon = "🔍",
        mode = { "n", "v" },
      },
      {
        "<leader>ao",
        ":CodeCompanionChat openai<CR>",
        desc = "Open chat (openai)",
        -- icon = "🧠",
        mode = { "n", "v" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "olimorris/codecompanion.nvim",
    },
    -- opts = {
    --   sources = {
    --     default = { "codecompanion" },
    --   },
    -- },
    opts = function(_, opts)
      opts.sources.default = opts.sources.default or {}
      table.insert(opts.sources.default, "codecompanion")
      -- vim.b.completion = true
      --
      -- Snacks.toggle({
      --   name = "Completion",
      --   get = function()
      --     return vim.b.completion
      --   end,
      --   set = function(state)
      --     vim.b.completion = state
      --   end,
      -- }):map("<leader>uk")
      --
      -- opts.enabled = function()
      --   return vim.b.completion ~= false
      -- end
      return opts
    end,
    -- opts = {
    --   sources = {
    --     default = { "codecompanion", "tabby" },
    --     providers = {
    --       tabby = {
    --         name = "tabby",
    --         module = "blink-cmp-tabby",
    --         kind = "tabby",
    --         score_offset = 100,
    --         async = true,
    --       },
    --     },
    --   },
    -- },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = { auto_insert_mode = false },
    keys = {
      {
        "<leader>ag",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        -- icon = " ",
        mode = { "n", "v" },
      },
      -- NOTE: This is defined here, because otherwise it would be obscured by
      -- the default for CopilotChat, so it is again defined below
      {
        "<leader>aa",
        ":CodeCompanionActions<CR>",
        desc = "Open Actions",
        -- icon = "🐱",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        -- icon = " ",
        mode = { "n", "v" },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = true },
    },
  },
}
