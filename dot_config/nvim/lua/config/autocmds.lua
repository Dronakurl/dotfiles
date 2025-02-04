-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_user_command("W", function()
  vim.cmd("write")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Wa", function()
  vim.cmd("wa")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Q", function()
  vim.cmd("qa")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Config", function()
  require("lazyvim.util").pick.config_files()()
end, { nargs = 0 })

vim.api.nvim_create_user_command("Uuid", function()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  local random = math.random
  local uuid = string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
    return string.format("%x", v)
  end)
  vim.api.nvim_put({ uuid }, "", true, true)
end, { nargs = 0 })

vim.api.nvim_create_user_command("JsonFormat", function()
  vim.cmd("%!python -m json.tool")
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python", -- filetype for which to run the autocmd
  callback = function()
    -- automatically capitalize boolean values. Useful if you come from a
    -- different language, and lowercase them out of habit.
    vim.cmd.inoreabbrev("<buffer> true True")
    vim.cmd.inoreabbrev("<buffer> false False")

    -- in the same way, we can fix habits regarding comments or None
    vim.cmd.inoreabbrev("<buffer> -- #")
    vim.cmd.inoreabbrev("<buffer> null None")
    vim.cmd.inoreabbrev("<buffer> none None")
    vim.cmd.inoreabbrev("<buffer> nil None")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
