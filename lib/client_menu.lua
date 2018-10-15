local awful = require("awful")
local beautiful = require("beautiful")
local debug     = require('gears.debug')
local dump        = debug.dump

--local geo = screen[1].geometry
--local new_width = math.ceil(geo.width/2)
--local new_width2 = geo.width - new_width
--screen[1]:fake_resize(geo.x, geo.y, new_width, geo.height)
--screen.fake_add(geo.x + new_width, geo.y, new_width2, geo.height)

return function(c)
  local cli_min =  c.minimized and "Развернуть" or "Свернуть"
  local cli_top = c.ontop  and "Поверх всех" or beautiful.tasklist_ontop.."Поверх всех"
  local cli_float =  c.floating and  beautiful.tasklist_floating.."Floating" or "Floating"
  local cli_above = c.above and "Выше" or "▴Выше"
  local cli_below = c.below and "Ниже" or "▾Ниже"
  local cli_sticky = c.sticky and "Отлепить" or "▪Прилепить"
--создаем список тегов(в виде подменю), для перемещения клиента на другой тег
  local screen_menu = {}

--  for scr in screen:screen () do
----    if not tag.selected then
--      table.insert(screen_menu, { scr.index, function() awful.client.movetoscreen( scr.index) end } )
----    end
--  end
  
  local tag_menu = { }
  for i,tag in pairs(screen[c.screen].tags) do
    if not tag.selected then
      table.insert(tag_menu, { tag.name, function() awful.client.movetotag(tag) end } )
    end
  end

  local taskmenu = awful.menu({ 
      items = { 
        { "На tag", tag_menu },
        { "На экран", screen_menu },
        { cli_min,    function() c.minimized = not c.minimized    end },
        { "Полный",   function() c.fullscreen = not c.fullscreen  end, beautiful.layout_fullscreen },
        { cli_float,  function() awful.client.floating.toggle(c)  end },
        { cli_top,    function() c.ontop = not c.ontop    end }, 
        { cli_above,  function() c.above = not c.above    end }, 
        { cli_below,  function() c.below = not c.below    end },         
        { cli_sticky, function() c.sticky = not c.sticky  end }, 
        { "Закрыть",  function() c:kill()                 end },
      },
      width = 200
    })
  taskmenu:show()
  return taskmenu
end