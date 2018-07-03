local awful = require("awful")
local localize = require("lib.localize")
local lain = require("lain")
local markup = lain.util.markup
local mode_tooltip = require('widget.mode-tooltip')

local function resize(c)
  local grabber
  grabber = awful.keygrabber.run(function(mod, key, event)
    c.screen.text_mode:set_text(" | resize ( )")
    if event == "release" then return end
    if     key == 'Up'    then c:relative_move( 0, 0,  0, -5 )
    elseif key == 'Down'  then c:relative_move( 0, 0,  0,  15 )
    elseif key == 'Right' then c:relative_move( 0, 0,  5,  0 )
    elseif key == 'Left'  then c:relative_move( 0, 0, -5,  0 )
    else   
      awful.keygrabber.stop(grabber)
      c.screen.text_mode:set_text("")
    end
   end
   )
 end
 
local key_resize =mode_tooltip.prepare_key {
 {{},'Up',   'Up',    function (c) c:relative_move( 0, 0,  0, -5 ) end },
 {{},'Down', 'Down',  function (c) c:relative_move( 0, 0,  0, 15 ) end },
 {{},'Right','Right', function (c) c:relative_move( 0, 0,  5, 0  ) end },
 {{},'Left', 'Left',  function (c) c:relative_move( 0, 0,  -5, 0 ) end },
}
mode_tooltip:create('resize',key_resize )

 local function resize2(c)
  mode_tooltip:grabber('resize', c)
 end
 
 local function float_move(c)
  local grabber
    awful.client.floating.set(c, true)
    c:geometry({
    x =c:geometry().x,
    y = c:geometry().y,
    width = c.screen.geometry.width/2.5,
    height= c.screen.geometry.height/2.5
})
    grabber = awful.keygrabber.run(function(mod, key, event)
      c.screen.text_mode.markup = markup.bg.color("#444444","Fast Move [q][w][e][a][s]C[d][z][x][c]")
      if event == "release" then return end
      if     key == 'q' then awful.placement.top_left(c)
      elseif key == 'w' then awful.placement.top(c)
      elseif key == 'e' then awful.placement.top_right(c)
      elseif key == 'a' then awful.placement.left (c)
      elseif key == 's' then awful.placement.centered(c)
      elseif key == 'd' then awful.placement.right(c)
      elseif key == 'z' then awful.placement.bottom_left(c)
      elseif key == 'x' then awful.placement.bottom(c)    
      elseif key == 'c' then awful.placement.bottom_right(c)
      else   
        awful.keygrabber.stop(grabber)
        c.screen.text_mode:set_text("")
      end
     end
    )
 end
 
 
local func = {
  fullscreen      =function (c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                  end,
  close           =  function (c) c:kill()                          end,
  move_to_screen  =    function (c) c:move_to_screen()              end,
  top             =   function (c) c.ontop = not c.ontop            end,
  minimize        =     function (c) c.minimized = not c.minimized  end,
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
  resize          = function (c) resize2(c)                     end,
  clien_float_r   = function (c) float_move(c)                 end,
  
  }
local clientkeys = awful.util.table.join(
  awful.key({ modkey,           }, "f",     func.fullscreen,                localize.localkey.fullscreen),
  awful.key({ altKey            }, "F4",    func.close,                     localize.localkey.close),
  awful.key({ modkey, "Shift"   }, "space", awful.client.floating.toggle,   localize.localkey.float),
  awful.key({ modkey,           }, "o",     func.move_to_screen,            localize.localkey.move_to_screen),
  awful.key({ modkey,           }, "t",     func.top,                       localize.localkey.top),
--  awful.key({ modkey,           }, "n",     func.minimize,                  localize.localkey.minimize),
--  awful.key({ modkey, "Control" }, "n",     func.restore,                   localize.localkey.restore),
  awful.key({ modkey,           }, "m",     func.maximize,                  localize.localkey.maximize),
  awful.key({ modkey, "Control" }, "Down",  func.move_down,                 localize.localkey.move_down),
  awful.key({ modkey, "Control" }, "Up",    func.move_up,                   localize.localkey.move_up),
  awful.key({ modkey, "Control" }, "Left",  func.move_left,                 localize.localkey.move_left),
  awful.key({ modkey, "Control" }, "Right", func.move_right,                localize.localkey.move_right),
  awful.key({ modkey            }, "r",     func.resize,                    localize.localkey.resize),
  awful.key({ modkey            }, "n",     func.clien_float_r,             localize.localkey.clien_float_r)

  --awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster())   end,        {description = "move to master", group = "client"}),
)
return clientkeys