local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local gtable = require("gears.table")
local debug = require('gears.debug')

local markup = lain.util.markup
local table = table

local separators = lain.util.separators
local colors = require('lib.colors')

local key_code ={
  Mod4="Super",
  Mod1="Alt",
  Escape="Esc",
  Insert="Ins",
  Delete="Del",
  Backspace="BackSpc",
  Return="Enter",
  Next="PgDn",
  Prior="PgUp",
  ['#108']="Alt Gr",
  Left='←',
  Up='↑',
  Right='→',
  Down='↓',
  ['#67']="F1",
  ['#68']="F2",
  ['#69']="F3",
  ['#70']="F4",
  ['#71']="F5",
  ['#72']="F6",
  ['#73']="F7",
  ['#74']="F8",
  ['#75']="F9",
  ['#76']="F10",
  ['#95']="F11",
  ['#96']="F12",
  ['#10']="1",
  ['#11']="2",
  ['#12']="3",
  ['#13']="4",
  ['#14']="5",
  ['#15']="6",
  ['#16']="7",
  ['#17']="8",
  ['#18']="9",
  ['#19']="0",
  ['#20']="-",
  ['#21']="=",
  Control="Ctrl"
}

local function join_plus_sort(modifiers)
    if #modifiers<1 then return "none" end
    table.sort(modifiers)
    local modifiers2 = {}
    for _, mod in ipairs(modifiers) do
      table.insert(modifiers2, key_code[mod] or mod )
    end
    return table.concat(modifiers2, '+')
end

local mode_tooltip = {}
mode_tooltip.setting = {
  
  }
mode_tooltip.modes = {}
mode_tooltip.ignore_mod =  { "Lock", "Mod2" }

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
  
function mode_tooltip.clear_ignore_mod(mod)
  local tmp_mod ={}
  for _, key in ipairs(mod) do
    if not gtable.hasitem(mode_tooltip.ignore_mod, key) then table.insert(tmp_mod, key) end
  end
  return tmp_mod
end

function mode_tooltip.prepare_key (keys)
  local _keys = {}
  for _, key in ipairs(keys) do
    table.insert(_keys, {mods=key[1], key=key[2], description=key[3], action=key[4], done=key[5] or false})
  end
  return _keys
end


function mode_tooltip:create(mode, keys)
    self.modes[mode] = {}
    self.modes[mode].key = keys
    self.modes[mode].action = keys.action or (function() end )
    local widgets = { 
      layout  =  wibox.layout.flex.vertical,
      wibox.widget{
        markup = mode,
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
      }}
    for _, key in ipairs(keys) do
      local str = ''
      for _, mod in ipairs(keys) do
      
      end
      
      if #key.mods < 1 then 
        str = string.format("%s %s",
          markup.bold(key_code[key.key]  or key.key) ,
          markup.fg.color(colors.gray, key.description)
        )
      else
        str = string.format("%s+%s %s",
          markup.bold(join_plus_sort(key.mods)),
          markup.bold(key_code[key.key]  or key.key) ,
          markup.fg.color(colors.gray, key.description)
        )
      end
      
      local w = wibox.widget{
        markup = str,
        align  = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
      }
      table.insert(widgets,w)
    end
    local widget = wibox {
        height = (#widgets +2) * 12,
        width = 400,
        ontop = true,
        x = 20,
        y = 20,
        screen = mouse.screen,
        expand = true,
        bg = '#1e252c',
        max_widget_size = 500
    }    
    widget:setup {
      border_width = 1,
      layout  =  wibox.layout.flex.vertical,
      widgets,
    }
    self.modes[mode].widget = widget
end

function mode_tooltip:get(mode)
  return self.modes[mode] or false
end

function mode_tooltip.key_mod_compare(mod_mode, mod_pressed)
  if #mod_mode == 0 and #mod_pressed == 0 then return true end
  for _, m in ipairs(mod_mode) do
    if not gtable.hasitem(mod_pressed, m) then return false  end
  end
  return #mod_mode == #mod_pressed
end

function mode_tooltip.key_compare(key_mode, key_pressed)
  return key_mode == key_pressed
end

function mode_tooltip:grabber(index_mode, client)
  local mode = self:get(index_mode)
  if not mode then return end
  if mode.widget.visible then
    mode.widget.visible = false
    return
  end
  
  mode.widget.visible = true
  local grabber
  local function hide()
    mode.widget.visible = false
    awful.keygrabber.stop(grabber) 
  end
  local handler = function(mod, key, event)
    if event == "release" then return end
    local key_mode 
    if key == 'Escape' then hide() end
    for _, keys in ipairs(mode.key) do
      mod = mode_tooltip.clear_ignore_mod(mod)
      local mods = mode_tooltip.key_mod_compare(keys.mods, mod)
      if mods then 
        local _key = mode_tooltip.key_compare(keys.key,key )
        if _key then
          key_mode = keys
            pcall(function() 
              if client then
                key_mode.action(client) 
              else 
                key_mode.action()  
              end
            end )
          if key_mode.done then hide() end
          break
        end
      end
    end
  end
  grabber = awful.keygrabber.run(handler) 
end


return mode_tooltip