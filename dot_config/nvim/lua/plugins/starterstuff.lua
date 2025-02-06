local logos = {
  --  [[
  --  ____                        _               _
  -- |  _ \ _ __ ___  _ __   __ _| | ___   _ _ __| |
  -- | | | | '__/ _ \| '_ \ / _` | |/ / | | | '__| |
  -- | |_| | | | (_) | | | | (_| |   <| |_| | |  | |
  -- |____/|_|  \___/|_| |_|\__,_|_|\_\\__,_|_|  |_|
  --
  --  ]],
  [[
   |) /? () |\| /\ /< |_| /? |_


  ]],
  [[
   __   __   __                       __      
  |  \ |__) /  \ |\ |  /\  |__/ |  | |__) |   
  |__/ |  \ \__/ | \| /~~\ |  \ \__/ |  \ |___
  ]],
}

math.randomseed(os.time())

local function get_random_logo()
  return logos[math.random(#logos)]
end

local function file_exists(name)
  local f = io.open(name, "r")
  if f then
    f:close()
  end
  return f ~= nil
end

local function get_random_image()
  local images = {
    os.getenv("HOME") .. "/Archiv/Tux.png",
    os.getenv("HOME") .. "/Archiv/neovim-mark.png",
    os.getenv("HOME") .. "/Archiv/python-logo.png",
    os.getenv("HOME") .. "/Archiv/emojipng.com-2375766.png", -- cuddlyferris.png",
  }
  math.randomseed(os.time())
  local image_path = images[math.random(#images)]
  return file_exists(image_path) and image_path or nil
end

local function get_image_pane()
  local ok, _ = pcall(function()
    vim.fn.system("type chafa")
  end)

  if not ok or vim.v.shell_error ~= 0 then
    return {}
  end

  local img = get_random_image()
  if img == nil then
    return { pane = 1, { section = "terminal", cmd = "echo ''" } }
  end
  return {
    pane = 1,
    {
      section = "terminal",
      cmd = "chafa " .. get_random_image() .. " --format symbols --symbols space -O 9 --center on --size x12; sleep .1",
      height = 15,
      padding = 7,
    },
  }
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      statuscolumn = { enabled = true },
      dashboard = {
        preset = {
          header = get_random_logo(),
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "󰝂 ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
            {
              icon = "",
              key = "o",
              desc = "Objectmvp",
              action = function()
                require("mini.bufremove").delete(0)
                require("neo-tree.command").execute({ toggle = true, dir = os.getenv("HOME") .. "/objectmvp" })
              end,
            },
            {
              icon = "󰚑",
              key = "d",
              desc = "DDT frontend",
              action = function()
                require("mini.bufremove").delete(0)
                require("neo-tree.command").execute({ toggle = true, dir = os.getenv("HOME") .. "/ddt-frontend" })
              end,
            },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              -- action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              action = "<leader>sz",
            },
            -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            {
              icon = " ",
              key = "s",
              desc = "Restore Session",
              action = ":lua require('persistence').select()",
            },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { pane = 1, { section = "header", gap = 1, padding = 1 } },
          get_image_pane(),
          {
            pane = 2,
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
        },
      },
    },
  },
}
