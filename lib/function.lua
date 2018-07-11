local awful = require("awful")
local lain = require("lain")
local wibox = require("wibox")
local color =require('lib.colors')
local separators = lain.util.separators
local larrow     = separators.arrow_left
local rarrow     = separators.arrow_right

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
