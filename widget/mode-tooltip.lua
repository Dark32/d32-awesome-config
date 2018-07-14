local awful   = require("awful")
local wibox   = require("wibox")
local lain    = require("lain")
local gears   =  require("gears")
local gtable  = require("gears.table")
local debug   = require('gears.debug')
local colors  = require('lib.colors')
local beautiful = require("beautiful")

local rot_bg =require('lib.rotate_bg')
local string      = string
local markup      = lain.util.markup
local table       = table
local client      = client
local separators  = lain.util.separators

local setting = {
  color = {
    white = colors.white,
    bg = beautiful.bg_normal
  },
  position = {
    x = 20,
    y = 20,
    },
  }
local len = function(str)
  return #(str:gsub('[\128-\191]',''))
end

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
  [' '] = 'space',
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
mode_tooltip.setting = {}
mode_tooltip.modes = {}
mode_tooltip.ignore_mod =  { "Lock", "Mod2", "Unknown" } -- я не знаю что за Unknown


local function key_string_format(mods,key, description)
  local key_string
  if #mods < 1 then 
    key_string = string.format("%s", markup.bold(key_code[key]  or key))
  else
    key_string = string.format("%s+%s",
      markup.bold(join_plus_sort(mods)), 
      markup.bold(key_code[key]  or key)
    )
  end
  if description then
    key_string = key_string..' '..markup.fg.color(setting.color.white, description)
  end
  return key_string
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

local function margin(widget,color, l,r,t,b)
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
        widget = wibox.container.margin
      }
end

function mode_tooltip:create(mode, keys, description)
    self.modes[mode] = {}
    self.modes[mode].key = keys    
    self.modes[mode].description = description
    self.modes[mode].action = keys.action or (function() end )
    local key_debug = wibox.widget{
        markup = 'N/A',
        align  = 'right',
        valign = 'center',
        widget = wibox.widget.textbox
      }
    self.modes[mode].key_debug = key_debug
    local caption_text = description or mode
    local width = len(caption_text)
    local widgets = { 
      layout  =  wibox.layout.flex.vertical,
      margin (wibox.widget{
        markup = caption_text,
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
      },setting.color.white,0,0,0,1),
      }
    for _, key in ipairs(keys) do
      local key_string = ''
      for _, mod in ipairs(keys) do
      
    end
    key_string = key_string_format(key.mods,key.key, key.description )
      local tmp_str_len = len(key.description..key.key..join_plus_sort(key.mods))
      if tmp_str_len > width then width = tmp_str_len end
      
      local w = wibox.widget{
        markup = key_string,
        align  = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
      }
      table.insert(widgets,w)
    end
      table.insert(widgets,key_debug)
    local wibox_mode = wibox {
        height = (#widgets +1) * 16,
        width = width * 8,
        ontop = true,
        x = setting.position.x,
        y = setting.position.y,
        screen = mouse.screen,
        expand = true,
        bg = setting.color.bg,
        border_width = 1,
        border_color = setting.color.bg,
        type = 'splash',
    }   
    wibox_mode:setup {
      layout  =  wibox.layout.flex.vertical,
      margin(margin(widgets,setting.color.bg,5),setting.color.white,1 ),
    }
    self.modes[mode].widget = wibox_mode
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

function mode_tooltip:grabber(index_mode, c)
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
      local key_string = key_string_format(mod, key)
      
      mode.key_debug.markup = key_string
      local mods = mode_tooltip.key_mod_compare(keys.mods, mod)
      if mods then 
        local _key = mode_tooltip.key_compare(keys.key,key )
        if _key then
          key_mode = keys
            pcall(function() 
              if c then
                if not client.focus == c then
                  c = client.focus
                end
                key_mode.action(c) 
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