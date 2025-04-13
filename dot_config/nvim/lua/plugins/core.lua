-- local not_neovide = not vim.g.neovide

local colorscheme = "tokyonight-moon"
-- if require("config.is_running_in_docker")() then
--   -- if is_running_in_docker() then
--   colorscheme = "catppuccin-mocha"
-- else
--   colorscheme = "tokyonight-moon"
-- end

return {

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = colorscheme,
      -- colorscheme = "catppuccin-mocha",
      -- colorscheme = "habamax",
      -- colorscheme = "kanagawa-dragon",
      -- colorscheme = "tokyonight",
      -- colorscheme = "carbonfox",
      -- colorscheme = "duskfox",
      -- colorscheme = "kanagawa",
      -- colorscheme = "flexoki-dark",
      -- colorscheme = "gruvbox",
      -- colorscheme = "night-owl",
      -- colorscheme = "github_dark_dimmed",
    },
  },
}
