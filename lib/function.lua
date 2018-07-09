local awful = require("awful")

function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

function get_home()
  return os.getenv("HOME")
end
