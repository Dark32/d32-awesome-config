local lain = require("lain")
local awful = require("awful")
local markup = lain.util.markup

local pulse = lain.widget.pulse {
   timeout = 2,
   settings = function()
      local vlevel = volume_now.left .. "%"
      if volume_now.muted == "yes" then
            vlevel = "MUTE"
      end
      widget:set_markup(" "..vlevel)
      widget.forced_width = 50
   end
}
pulse.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 2, function() -- middle click
        awful.spawn(string.format("pactl set-sink-volume %d 100%%", pulse.device))
        pulse.update()
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn(string.format("pactl set-sink-mute %d toggle", pulse.device))
        pulse.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn(string.format("pactl set-sink-volume %d +5%%", pulse.device))
        pulse.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(string.format("pactl set-sink-volume %d -5%%", pulse.device))
        pulse.update()
    end)
))
return pulse