local xresources = require('beautiful.xresources')
local xrdb = xresources.get_current_theme()

local color = {
  alpha = "alpha",
  black = xrdb.color0,
  white = xrdb.color15,
  
  red     = xrdb.color9,
  green   = xrdb.color10,
  blue    = xrdb.color12,
  gray    = xrdb.color8,
  yellow  = xrdb.color11,
  magenta = xrdb.color13,
  cyan    = xrdb.color14,
  
  dark_red     = xrdb.color1,
  dark_green   = xrdb.color2,
  dark_blue    = xrdb.color4,
  dark_gray    = xrdb.color8,
  dark_yellow  = xrdb.color3,
  dark_magenta = xrdb.color5,
  dark_cyan    = xrdb.color15,
  
  l_green = '#bbffbb',
  l_gray  = xrdb.color7
}

return color