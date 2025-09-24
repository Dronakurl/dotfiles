-- -- Options are automatically loaded before lazy.nvim startup
-- -- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = "#a8a725", fg = "#000000", bold = true })

if require("config.is_running_in_docker")() then
  vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#7777AA" })
  vim.notify("Running in Docker")
end

-- vim.g.clipboard = "osc52"
vim.o.clipboard = "unnamedplus"
-- vim.g.clipboard = "osc52"
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.clipboard.osc52").copy,
--     ["*"] = require("vim.clipboard.osc52").copy,
--   },
--   paste = {
--     ["+"] = require("vim.clipboard.osc52").paste,
--     ["*"] = require("vim.clipboard.osc52").paste,
--   },
-- }

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

vim.opt.wrap = true
vim.lsp.enable("ty", true)
vim.lsp.enable("just", true)
vim.g.root_spec = { ".git", "lsp" }

vim.diagnostic.config({
  virtual_text = {
    source = true,
    format = function(diagnostic)
      -- print(vim.inspect(diagnostic))
      if diagnostic.user_data and diagnostic.user_data.code then
        return string.format("%s %s", diagnostic.user_data.code, diagnostic.message)
      else
        return diagnostic.message
      end
    end,
  },
  signs = true,
  float = {
    header = "Diagnostics",
    source = true,
    border = "rounded",
  },
})

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.cmd("set conceallevel=0")
vim.opt_global.diffopt = "vertical"

if vim.g.neovide then
  -- vim.o.guifont = "FiraCode Nerd Font Mono:h14"
  -- vim.o.guifont = "CodeNewRoman Nerd Font Mono:h14"
  -- vim.o.guifont = "Neon:h14"
  -- vim.o.guifont = "Mononoki Nerd Font Mono:h14"
  -- vim.o.guifont = "Iosevka Nerd Font Mono:h13"
  -- vim.o.guifont = "JetBrains Mono:h12"
  vim.api.nvim_set_keymap("v", "<sc-c>", '"+y', { noremap = true })
  vim.api.nvim_set_keymap("n", "<sc-v>", 'l"+P', { noremap = true })
  vim.api.nvim_set_keymap("v", "<sc-v>", '"+P', { noremap = true })
  vim.api.nvim_set_keymap("c", "<sc-v>", '<C-o>l<C-o>"+<C-o>P<C-o>l', { noremap = true })
  vim.api.nvim_set_keymap("i", "<sc-v>", '<ESC>l"+Pli', { noremap = true })
  vim.api.nvim_set_keymap("t", "<sc-v>", '<C-\\><C-n>"+Pi', { noremap = true })
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_cursor_vfx_particle_lifetime = 3.2
  vim.g.neovide_cursor_vfx_particle_density = 12.0
  -- Helper function for transparency formatting
  -- vim.g.neovide_transparency = 0.96
  -- local alpha = function()
  --   return string.format("%x", math.floor(255 * (vim.g.transparency or 0.1)))
  -- end
  -- -- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  -- vim.g.transparency = 0.91
  -- vim.g.neovide_background_color = "#2a1b26" .. alpha()
  -- vim.g.neovide_background_color = "#FFFFFF"
end
