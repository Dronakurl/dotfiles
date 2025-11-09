-- Check if minimal mode file exists
local minimal_file = vim.fn.expand("~/.minimal")
local use_minimal = vim.fn.filereadable(minimal_file) == 1

if use_minimal then
  -- Minimal configuration when ~/.minimal exists
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Basic settings
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.expandtab = true
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.smartindent = true

  -- Setup lazy with only suda.vim
  require("lazy").setup({
    {
      "lambdalisue/suda.vim",
      cmd = { "SudaWrite", "SudaRead" },
    },
  })
else
  -- Full configuration
  require("config.lazy")
end
