local awful = require("awful")
local wibox = require("wibox")
local ram_widget = require('widget.ram-widget')
local cpu_widget = require('widget.cpu-widget')
--local iface_widget = require('widget.iface-widget')
local pulse_widget = require('widget.pulse-widget')
local bat_widget = require('widget.bat-widget')

local taglist_buttons = awful.util.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end)
  --awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  --awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)


return function(s)
  s.wibox_bottom = awful.wibar({ position = "bottom", screen = s })
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
  s.text_mode = wibox.widget.textbox()
  s.mypromptbox = awful.widget.prompt()
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end)
        )
      )
  s.wibox_bottom:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      s.text_mode,
      s.mypromptbox,
    },
    {layout = wibox.layout.fixed.horizontal,},
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget{
        pulse_widget,
        layout = wibox.layout.fixed.horizontal
        },
--      iface_widget,
      cpu_widget,
      ram_widget,
      bat_widget,
      mytextclock,      
      mykeyboardlayout,
      wibox.widget.systray(),
      s.mylayoutbox,
    },
  }
  return wibox_bottom
end
