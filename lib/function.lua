local awful = require("awful")
local wibox = require("wibox")

function run_once(cmd, app)
  local findme = cmd
  if app then
     findme = app 
  else    
    local firstspace = cmd:find(" ")
    if firstspace then
      findme = cmd:sub(0, firstspace-1)
    end
  end
  awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

function get_home()
  return os.getenv("HOME")
end

function bg(widget, bg, fg)
      return {
        wibox.widget{
          widget,
          layout = wibox.layout.fixed.horizontal
        },
        bg = bg,
        fg = fg,
        widget = wibox.container.background
      }
end
