local awful = require("awful")
local localize = require("lib.localize")

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
  resize          = function (c) resize(c)                     end,
  }
local clientkeys = awful.util.table.join(
  awful.key({ modkey,           }, "f",     func.fullscreen,                localize.localkey.fullscreen),
  awful.key({ altKey            }, "F4",    func.close,                     localize.localkey.close),
  awful.key({ modkey, "Shift"   }, "space", awful.client.floating.toggle,   localize.localkey.float),
  awful.key({ modkey,           }, "o",     func.move_to_screen,            localize.localkey.move_to_screen),
  awful.key({ modkey,           }, "t",     func.top,                       localize.localkey.top),
  awful.key({ modkey,           }, "n",     func.minimize,                  localize.localkey.minimize),
  awful.key({ modkey, "Control" }, "n",     func.restore,                   localize.localkey.restore),
  awful.key({ modkey,           }, "m",     func.maximize,                  localize.localkey.maximize),
  awful.key({ modkey, "Control" }, "Down",  func.move_down,                 localize.localkey.move_down),
  awful.key({ modkey, "Control" }, "Up",    func.move_up,                   localize.localkey.move_up),
  awful.key({ modkey, "Control" }, "Left",  func.move_left,                 localize.localkey.move_left),
  awful.key({ modkey, "Control" }, "Right", func.move_right,                localize.localkey.move_right),
  awful.key({ modkey            }, "r",     func.resize,                    localize.localkey.resize)

  --awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster())   end,        {description = "move to master", group = "client"}),
)
return clientkeys