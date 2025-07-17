local no_weak_machine = require("config.weakmachine")

local M = {
  {
    "echasnovski/mini.diff",
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
        chat = { adapter = "mistral" },
        inline = { adapter = "mistral" },
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
            },
          })
        end,
      },
    },
    inline = {
      adapter = "mistral",
      keymaps = {
        accept_change = {
          modes = {
            n = "gda",
          },
          index = 1,
          callback = "keymaps.accept_change",
          description = "Accept change",
        },
        reject_change = {
          modes = {
            n = "gdr",
          },
          index = 2,
          callback = "keymaps.reject_change",
          description = "Reject change",
        },
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
