-- Keymaps are automatically loaded on the VeryLazy event

local dd = function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end
vim.keymap.set("n", "dd", dd, { noremap = true, expr = true })

vim.keymap.set("n", "gm", "`", { desc = "Goto mark" })
-- vim.keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode" })
-- vim.keymap.set("t", "jj", "<ESC>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-G>", ":f<cr>", { desc = "Show current file" })
vim.keymap.set("n", "ä", "]", { remap = true })
vim.keymap.set("n", "ö", "[", { remap = true })
vim.keymap.set("n", "ü", "}", { remap = true })
vim.keymap.set("n", "ß", "{", { remap = true })
vim.keymap.set("n", "<leader>fz", "<leader>sz", { remap = true })
vim.keymap.set("n", "<leader>fc", "<leader>sz", { remap = true })
vim.keymap.set("n", "<leader>A", "<Cmd>normal! ggVG<CR>")

vim.keymap.set(
  "n",
  "gO",
  "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  { desc = "Put empty line above" }
)
vim.keymap.set(
  "n",
  "go",
  "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>",
  { desc = "Put empty line below" }
)

---@return integer|nil
local get_typos_client_id = function()
  -- Get clients that match the name 'typos_lsp'
  local clients = vim.lsp.get_clients({ name = "typos_lsp" })

  if #clients == 0 then
    -- vim.notify("typos not running!", vim.log.levels.INFO)
    return
  end

  -- Get the client ID of the first client
  ---@type integer
  local client_id = clients[1].id
  return client_id
end

---@return table<number, integer>
local get_buffers_with_typos = function()
  local client_id = get_typos_client_id()

  -- If no clients are running, notify the user
  if client_id == nil then
    -- vim.notify("typos not running!", vim.log.levels.INFO)
    return {}
  end

  -- Get buffers associated with the client
  ---@type table<number, integer>
  local bufs = vim.lsp.get_buffers_by_client_id(client_id)
  return bufs
end

---@return boolean
local is_typos_running = function()
  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()
  local bufs = get_buffers_with_typos()

  -- Check if current buffer is in the list
  return vim.tbl_contains(bufs, bufnr)
end

---@param enabled boolean
---@return nil
local set_typos = function(enabled)
  local bufnr = vim.api.nvim_get_current_buf()
  local client_id = get_typos_client_id()
  if client_id ~= nil then
    if enabled then
      vim.lsp.buf_attach_client(bufnr, client_id)
    else
      vim.lsp.buf_detach_client(bufnr, client_id)
    end
  end
end

Snacks.toggle({
  id = "typos",
  name = "Typos",
  get = function()
    return is_typos_running()
  end,
  set = function(enabled)
    set_typos(enabled)
  end,
}):map("<leader>ut")

-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg(""), "\n"),
--     vim.fn.getregtype(""),
--   }
-- end
--
-- local function setosc52(enabled)
--   if enabled then
--     vim.g.clipboard = "osc52"
--     return
--     -- vim.g.clipboard = {
--     --   name = "OSC 52",
--     --   copy = {
--     --     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     --     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--     --   },
--     --   paste = {
--     --     ["+"] = paste,
--     --     ["*"] = paste,
--     --   },
--     -- }
--     -- return
--   else
--     vim.g.clipboard = nil
--     return
--   end
-- end
--
-- local function is_osc52_set()
--   -- if vim.g.clipboard is not nil
--   return vim.g.clipboard ~= nil
-- end
--
-- Snacks.toggle({
--   id = "osc52",
--   name = "OSC52",
--   get = function()
--     return is_osc52_set()
--   end,
--   set = function(enabled)
--     setosc52(enabled)
--   end,
-- }):map("<leader>uy")
--
-- vim.keymap.set("n", "<c-h>", ":echo expand('%:p')<cr>", { desc = "Full file path" })
vim.keymap.set("n", "<c-7>", ":lua Snacks.terminal()<cr>", { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<c-7>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("n", "<c-1>", ":lua Snacks.terminal()<cr>", { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<c-1>", "<cmd>close<cr>", { desc = "Hide Terminal" })

vim.keymap.set("n", "Q", "@qj", { desc = "play macro" })
vim.keymap.set("x", "Q", ":norm @q<CR>", { desc = "play macro" })

vim.keymap.set({ "n", "x" }, "X", '"_d', { desc = "show diagnostics" })
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "show diagnostics" })
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>", { desc = "cd to current buffer" })

vim.keymap.set("n", "<leader>nn", ":messages<CR>", { desc = "messages" })
vim.keymap.set("n", "<leader>nc", ":messages clear<CR>", { desc = "messages clear" })

vim.keymap.set(
  "t",
  "<C-n>",
  vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
  { desc = "exit terminal mode" }
)
-- vim.keymap.set("n", "<leader>t", ":term<ENTER>", { desc = "open terminal" })
-- vim.keymap.set("n", "<M-l>", ":BufferLineCycleNext<ENTER>", { desc = "next buffer", silent = true })
-- vim.keymap.set("n", "<M-h>", ":BufferLineCyclePrev<ENTER>", { desc = "previous buffer", silent = true })
vim.keymap.set("n", "<M-l>", ":bn<ENTER>", { desc = "next buffer", silent = true })
vim.keymap.set("n", "<M-h>", ":bp<ENTER>", { desc = "previous buffer", silent = true })
vim.keymap.set("n", "<leader>l", ":b#<ENTER>", { desc = "last buffer", silent = true })
vim.keymap.set("n", "<leader>L", ":Lazy<ENTER>", { desc = "Lazy" })
-- vim.keymap.set("n", "<C-j>", ":cn<ENTER>", { desc = "next error", silent = true })
vim.keymap.set("n", "<leader>B", ":norm obreakpoint()<ESC>", { desc = "insert breakpoint" }) --, nowait = true })
vim.keymap.set("n", "q:", "<Nop>", { desc = "No command history" })

