local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")

local color =require('lib.colors')

local ram_widget = require('widget.ram-widget')
local cpu_widget = require('widget.cpu-widget')
local iface_widget = require('widget.iface-widget')
local pulse_widget = require('widget.pulse-widget')
local bat_widget = require('widget.bat-widget')
local record_widget = require('lib.screencast2').widget
local caps_num_lock_widget = require('widget.caps_num_lock-widget')

mytextclock = wibox.widget.textclock('%F %a %H:%M')

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
local larrow     = separators.arrow_left
local rarrow     = separators.arrow_right

local arrows ={
  raag = rarrow(color.alpha, color.gray),
  raga = rarrow(color.gray, color.alpha),
  }


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
      arrows.raag,
      {
        wibox.widget{
          pulse_widget,
          layout = wibox.layout.fixed.horizontal
        },
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },
      arrows.raga,
      {
        iface_widget,
        bg = color.alpha,
        fg = color.dark_green,
        widget = wibox.container.background
      },
      arrows.raag,
       {
        cpu_widget,
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },
      arrows.raga,
      ram_widget.mem,
      arrows.raag, 
      {
        ram_widget.swap,
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },     
      arrows.raga,
      bat_widget,     
      arrows.raag,
      {
        mytextclock,
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },  
      arrows.raga,
      {
        record_widget,
        bg = color.red,
        fg = color.black,
        widget = wibox.container.background
      },
--      mykeyboardlayout,
      caps_num_lock_widget.capslock,      
      caps_num_lock_widget.numlock,
      wibox.widget.systray(),
      s.mylayoutbox,
    },
  }
  return wibox_bottom
end
