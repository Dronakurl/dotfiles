local no_weak_machine = require("config.weakmachine")

local M = {
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    build = "make",
    opts = {
      input = {
        provider = "snacks",
        provider_opts = {
          title = "Avante Input",
          icon = " ",
          placeholder = "Enter your API key...",
        },
      },
      provider = "mistral",
      providers = {
        ollama = {
          endpoint = "http://localhost:11434",
          model = "devstral:latest",
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022",
          disable_tools = true,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 4096,
          },
        },
        mistral = {
          __inherited_from = "openai",
          api_key_name = "MISTRAL_API_KEY",
          endpoint = "https://api.mistral.ai/v1/",
          model = "mistral-large-latest",
          extra_request_body = {
            max_tokens = 4096, -- to avoid using max_completion_tokens
          },
        },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "coder/claudecode.nvim",
    config = true,
    -- enabled = is_command_available("claude"),
    enabled = false,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    -- enabled = no_weak_machine,
    enabled = true,
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
                  default = "mistral-large-latest",
                  -- default = "magistral-medium-2506",
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
        "<leader>aq",
        ":CodeCompanion ",
        desc = "Quick change (openai)",
        -- icon = "🔀",
        mode = { "n", "v" },
      },
      -- {
      --   "<leader>at",
      --   ":CodeCompanionChat tabby<CR>",
      --   desc = "Open chat (tabby)",
      --   -- icon = "🐱",
      --   mode = { "n", "v" },
      -- },
      -- {
      --   "<leader>ad",
      --   ":CodeCompanionChat deepseek<CR>",
      --   desc = "Open chat (deepseek-coder-v2)",
      --   -- icon = "🔍",
      --   mode = { "n", "v" },
      -- },
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
        n_completions = 1,
        presets = {
          ollama = {
            throttle = 400,
            provider = "openai_fim_compatible",
            n_completions = 1,
            provider_options = {
              openai_fim_compatible = {
                -- For Windows users, TERM may not be present in environment variables.
                -- Consider using APPDATA instead.
                api_key = "TERM",
                name = "Ollama",
                -- end_point = "http://localhost:11434/api/generate",
                end_point = "http://localhost:11434/v1/completions",
                model = "qwen2.5-coder:7b",
                -- model = "codestral",
                -- model = "stable-code:latest",
                optional = {
                  max_tokens = 56,
                  top_p = 0.9,
                },
              },
            },
          },
          -- codestral = {
          --   provider = "codestral",
          --   provider_options = {
          --     codestral = {
          --       model = "codestral-latest",
          --       end_point = "https://codestral.mistral.ai/v1/fim/completions",
          --       api_key = "CODESTRAL_API_KEY",
          --       stream = true,
          --       optional = {
          --         stop = nil, -- the identifier to stop the completion generation
          --         max_tokens = nil,
          --       },
          --     },
          --   },
          -- },
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
        -- "Kaiser-Yang/blink-cmp-avante",
      },
      keys = {
        {
          "<leader>uu",
          function()
            if vim.b.completion == nil then
              vim.b.completion = true
            end
            vim.b.completion = not vim.b.completion
            vim.notify("Blink completion " .. (vim.b.completion and "enabled" or "disabled"), vim.log.levels.INFO)
          end,
          desc = "Toggle blink completion",
        },
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
          -- default = { "codecompanion", "minuet", "avante" },
          -- default = { "minuet", "avante" },
          default = { "minuet", "codecompanion" },
          providers = {
            -- avante = {
            --   module = "blink-cmp-avante",
            --   name = "Avante",
            --   opts = {
            --     -- options for blink-cmp-avante
            --   },
            -- },
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