local dome = function(command, commanddisplay)
  -- local choice = vim.fn.confirm("Are you sure you want to run 'ruff -q .'?", "&Yes\n&No", 2)
  vim.cmd(command)
  local qflist = vim.fn.getqflist()
  if #qflist == 0 then
    vim.notify(
      "🚀 " .. commanddisplay .. " shows everything is fine. 😊",
      "info",
      ---@diagnostic disable-next-line
      { icon = "", title = "Ruff", hl = { border = "DiagnosticOk", title = "DiagnosticOk" } }
    )
  else
    require("trouble").open("quickfix")
  end
end

local clippyme = function()
  dome(
    ":cexpr system(' cargo clippy --all-features --message-format=short -- -D warnings -W clippy::pedantic -W clippy::nursery -W rust-2018-idioms ')",
    "Clippy"
  )
end

local ruffme = function()
  dome(":cexpr system('ruff check -q $(pwd)')", "Ruff check")
  -- Run ruff format --check and capture the output
  local formatCheckOutput = vim.fn.systemlist("ruff format --check $(pwd)")
  local exitStatus = vim.v.shell_error

  if exitStatus == 1 then
    local message = ""
    if #formatCheckOutput > 0 then
      message = table.concat(formatCheckOutput, "\n")
    end
    vim.notify(
      "🚨 Ruff format --check found formatting issues." .. "\n\n" .. message,
      "warn",
      ---@diagnostic disable-next-line
      { icon = "", title = "Ruff", hl = { title = "Error" }, timeout = 15000 }
    )
  end
end

local mypyme = function()
  local choice = vim.fn.confirm("Are you sure you want to run 'poetry run mypy -q .'?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd(":cgetexpr system('poetry run mypy --no-error-summary .')")
    require("trouble").open("quickfix")
  end
end

vim.keymap.set("n", "<leader>xr", ruffme, { desc = "Apply ruff and quickfix" })
vim.keymap.set("n", "<leader>xc", clippyme, { desc = "Apply clippy and quickfix" })
vim.keymap.set("n", "<leader>xm", mypyme, { desc = "Apply mypy and quickfix" })

vim.api.nvim_set_keymap("n", "<leader>uS", ":setlocal spell spelllang=de<CR>", { noremap = false, silent = true })

-- local Slumber = {}
-- Slumber.toggle = function()
--   local Terminal = require("toggleterm.terminal").Terminal
--   local slumber = Terminal:new({
--     cmd = "slumber",
--     hidden = true,
--     direction = "float",
--     float_opts = {
--       border = "none",
--       width = 100000,
--       height = 100000,
--     },
--     on_open = function(_)
--       vim.cmd("startinsert!")
--     end,
--     on_close = function(_) end,
--     count = 99,
--   })
--   slumber:toggle()
-- end
--
-- vim.keymap.set("n", "<leader>vs", Slumber.toggle, { desc = "Open in Slumber" })
