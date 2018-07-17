local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local vicious = require("vicious")
local color =require('lib.colors')
local rot_bg =require('lib.rotate_bg')

local ram_widget = require('widget.ram-widget')
local cpu_widget = require('widget.cpu-widget')
local iface_widget = require('widget.iface-widget')
local pulse_widget = require('widget.pulse-widget')
local bat_widget = require('widget.bat-widget')
local record_widget = require('lib.screencast2').widget
local caps_num_lock_widget = require('widget.caps_num_lock-widget')

local mytextclock = wibox.widget.textclock('%F %a %H:%M')
local mytemp = lain.widget.temp({
    settings = function() 
      widget:set_text('+'..coretemp_now..'°C') 
    widget.forced_width = 50
    end
    })

local net = lain.widget.net({
    settings = function()
        widget:set_markup(" " .. net_now.received .. " ↓↑ " .. net_now.sent .. " ")
        widget.forced_width = 100
    end
})
lain.widget.calendar({
    attach_to = {mytextclock },
    notification_preset = {
        font = "Monospace 10",
        fg   = color.white,
        bg   = color.dark_gray
    },
    cal = "bash -c 'cal  | sed -r -e \"s/_\\x08//g\"'"
})

local separators = lain.util.separators
local markup = lain.util.markup
local larrow     = separators.arrow_left
local rarrow     = separators.arrow_right

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
  s.wibox_bottom = awful.wibar({ position = "bottom", screen = s, height = 16 })
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
      rarrow(color.alpha, color.gray),      
      rot_bg:bg(net),       
      rot_bg:rarrow(),
      rot_bg:bg(pulse_widget),
      rot_bg:rarrow(),
      rot_bg:bg(iface_widget), 
      rot_bg:rarrow(),
      rot_bg:bg(cpu_widget),
      rot_bg:rarrow(),
      rot_bg:bg(mytemp),      
      rot_bg:rarrow(), 
      rot_bg:bg(ram_widget.mem),
      rot_bg:rarrow(),
      rot_bg:bg(ram_widget.swap),
      rot_bg:rarrow(),
      rot_bg:bg(bat_widget),   
      rot_bg:rarrow(),
      rot_bg:bg(mytextclock),  
      rarrow(rot_bg.color.from.bg, color.alpha),
      rot_bg:bg(record_widget,color.red, color.black),
--       bg(mykeyboardlayout,color.alpha,color.black),   
      caps_num_lock_widget.capslock,  
      caps_num_lock_widget.numlock, 
      wibox.widget.systray(),
      s.mylayoutbox,
    },
  }
  return wibox_bottom
end
