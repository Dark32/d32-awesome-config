local awful     = require("awful")
local wibox     = require("wibox")
local lain      = require("lain")
local gears     = require("gears")
local gtable    = require("gears.table")
local debug     = require('gears.debug')
local beautiful = require("beautiful")

local string      = string
local markup      = lain.util.markup
local table       = table
local client      = client
local separators  = lain.util.separators
local dump        = debug.dump

local margin = function (widget,color, l,r,t,b)
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
        layout = wibox.container.margin
      }
end

local mode_tooltip = {}

local config = {
  color = {
    white = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
  },
  position = {
    x = 20,
    y = 20,
  },
  ignore_mod =  { "Lock", "Mod2", "Unknown" } ,
  height = function(height) return (height +1) * 16 end,
  width  = function(width) return width * 8 end,
}


mode_tooltip.config = config
mode_tooltip.modes = {}

function config:len(str)
  return #(str:gsub('[\128-\191]',''))
end

config.ruen = {
  ['й']='q',  ['ц']='w',  ['у']='e',  ['к']='r',  ['е']='t',  ['н']='y',
  ['г']='u',  ['ш']='i',  ['щ']='o',  ['з']='p',  ['х']='[',  ['ъ']='[',
  ['ф']='a',  ['ы']='s',  ['в']='d',  ['а']='f',  ['п']='g',  ['р']='h',
  ['о']='j',  ['л']='k',  ['д']='l',  ['ж']=';',  ['э']="'",  ['я']='z',
  ['ч']='x',  ['с']='c',  ['м']='v',  ['и']='b',  ['т']='n',  ['ь']='m',
  ['б']=',',  ['ю']='.',  ['ё']='`',
}

config.keycode = {
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

function config:key (key)
  return self.keycode[key] or key
end

function config:en(key)
  return self.ruen[key] or key
end


function config:jps(mods)
    if #mods<1 then return '' end
    table.sort(mods)
    local mods2 = {}
    for _, mod in ipairs(mods) do
      table.insert(mods2, self:key(mod) )
    end
    return table.concat(mods2, '+')
end


function config:key_format(mods, key, desc)
  local key_string
  if #mods < 1 then 
    key_string = markup.bold(self:key(key))
  else
    key_string = string.format("%s+%s", markup.bold(self:jps(mods)), markup.bold(self:key(key)) )
  end
  if desc then
    key_string = string.format("%s %s",key_string,markup.fg.color(self.color.white, desc))
  end
  return key_string
end

function config:clear_ignore_mod(mod)
  local tmp_mod ={}
  for _, key in ipairs(mod) do
    if not gtable.hasitem(self.ignore_mod, key) then table.insert(tmp_mod, key) end
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

function config:key_widget(key_str)
  return wibox.widget{
        markup = key_str,
        align  = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
      }
end

function mode_tooltip:create(mode, keys, description)
    self.modes[mode] = self.config:mode()
    self.modes[mode]:init(mode, keys, description)
    
    
    local widgets = { 
      layout  =  wibox.layout.flex.vertical,
      margin (
        self.config:key_widget(self.modes[mode].caption_text),
        self.config.color.white, 0, 0, 0, 1
      ),
    }
    for _, key in ipairs(keys) do
      table.insert(widgets, self.modes[mode]:create_key_widget(key))
    end
    table.insert(widgets,self.modes[mode].key_debug)
    local wibox_mode = wibox {
        height = self.config.height(#widgets),
        width = self.config.width(self.modes[mode].width),
        ontop = true,
        x = self.config.position.x,
        y = self.config.position.y,
        screen = mouse.screen,
        expand = true,
        bg = self.config.color.bg,
        border_width = 1,
        border_color = self.config.color.bg,
        type = 'splash',
    }   
    wibox_mode:setup {
      layout  =  wibox.layout.flex.vertical,
      margin(margin(widgets,self.config.color.bg,5),self.config.color.white,1 ),
    }
    self.modes[mode].widget = wibox_mode
end

function config:create_key_widget(mode,key)
  local key_string = ''
    key_string = self:key_format(key.mods, key.key, key.description)
    local tmp_str_len = self:len(key.description..key.key..self:jps(key.mods))
    if tmp_str_len > mode.width then mode.width = tmp_str_len end
    return self:key_widget(key_string)
end

function config:mode()
  local mode = {}
  local cfg = self
  
  function mode:init(mode_name, keys, description)
    self.keys = keys    
    self.description = description
    self.action = keys.action or (function() end )
    local key_debug = cfg:key_widget('N/A')
    key_debug.align  = 'right'    
    self.key_debug = key_debug    
    self.caption_text = description or mode_name
    self.width = cfg:len(self.caption_text)
    
    return self
  end
  
  function mode:create_key_widget(key)
      return cfg:create_key_widget(self, key)
  end
  
  return mode
end

function mode_tooltip:get(mode)
  return self.modes[mode] or false
end


function config:mod_eq(mod_mode, mod_pressed)
  if #mod_mode == 0 and #mod_pressed == 0 then return true end
  for _, m in ipairs(mod_mode) do
    if not gtable.hasitem(mod_pressed, m) then return false  end
  end
  return #mod_mode == #mod_pressed
end

function config:key_eq(key_mode, key_pressed)
  return key_mode == (self:en(key_pressed))
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
    for _, keys in ipairs(mode.keys) do
      mod = self.config:clear_ignore_mod(mod)  
      local key_string = self.config:key_format(mod, key)
      
      mode.key_debug.markup = key_string
      local mods = self.config:mod_eq(keys.mods, mod)
      if mods then 
        local _key = self.config:key_eq(keys.key,key )
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