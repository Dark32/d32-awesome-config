local awful       = require("awful")
local localize    = require("lib.localize")
local lain        = require("lain")
local markup      = lain.util.markup
local mode_widget = require('widget.mode-widget')
 
local key_resize = mode_widget.prepare_key {
 {{},'Up',   'Up',    function (c) c:relative_move( 0, 0,  0, -5 ) end },
 {{},'Down', 'Down',  function (c) c:relative_move( 0, 0,  0, 15 ) end },
 {{},'Right','Right', function (c) c:relative_move( 0, 0,  5, 0  ) end },
 {{},'Left', 'Left',  function (c) c:relative_move( 0, 0,  -5, 0 ) end },
}
mode_widget:create('resize',key_resize, 'Смена размера' )

 local function resize2(c)
  mode_widget:grabber('resize', c)
 end
 
 local function float_move2_move (c, pos)
    c.floating = true
    c.ontop = true
    local position = c:geometry()
    c:geometry({
      x = position.x,
      y = position.y,
      width = c.screen.geometry.width/2.5,
      height= c.screen.geometry.height/2.5
    })
    pos(c)
 end
 
local float_move2_key = mode_widget.prepare_key {
 {{},'q', '⬉',  function (c) float_move2_move(c,awful.placement.top_left      ) end, true },
 {{},'w', '⬆',  function (c) float_move2_move(c,awful.placement.top           ) end, true },
 {{},'e', '⬈',  function (c) float_move2_move(c,awful.placement.top_right     ) end, true },
 {{},'a', '⬅',  function (c) float_move2_move(c,awful.placement.left          ) end, true },
 {{},'s', '*',  function (c) float_move2_move(c,awful.placement.centered      ) end, true },
 {{},'d', '➡',  function (c) float_move2_move(c,awful.placement.right         ) end, true },
 {{},'z', '⬋',  function (c) float_move2_move(c,awful.placement.bottom_left   ) end, true },
 {{},'x', '⬇',  function (c) float_move2_move(c,awful.placement.bottom        ) end, true },
 {{},'c', '⬊',  function (c) float_move2_move(c,awful.placement.bottom_right  ) end, true },
 
}
mode_widget:create('float_move',float_move2_key)

local function float_move2(c)
  mode_widget:grabber('float_move', c)
 end
 
 
local func = {
  fullscreen      =function (c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                  end,
  close           =  function (c) c:kill()                       end,
  move_to_screen  =  function (c) c:move_to_screen()             end,
  top             =  function (c) c.ontop = not c.ontop          end,
  minimize        =  function (c) c.minimized = not c.minimized  end,
  restore         = function ()
                      local c = awful.client.restore()
                      -- Focus restored client
                      if c then
                        client.focus = c
                        c:raise()
                      end
                    end,
  maximize        = function (c)
                      c.maximized = not c.maximized
                      c:raise()
                    end,
  move_down       = function (c) c:relative_move( 0,  5, 0, 0) end,
  move_up         = function (c) c:relative_move( 0, -5, 0, 0) end,
  move_left       = function (c) c:relative_move(-5,  0, 0, 0) end,
  move_right      = function (c) c:relative_move( 5,  0, 0, 0) end,
  resize          = function (c) resize2(c)                    end,
  clien_float_r   = function (c) float_move2(c)                end,
  
  }
local clientkeys = awful.util.table.join(
  awful.key({ modkey,           }, "f",     func.fullscreen,                localize.localkey.fullscreen),
  awful.key({ altKey            }, "F4",    func.close,                     localize.localkey.close),
  awful.key({ modkey, "Shift"   }, "space", awful.client.floating.toggle,   localize.localkey.float),
  awful.key({ modkey,           }, "o",     func.move_to_screen,            localize.localkey.move_to_screen),
  awful.key({ modkey, "Shift"   }, "t",     func.top,                       localize.localkey.top),
--  awful.key({ modkey,           }, "n",     func.minimize,                  localize.localkey.minimize),
--  awful.key({ modkey, "Control" }, "n",     func.restore,                   localize.localkey.restore),
  awful.key({ modkey,           }, "m",     func.maximize,                  localize.localkey.maximize),
  awful.key({ modkey, "Shift"   }, "Down",  func.move_down,                 localize.localkey.move_down),
  awful.key({ modkey, "Shift"   }, "Up",    func.move_up,                   localize.localkey.move_up),
  awful.key({ modkey, "Shift"   }, "Left",  func.move_left,                 localize.localkey.move_left),
  awful.key({ modkey, "Shift"   }, "Right", func.move_right,                localize.localkey.move_right),
  awful.key({ modkey            }, "r",     func.resize,                    localize.localkey.resize),
  awful.key({ modkey            }, "n",     func.clien_float_r,             localize.localkey.clien_float_r)

  --awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster())   end,        {description = "move to master", group = "client"}),
)
return clientkeys