local awful   = require("awful")
local wibox   = require("wibox")
local lain    = require("lain")
local gears   =  require("gears")
local gtable  = require("gears.table")
local debug   = require('gears.debug')
local colors  = require('lib.colors')
local beautiful = require("beautiful")

local style = {}

function style.margin(widget,color, l,r,t,b)
  r = r or l
  t = t or r
  b = b or t
  return {
        widget,
        left = l,
        right = r,
        top = t,
        bottom = b,
        color = color,
        layout = wibox.container.margin
      }
end

function style.mirror_v(widget)
  return wibox.container.mirror(widget, {vertical = true})
end


return style