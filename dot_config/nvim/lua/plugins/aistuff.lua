-- local command = "cat " .. vim.fn.expand("$HOME") .. "/.config/openaikey"
local no_weak_machine = require("config.weakmachine")
--
-- local handle = io.popen(command)
-- API_KEY = nil
-- if handle ~= nil then
--   API_KEY = handle:read("*a"):match("%S+")
--   handle:close()
-- end
-- if API_KEY ~= nil then
--   vim.fn.setenv("OPENAI_API_KEY", API_KEY)
-- end

-- local tcommand = "docker inspect --format='{{.State.Running}}' tabby"
-- local thandle = io.popen(tcommand)
local container_running = false
-- if thandle then
--   container_running = thandle:read("*a"):match("%S+") == "true"
--   if container_running then
--     vim.notify("Tabby is running! Great! <leader>at will take you!", vim.log.levels.INFO)
--   end
--   thandle:close()
-- end
local M = {
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
    enabled = no_weak_machine,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "mistral" },
          inline = { adapter = "mistral" },
        },
        opts = {
          stream = true,
        },
        adapters = {
          mistral = function()
            return require("codecompanion.adapters").extend("mistral", {
              name = "codestral",
              schema = {
                model = {
                  -- default = "open-codestral-mamba",
                  default = "mistral-large-latest",
                },
                -- temperature = {
                --   default = 0.2,
                --   mapping = "parameters", -- not supported in default parameters.options
                -- },
              },
            })
          end,
          deepseek = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "deepseek",
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
      {
        "<leader>am",
        ":CodeCompanionChat mistral<CR>",
        desc = "Open chat (mistral)",
        -- icon = "🧠",
        mode = { "n", "v" },
      },
    },
  },
  {
    "milanglacier/minuet-ai.nvim",
    enabled = no_weak_machine,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("minuet").setup({
        provider_options = {
          codestral = {
            model = "codestral-latest",
            end_point = "https://codestral.mistral.ai/v1/fim/completions",
            api_key = "CODESTRAL_API_KEY",
            stream = true,
            -- template = {
            --   prompt = "See [Prompt Section for default value]",
            --   suffix = "See [Prompt Section for default value]",
            -- },
            optional = {
              stop = nil, -- the identifier to stop the completion generation
              max_tokens = nil,
            },
          },
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
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
    enabled = false,
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = true },
    },
  },
}

if no_weak_machine == true then
  table.insert(M, 1, {
    {
      "saghen/blink.cmp",
      dependencies = {
        "olimorris/codecompanion.nvim",
        "milanglacier/minuet-ai.nvim",
      },
      opts = {
        keymap = {
          ["<A-y>"] = {
            function(cmp)
              cmp.show({ providers = { "minuet" } })
            end,
          },
        },
        sources = {
          default = { "codecompanion", "minuet" },
          providers = {
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              score_offset = 8,
            },
          },
        },
        completion = { trigger = { prefetch_on_insert = false } },
      },
    },
  })
end
return M
