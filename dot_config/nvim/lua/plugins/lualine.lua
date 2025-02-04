-- local nvimbattery = {
--   function()
--     return require("battery").get_status_line()
--   end,
--   -- color = { fg = colors.violet, bg = colors.bg },
-- }
local activated_venv = function()
  local venv_name = require("venv-selector").venv()
  if venv_name ~= nil then
    -- objectmvp--ytfYSZ4-py3.12
    local res = string.gsub(venv_name, ".*/pypoetry/virtualenvs/", "")
    res = string.gsub(res, "%-%-.*%-py3%.", "--py3.")
    if string.match(res, ".venv$") then
      local paths = {}
      for s in string.gmatch(res, "[^/]+") do
        table.insert(paths, s)
      end
      if #paths > 1 then
        res = paths[#paths - 1] .. "/" .. paths[#paths]
      end
    end
    return res
  else
    return "venv"
  end
end

return {
  {
    "justinhj/battery.nvim",
    enabled = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("battery").setup({})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        -- lualine_c = {
        --   {
        --     "filename",
        --     path = 3,
        --   },
        -- },
        -- lualine_x = {  },
        -- lualine_x = { "diagnostics" },
        -- lualine_y = {
        --   {
        --     function()
        --       return require("tmux-status").tmux_windows()
        --     end,
        --     cond = function()
        --       return require("tmux-status").show()
        --     end,
        --     padding = { left = 3 },
        --   },
        -- },
        lualine_y = { activated_venv },
        lualine_z = {
          -- nvimbattery,
          function()
            return " " .. os.date("%R")
          end,
        },
      },
    },
  },
}
