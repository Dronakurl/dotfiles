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

return is_running_in_docker
