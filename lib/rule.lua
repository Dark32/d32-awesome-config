local beautiful = require("beautiful")

local awful = require("awful")
local rule = {
  -- All clients will match this rule.
  { rule = { },
    properties = { 
      border_width = beautiful.border_width,      
      border_width=1,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false,
      titlebars_enabled = false
    }
  },
  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
      },
      class = {
        "Arandr",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "xtightvncviewer",
        "Pavucontrol",
      },
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    }, 
    properties = {
      floating = true ,
      titlebars_enabled = true
    }
  },

  -- Add titlebars to normal clients and dialogs
  { rule_any = {
      type = { 
        --"normal", 
        "dialog" 
      }
    },
    properties = { 
      titlebars_enabled = false 
    }
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
   { rule = { class = "Firefox" }, properties = { screen = 1, tag = screen[1].tags[4]} },
   { rule = { class = "Thunderbird" },  properties = { screen = 1, tag = screen[1].tags[6]} },
   { rule_any = { class = {"Thunar",'thunar'} }, properties = { screen = 1, screen[1].tags[7] } },
   { rule_any = { class = {"TelegramDesktop",'Telegram' }}, properties = { screen = 1, tag = screen[1].tags[5] } },
   { rule_any = { class = {"brick",'Brick' }}, properties = { screen = 1, tag = screen[1].tags[5] } },   
--   { rule_any = { class = {"leafpad",'Leafpad' }}, properties = { screen = 1, tag = screen[1].tags[5] } },
}

return rule;