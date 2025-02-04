-- Detect whether nvim is running inside tmux or not
local is_tmux = os.getenv("TMUX") ~= nil
return {
  {
    "jpalardy/vim-slime",
    init = function()
      if is_tmux then
        vim.g.slime_target = "tmux"
      else
        vim.g.slime_target = "wezterm"
      end
      -- vim.g.slime_default_config = { pane_direction = "right" }
      vim.g.slime_paste_file = os.getenv("HOME") .. "/.slime_paste"
      -- vim.g.kitty = 0
      vim.g.slime_python_ipython = nil
      -- vim.cmd("let g:slime_default_config = {'socket_name':trim(get(split($TMUX,','),0)), 'target_pane': ':1.0'}")
      vim.g.slime_bracketed_paste = 1

      vim.api.nvim_create_user_command("IPyOff", function()
        vim.g.slime_python_ipython = nil
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("IPyOn", function()
        vim.g.slime_python_ipython = 1
      end, { nargs = 0 })
    end,
  },
}
