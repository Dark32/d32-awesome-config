-- Key bindings
modkey = "Mod4"
local add = func.add_key

local globalkeys = gears.table.join(
   add("awesome: show help", modkey.."-/", hotkeys_popup.show_help),
   add("tag: view previous", modkey.."-Left", awful.tag.viewprev),
   add("tag: view next",modkey.."-Right", awful.tag.viewnext),
   add("tag: go back", modkey.."-Escape", awful.tag.history.restore),
   add("client: focus next by index", modkey.."-w", function()
          awful.client.focus.byidx(-1)
   end),
   add("client: focus previous by index", modkey.."-e", function()
          awful.client.focus.byidx(1)
   end),
   add("awesome: show main menu", modkey.."-u", function()
          mymainmenu:show()
   end),

    -- Layout manipulation
   add("client: swap with next client by index", modkey.."-Shift-w", function()
          awful.client.swap.byidx(-1)
   end),
   add("client: swap with previous client by index", modkey.."-Shift-e", function()
          awful.client.swap.byidx(1)
   end),
   add("screen: focus the next screen", modkey.."-Control-w", function()
          awful.screen.focus_relative(1)
   end),
   add("screen: focus the previous screen", modkey.."-Control-e", function()
          awful.screen.focus_relative(-1)
   end),
   add("client: jump to urgent client", modkey.."-u", awful.client.jumpto),
   add("client: go back", modkey.."-Tab", function()
          awful.client.focus.history.previous()
          if client.focus then
             client.focus:raise()
          end
   end),

   -- Standard program
   add("launcher: open a terminal", modkey.."-Return", function()
          awful.spawn(terminal)
   end),
   add("awesome: reload awesome", modkey.."-Shift-r", awesome.restart),
   add("awesome: exit awesome", modkey.."-Shift-e", awesome.quit),

   add("layout: increase master width factor", modkey.."-l", function()
          awful.tag.incmwfact(0.05)
   end),
   add("layout: decrease master width factor", modkey.."-h", function()
          awful.tag.incmwfact(-0.05)
   end),
   add("layout: increase the number of master clients", modkey.."-Shift-h", function()
          awful.tag.incnmaster(1, nil, true)
   end),
   add("layout: decrease the number of master clients", modkey.."-Shift-l", function()
          awful.tag.incnmaster(-1, nil, true)
   end),
   add("layout: increase the number of columns", modkey.."-Control-h", function()
          awful.tag.incncol(1, nil, true)
   end),
   add("layout: decrease the number of columns", modkey.."-Control-l", function()
          awful.tag.incncol(-1, nil, true)
   end),
   add("layout: select next", modkey.."-space", function()
          awful.layout.inc(1)
   end),
   add("layout: select previous", modkey.."-Shift-space", function()
          awful.layout.inc(-1)
   end),

   add("client: restore minimized", modkey.."-Control-n", function()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
             client.focus = c
             c:raise()
          end
   end),

   -- Prompt
   add("launcher: run prompt", modkey.."-r", function()
          awful.screen.focused().mypromptbox:run()
   end),
   add("awesome: lua execute prompt", modkey.."-x", function()
          awful.prompt.run {
             prompt       = "Execute Lua code: ",
             texbox       = awful.screen.focused().mypromptbox.widget,
             exe_callback = awful.util.eval,
             history_path = awful.util.get_cache_dir().."/history_eval"
          }
   end),
   
   -- Menubar
   add("launcher: show the menubar", modkey.."-p", function()
          menubar.show()
   end),

   -- Custom apps
   add("applications: xfce4-appfinder", modkey.."-q", function()
          awful.spawn("xfce4-appfinder --collapsed",
                      { floating = true,
                        tag = mouse.screen.selected_tag,
                        placement = awful.placement.centered })
   end),

   add("move to previous screen", modkey.."-Shift-Ctrl-w", function()
          local cur_screen = awful.screen.focused()
          local client_num = #cur_screen.clients
          if client_num > 0 then
             local prevscreen = cur_screen.index - 1
             if prevscreen < 1 then
                prevscreen = screen.count() - prevscreen
             end
             client.focus:move_to_screen(screen[prevscreen])
             awful.screen.focus_relative(1)
          end
   end),

   add("move to next screen", modkey.."-Shift-Ctrl-e", function()
          local cur_screen = awful.screen.focused()
          local client_num = #cur_screen.clients
          if client_num > 0 then
             local nextscreen = cur_screen.index + 1
             if nextscreen > screen.count() then
                nextscreen = 1
             end
             client.focus:move_to_screen(screen[nextscreen])
             awful.screen.focus_relative(-1)
          end
   end),

   add("window screenshot", "Print", function()
          awful.spawn.with_shell("screenshot -u")
   end),
   add("fullscreen screenshot", "Shift-Print", function()
          awful.spawn.with_shell("screenshot")
   end),
   add("region screenshot", "Ctrl-Print", function()
          awful.spawn.with_shell("sleep 0.5 && screenshot -s")
   end),
   
   --bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume
   --bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% #decrease sound volume
   --bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound
   --# Sreen brightness controls
   --bindsym XF86MonBrightnessUp exec xbacklight -inc 1 # increase screen brightness
   --bindsym XF86MonBrightnessDown exec xbacklight -dec 1 # decrease screen brightness

   add("laptop: increase sound volume", "XF86AudioRaiseVolume", function()
          awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
   end),
   add("laptop: decrease sound volume", "XF86AudioLowerVolume", function()
          awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
   end),
   add("laptop: mute sound", "XF86AudioMute", function()
          awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
   end),
   
   add("laptop: inclrease brightness", "XF86MonBrightnessUp", function()
          awful.spawn("xbacklight -inc 1")
   end),
   add("laptop: declrease brightness", "XF86MonBrightnessDown", function()
          awful.spawn("xbacklight -dec 1")
   end),

   add("kills focused window", "Control-Shift-k", function()
          func.exec("killapp")
   end)
)

------------------------------------------------------------------------
clientkeys = gears.table.join(
   add("client: toggle fullscreen", modkey.."-f", function(c)
          c.fullscreen = not c.fullscreen
          c:raise()
   end),
   add("client: close", modkey.."-Shift-q", function(c)
          c:kill()
   end),
   add("client: toggle floating", modkey.."-Control-space", awful.client.floating.toggle),
   add("client: move to master", modkey.."-Control-Return", function(c)
          c:swap(awful.client.getmaster())
   end),
   add("client: move to screen", modkey.."-o", function(c)
          c:move_to_screen()
   end),
   add("client: toggle keep on top", modkey.."-t", function(c)
          c.ontop = not c.ontop
   end),
   add("client: minimize", modkey.."-n", function(c)
          -- The client currently has the input focus, so it cannot be
          -- minimized, since minimized clients can't have the focus.
          c.minimized = true
   end),
   add("client: (un)maximize", modkey.."-m", function(c)
          c.maximized = not c.maximized
          if c.maximized then
             c.border_width = 0
          else
             c.border_width = 1
          end
          c:raise()
   end),
   add("client: (un)maximize vertically", modkey.."-Control-m", function(c)
          c.maximized_vertical = not c.maximized_vertical
          c:raise()
   end),
   add("client: (un)maximize horizontally", modkey.."-Shift-m", function(c)
          c.maximized_horizontal = not c.maximized_horizontal
          c:raise()
   end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

root.keys(globalkeys)
