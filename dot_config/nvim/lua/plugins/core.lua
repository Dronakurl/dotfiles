-- local not_neovide = not vim.g.neovide

local function is_running_in_docker()
  -- Check for the /.dockerenv file
  local file = io.open("/.dockerenv", "r")
  if file then
    file:close()
    return true
  end

  -- Check /proc/1/cgroup for Docker related entries
  for line in io.lines("/proc/1/cgroup") do
    if line:find("docker") then
      return true
    end
  end

  return false
end

local colorscheme = ""
if is_running_in_docker() then
  colorscheme = "catppuccin-mocha"
else
  colorscheme = "tokyonight-moon"
end

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
