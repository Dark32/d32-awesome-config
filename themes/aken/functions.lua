local func = {}

function string:split(sep)
   local sep, fields = sep, {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

func.add_key = function(name, keycombo, func)
   local gr, desc, key_table, key
   if name:find(":") then
      name = name:split(": ")         -- tmp variable. Contains group name and description. Format: "group: description"
      gr = table.remove(name, 1)      -- group
      desc = table.concat(name," ")   -- decription
   else
      desc = name
      gr = "custom keys"
   end

   local key_table = keycombo:split("-")
   local key = table.remove(key_table, #key_table)
   return awful.key(key_table, key, func, {description=desc, group=gr})
end

func.run = function(name)
   for _, program in pairs(name) do
      awful.spawn.with_shell("~/.config/awesome/autorun.sh "..program)
   end
end

func.exec = function(name)
   awful.spawn.with_shell("~/.config/awesome/autorun.sh "..name)
end

func.notify = function(text, data)
   -- Idk how to get theme from beautiful, pls help me D:
   --local theme = beautiful.get()
   data = data or {}
   if text then
      data.text = ""..text
   elseif text == nil then
      data.text = "nil"
   elseif text == false then
      data.text = "false"
   end
   data.status = data.status or "normal"
   data.icon   = data.icon or "\"\""
   data.app    = "awesome"
   naughty.notify(data)
end

func.pipe = function(value, max)
   max = max or 10
   local num = gears.math.round(value / 10)
   if num > max then
      num = max
   end
   local pipes = ""
   for i = 1, num do
      pipes = pipes.."|"
   end
   for i = num+1, max do
      pipes = pipes.." " -- u-2004
   end
   return pipes
end

func.color = function(percent)
   if percent < 50 then
      return "#00ff00"
   elseif percent < 80 then
      return "#ffff00"
   else
      return "#ff0000"
   end
end

func.rev_color = function(percent)
   if percent < 20 then
      return "#ff0000"
   elseif percent < 50 then
      return "#ffff00"
   else
      return "#00ff00"
   end
end

func.fill_colors = function(colors)
   local rev = colors.rev or false
   local max = colors.max or 10
   local color = colors
   local color_count = #color
   local prev = 1

   if color_count < max then
      for i = color_count+1, max do
         color[i] = color[prev]
         prev = prev + 1
         if prev > color_count then
            prev = 1
         end
      end
   end
   return color
end

return func
