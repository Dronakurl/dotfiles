-- local io = require("io")
--
-- local get_output = function(command_line)
--   local file = os.execute(command_line .. " > /dev/null 2>&1")
--   if file ~= 0 then
--     return false, "Command not found."
--   end
--
--   local lfile = assert(io.popen(command_line, "r"))
--   local output = lfile:read("*all")
--   lfile:close()
--
--   return true, output
-- end
--
-- local cowsay = function(say)
--   -- Try to get the output for cowsay command
--   local file = assert(io.open(os.getenv("HOME")..".local/cowsay.txt", "w"))
--   file:write(say)
--   file:close()
--   local result, output = get_output("cowsay " .. say)
--   if not result then
--     return "Moooo"
--   end
--   return output
-- end
--
-- return cowsay
