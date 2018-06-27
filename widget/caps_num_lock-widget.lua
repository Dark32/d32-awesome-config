local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup
local colors = require('lib.colors')

local function check(key,that)
 awful.spawn.with_line_callback(
    "bash -c 'sleep 0.2 && xset q'",
    {
      stdout = function (line)
        if line:match(key) then
          local status = line:gsub(".*("..key..":%s+)(%a+).*", "%2")
          if status == "on" then
            that.markup = that.activated
          else
            that.markup = that.deactivated
          end
        end
      end
    }
  )
end

local capslock = wibox.widget {
  widget = wibox.widget.textbox,
  align = "center",
  valign = "center",
  forced_width = 15,
}


local numlock = wibox.widget {
  widget = wibox.widget.textbox,
  align = "center",
  valign = "center",
  forced_width = 15,
}
local widgets = { 
  capslock  = capslock,
  numlock   = numlock,
}

capslock.activated    = markup.fg.color(colors.dark_green,  markup.bold('A'))
capslock.deactivated  = markup.fg.color(colors.dark_gray,   markup.bold('A'))
numlock.activated     = markup.fg.color(colors.dark_green,  markup.bold('N'))
numlock.deactivated   = markup.fg.color(colors.dark_gray,   markup.bold('N'))

function capslock:check() check("Caps Lock", self) end
function numlock:check() check("Num Lock", self) end

capslock:check()
numlock:check()

return widgets