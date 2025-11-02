local no_weak_machine = require("config.weakmachine")

local M = {
  {
    "nvim-mini/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    -- enabled = no_weak_machine,
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
    },
    opts = {
      strategies = {
        chat = { adapter = "claude_code" },
        cmd = { adapter = "claude_code" },
        inline = {
          adapter = "mistral",
          keymaps = {
            accept_change = {
              modes = {
                n = "gA",
              },
              index = 1,
              callback = "keymaps.accept_change",
              description = "Accept change",
            },
            reject_change = {
              modes = {
                n = "gR",
              },
              index = 2,
              callback = "keymaps.reject_change",
              description = "Reject change",
            },
          },
        },
      },
      adapters = {
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
              },
            })
          end,
        },
        mistral = function()
          return require("codecompanion.adapters").extend("mistral", {
            name = "codestral",
            schema = {
              choices = {
                "mistral-large-latest",
                "magistral-medium-latest",
                "codestral-latest",
                "devstral-small-latest",
                "devstral-medium-latest",
              },
              model = {
                -- default = "mistral-large-latest",
                -- default = "codestral-latest",
                -- default = "devstral-small-latest",
                default = "devstral-medium-latest",
                -- default = "magistral-medium-2506",
              },
            },
          })
        end,
      },
    },
    keys = {
      {
        "<leader>aq",
        ":CodeCompanion ",
        desc = "Quick change (openai)",
        -- icon = "🔀",
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
        "<leader>ai",
        ":CodeCompanionChat claude_code<CR>",
        desc = "Open chat (claude_code)",
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
      "folke/snacks.nvim",
    },
    config = function()
      local minuet = require("minuet")
      Snacks.toggle({
        id = "minuet",
        name = "AI completion",
        get = function()
          return minuet.config["blink"].enable_auto_complete
        end,
        set = function(enabled)
          minuet.config["blink"].enable_auto_complete = enabled
        end,
      }):map("<leader>uk")
      minuet.setup({
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
        },
      })
      minuet.config["blink"].enable_auto_complete = false
    end,
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
      init = function()
        local snacks = require("snacks")
        snacks
          .toggle({
            id = "completion",
            name = "Blink completion",
            get = function()
              if vim.b.completion == nil then
                vim.b.completion = true
              end
              return vim.b.completion
            end,
            set = function(enabled)
              vim.b.completion = enabled
            end,
          })
          :map("<leader>uu")
      end,
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
