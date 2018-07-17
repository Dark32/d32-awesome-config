local awful       = require("awful")
local lain        = require("lain")
local wibox       = require("wibox")
local color       = require('lib.colors')
local separators  = lain.util.separators
local larrow      = separators.arrow_left
local rarrow      = separators.arrow_right
local table       = table
local rotate = {
  color = {
    ignore = 'ignore',
    rotate = {
      { 
        bg = color.gray,
        fg = color.white,
      },
      { 
        bg = color.white,
        fg = color.black,
      },
      { 
        bg = color.black,
        fg = color.white,
      },
    },
    from = {
      bg = color.dark_gray,
      fg = color.white,
    },
    to    = {
      bg = color.gray,
      fg = color.white,
    }
  }
}
function rotate:rotate(  )
  table.insert( self.color.rotate, 1, table.remove( self.color.rotate, #self.color.rotate ) )
  self.color.from, self.color.to =  self.color.to, self.color.rotate[1]
end

function rotate:separator(separator)
  return separator( self.color.from.bg, self.color.to.bg)
end

function rotate:rarrow()
  return self:separator(lain.util.separators.arrow_right)
end

function rotate:bg(widget,fg)
 if fg == nil then 
    fg =  self.color.to.fg
  elseif fg == self.color.ignore then 
    fg = nil  
  end
  
  w = {
    wibox.widget{
      widget,
      layout = wibox.layout.fixed.horizontal
    },
    bg =  self.color.to.bg,
    fg = fg,
    widget = wibox.container.background
  }
  rotate:rotate()
  return w
end

return rotate