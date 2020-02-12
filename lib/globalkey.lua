local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local beautiful     = require("beautiful")
local debug         = require('gears.debug')
local localize      = require("lib.localize")
local screencast    = require('lib.screencast2')
local mode_widget   = require('widget.mode-widget')
local add           = awful.key
local translate     = require("widget.translate")

local cnlw = require('widget.caps_num_lock-widget')

local function launch(cmd)
  awful.spawn(string.format(cmd, beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
end

local function vlc_PP()
  -- --dest=org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
--   dbus.emit_signal(
--     'session',
--     '/org/mpris/MediaPlayer2',
--     'org.mpris.MediaPlayer2.vlc',
--     ' .PlayPause'
--   )
end

local dmenu = {
  app = [[j4-dmenu-desktop --dmenu='rofi -dmenu -p "launch: " -show run -o 85 -location 2 -lines 16 -width 1200'r]],
  file = 'rofi -show fb -modi fb:~/.config/i3/rofi/rofi-file-browser.sh -o 85 -location 2 -lines 32 -width 1200',
  launch = "rofi -show run -o 85 -location 2 -lines 16 -width 1200"
  }
local launcher_key = mode_widget .prepare_key {
 {{},'a', 'Приложения', function () launch(dmenu.app)     end, true },
 {{},'f', 'Файлы',      function () launch(dmenu.file)    end, true },
 {{},'d', 'Запуск',     function () launch(dmenu.launch)  end, true },
 
 {{},'z', 'zbstudio',          function () launch('zbstudio')     end, true },
 {{"Shift"},'t', 'Файловый менеджер', function () launch('thunar')       end, true }, 
 {{},'e', 'Терминал..',        function () launch(terminal)       end, true },
 {{},'i', 'Сравнить',          function () launch('meld')         end, true },
 {{},'t', 'Торрент',           function () launch('deluge-gtk ')  end, true },
 {{},'u', 'DBus',              function () launch('d-feet')  end, true },
 {{},'r', 'Ranger',            function () launch(terminal..' -e ranger')  end, true },
-- {{},'v', 'VLC Play',          function () vlc_PP() end, true },
 
 }
mode_widget :create('launcher',launcher_key, 'Быстрый запуск приложений' )

 local function launcher_app()
  mode_widget :grabber('launcher')
 end
 
 
local func = {
  client_next   = function () awful.client.focus.byidx( 1)    end,
  client_prev   = function () awful.client.focus.byidx(-1)    end,
  mainmenu_show = function () mymainmenu:toggle()             end,
  appmenu_show  = function () applauncher:toggle()            end,
  client_swap   = function () awful.client.swap.byidx( 1)     end,
  client_unswap = function () awful.client.swap.byidx(-1)     end,
  screen_next   = function () awful.screen.focus_relative( 1) end,
  screen_prev   = function () awful.screen.focus_relative(-1) end,
  client_story  = function ()
                    awful.client.focus.history.previous()
                    if client.focus then
                      client.focus:raise()
                    end
                  end,
  launcher_terminal     = function () awful.spawn(terminal)               end,
  tag_factor_plus       = function () awful.tag.incmwfact( 0.05)          end,
  tag_factor_minus      = function () awful.tag.incmwfact(-0.05)          end,
  layout_master_plus    = function () awful.tag.incnmaster( 1, nil, true) end,
  layout_master_minus   = function () awful.tag.incnmaster(-1, nil, true) end,
  layout_column_plus    = function () awful.tag.incncol( 1, nil, true)    end,
  layout_column_minus   = function () awful.tag.incncol(-1, nil, true)    end,
  layout_next           = function () awful.layout.inc( 1)                end,
  layout_prev           = function () awful.layout.inc(-1)                end,
  launcher_promt        = function () awful.screen.focused().mypromptbox:run() end,
  awesome_lua           = function ()
                            awful.prompt.run {
                              prompt       = "Run Lua code: ",
                              textbox      = awful.screen.focused().mypromptbox.widget,
                              exe_callback = awful.util.eval,
                              history_path = awful.util.get_cache_dir() .. "/history_eval"
                            }
                          end,
  awesome_wibox       = function ()
                          for s in screen do
                              s.wibox_bottom.visible = not s.wibox_bottom.visible
                              if s.wibox_tasklist then
                                  s.wibox_tasklist.visible = not s.wibox_tasklist.visible
                              end
                          end
                      end,
  launcher_dmenu      = function() launcher_app() end,
  quaqe               = function() awful.screen.focused().quake:toggle() end,
  layout_set_tile     = function() awful.layout.set(awful.layout.suit.tile) end,
  layout_set_max      = function() awful.layout.set(awful.layout.suit.max) end, 
  screen_shot         = function() awful.spawn(os.getenv("HOME").."/.config/awesome/lib/sh/screen.sh -d -c") end,
  screen_shot2        = function() awful.spawn(os.getenv("HOME").."/.config/awesome/lib/sh/screen.sh -d -c -s") end,
  screen_record       = function() screencast.call() end,
  translite_func      = function() translate.show_translate_prompt() end,
  
}

local globalkeys = awful.util.table.join(
  
  add({ modkey,           }, "F1",     hotkeys_popup.show_help,     localize.globalkey.help),
  add({ modkey,           }, "Escape", awful.tag.history.restore,   localize.globalkey.client_back),
  add({ altKey,           }, "Tab",    func.client_next,            localize.globalkey.client_next ),
  add({ altKey, "Shift"   }, "Tab",    func.client_prev,            localize.globalkey.client_preview ),  
  add({ modkey,           }, "Right",  func.client_next,            localize.globalkey.client_next ),
  add({ modkey,           }, "Left",   func.client_prev,            localize.globalkey.client_preview ),
  add({ modkey,           }, "a",      func.mainmenu_show,          localize.globalkey.menu_show ),  
  add({ modkey,           }, "m",      func.appmenu_show,           localize.globalkey.appmenu_show ),
  -- Layout manipulation
  add({ modkey, "Shift"   }, "Right",  func.client_swap,            localize.globalkey.swap_next ),
  add({ modkey, "Shift"   }, "Left",   func.client_unswap,          localize.globalkey.swap_prev),
  add({ modkey, "Control" }, "j",      func.screen_next,            localize.globalkey.screen_next),
  add({ modkey, "Control" }, "k",      func.screen_prev,            localize.globalkey.screen_prev),
  add({ modkey,           }, "u",      awful.client.urgent.jumpto,  localize.globalkey.client_urgent),
  add({ modkey,           }, "Tab",    func.client_story,           localize.globalkey.client_story),
  -- Standard program
  add({ modkey,           }, "Return", func.launcher_terminal,      localize.globalkey.launcher_terminal),
  add({ modkey, "Control" }, "r",      awesome.restart,             localize.globalkey.awesome_restart),
  add({ modkey, "Shift"   }, "q",      awesome.quit,                localize.globalkey.awesome_quit),
  add({ modkey,           }, "]",      func.tag_factor_plus,        localize.globalkey.tag_factor_plus),
  add({ modkey,           }, "[",      func.tag_factor_minus,       localize.globalkey.tag_factor_minus),
  add({ modkey, "Shift"   }, "]",      func.layout_master_plus,     localize.globalkey.layout_master_plus),
  add({ modkey, "Shift"   }, "[",      func.layout_master_minus,    localize.globalkey.layout_master_minus),
  add({ modkey, "Control" }, "]",      func.layout_column_plus,     localize.globalkey.layout_column_plus),
  add({ modkey, "Control" }, "[",      func.layout_column_minus,    localize.globalkey.layout_column_minus),
  add({ modkey,           }, "space",  func.layout_next,            localize.globalkey.layout_next),
  --add({ modkey, "Shift"   }, "space",  func.layout_prev,            localize.globalkey.layout_prev),
  -- Prompt
  add({ modkey ,"Shift"   }, "r",      func.launcher_promt,         localize.globalkey.launcher_promt),
  add({ modkey            }, "x",      func.awesome_lua,            localize.globalkey.awesome_lua),
--  add({ modkey            }, "b",      func.awesome_wibox,          localize.globalkey.awesome_wibox),
--[[ dmenu]]
  add({ modkey            }, "d",      func.launcher_dmenu,         localize.globalkey.launcher_dmenu),
--]]
  add({ modkey,           }, "w",      func.quaqe,                  localize.globalkey.quaqe),
-- Быстрое переключение на слой
  add({ modkey,           }, "e",      func.layout_set_tile,        localize.globalkey.layout_set_tile),
  add({ modkey,           }, "t",      func.layout_set_max,         localize.globalkey.layout_set_max),
-- Скриншоты
  add({                   }, "Print",      func.screen_shot,        localize.globalkey.screen_shot),
  add({         "Shift"   }, "Print",      func.screen_shot2,       localize.globalkey.screen_shot),
  add({ modkey,           }, "Print",      func.screen_record,      localize.globalkey.screen_record),
-- Статус кнопок
  add({                   }, "Num_Lock",   function () cnlw.numlock:check()  end),
  add({                   }, "Caps_Lock",  function () cnlw.capslock:check() end),
-- Переводчик
  add({ modkey            }, "y",          func.translite_func,     localize.globalkey.translite_func)
  
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    -- Отобразить только тег
    add({ altKey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      localize.globalkey.tag_view(i)),
    -- Toggle tag display.
    -- Включить отображение тега
    add({ altKey, "Control" }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
       localize.globalkey.tag_toggle(i)),
    -- Move client to tag.
    -- Переместить приложение в тег
    add({ modkey }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
    localize.globalkey.tag_client_move(i)),
    -- Toggle tag on focused client.
    -- Это я до конца не понял
    add({ altKey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      localize.globalkey.tag_focused(i))
  )
end
-- Set keys
root.keys(globalkeys)