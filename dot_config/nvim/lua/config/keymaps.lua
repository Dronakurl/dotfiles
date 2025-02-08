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

vim.keymap.set("n", "ä", "]", { remap = true })
vim.keymap.set("n", "ö", "[", { remap = true })
vim.keymap.set("n", "ü", "}", { remap = true })
vim.keymap.set("n", "ß", "{", { remap = true })
vim.keymap.set("n", "<leader>fz", "<leader>sz", { noremap = false, expr = false })

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

local wurst = function()
  -- Get clients that match the name 'typos_lsp'
  local clients = vim.lsp.get_clients({ name = "typos_lsp" })

  -- If no clients are running, notify the user
  if #clients == 0 then
    vim.notify("typos not running!", vim.log.levels.INFO)
    return
  end

  -- Get the client ID of the first client
  local client_id = clients[1].id

  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get buffers associated with the client
  local bufs = vim.lsp.get_buffers_by_client_id(client_id)

  -- Check if current buffer is in the list
  if vim.tbl_contains(bufs, bufnr) then
    -- Detach the client from the buffer
    vim.lsp.buf_detach_client(bufnr, client_id)
    vim.notify("🔕 Typo diagnostic turned off", vim.log.levels.INFO)
  else
    -- Attach the client to the buffer
    vim.lsp.buf_attach_client(bufnr, client_id)
    vim.notify("🔔 Typo diagnostic turned on", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<leader>ut", wurst, { desc = "toggle typos" })

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

local ruffme = function()
  -- local choice = vim.fn.confirm("Are you sure you want to run 'ruff -q .'?", "&Yes\n&No", 2)
  local choice = 1
  if choice == 1 then
    -- vim.notify("Running ruff -q " .. vim.inspect(vim.fn.getcwd()), "debug", { icon = "", title = "Ruff" })
    vim.cmd(":cexpr system('ruff check -q $(pwd)')")
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify(
        "🚀 Ruff check shows everything is fine. 😊",
        "info",
        ---@diagnostic disable-next-line
        { icon = "", title = "Ruff", hl = { border = "DiagnosticOk", title = "DiagnosticOk" } }
      )
    else
      require("trouble").open("quickfix")
    end

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
end

local mypyme = function()
  local choice = vim.fn.confirm("Are you sure you want to run 'poetry run mypy -q .'?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd(":cgetexpr system('poetry run mypy --no-error-summary .')")
    require("trouble").open("quickfix")
  end
end

vim.keymap.set("n", "<leader>xr", ruffme, { desc = "Apply ruff and trouble" })
vim.keymap.set("n", "<leader>xm", mypyme, { desc = "Apply mypy and trouble" })

vim.api.nvim_set_keymap("n", "<leader>uS", ":setlocal spell spelllang=de<CR>", { noremap = false, silent = true })
