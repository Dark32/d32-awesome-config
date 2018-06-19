local beautiful = require("beautiful")

local aken = {
  theme = function() beautiful.init( os.getenv("HOME").."/.config/awesome/themes/aken/theme.lua") end,
  globalkey = function()    
    local path = "themes.aken."
    func = require(path.."functions")
    require(path.."keyboard")
  end,
  }
local dark32={
  theme = function() beautiful.init( os.getenv("HOME").."/.config/awesome/themes/dark32/theme.lua") end,
  globalkey = function() 
    require("lib.globalkey")
  end,
  }
local st = {aken=aken,dark32=dark32}
local naughty = require("naughty")
local style = function(autor)
  return st[autor]
end

return style