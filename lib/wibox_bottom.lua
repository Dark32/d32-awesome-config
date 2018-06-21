local awful = require("awful")
local wibox = require("wibox")
local ram_widget = require('widget.ram-widget')
local cpu_widget = require('widget.cpu-widget')
local iface_widget = require('widget.iface-widget')
local pulse_widget = require('widget.pulse-widget')
local bat_widget = require('widget.bat-widget')

local lain = require("lain")
local separators = lain.util.separators
local larrow     = separators.arrow_left
local rarrow     = separators.arrow_right
local bg = wibox.container.background
local shape = wibox.container.background.shape
local fg = wibox.container.background.fg
local color = {
  red   = "#ff0000",
  green = "#00ff00",
  blue  = "#0000ff",
  alpha = "alpha",
  gray  = "#888888",
  black = "#000000",
  white = "#ffffff",
  dark_green = "#009900",
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


mytextclock = wibox.widget.textclock('%F %a %H:%M')

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
      rarrow(color.alpha, color.gray),
      {
        wibox.widget{
          pulse_widget,
          layout = wibox.layout.fixed.horizontal
        },
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },
      rarrow(color.gray, color.alpha),
      {
        iface_widget,
        bg = color.alpha,
        fg = color.dark_green,
        widget = wibox.container.background
      },
      rarrow(color.alpha, color.gray),
       {
        cpu_widget,
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },
      rarrow(color.gray, color.alpha),
      ram_widget.mem,
      rarrow(color.alpha, color.gray),   
      {
        ram_widget.swap,
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },     
      rarrow(color.gray, color.alpha),
      bat_widget,     
      rarrow(color.alpha, color.gray),
      {
        mytextclock,
        bg = color.gray,
        fg = color.black,
        widget = wibox.container.background
      },  
      rarrow(color.gray, color.alpha),
      mykeyboardlayout,
      wibox.widget.systray(),
      s.mylayoutbox,
    },
  }
  return wibox_bottom
end
