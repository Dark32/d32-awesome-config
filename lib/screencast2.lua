local fs = require('gears.filesystem')
local debug = require('gears.debug')
local awful = require("awful")
local wibox = require("wibox")

local dump = debug.dump
local io = io
local screencast = {}
screencast.PIDFILE   = os.getenv("HOME").."/.screencast.pid"
screencast.PROCESS   = os.getenv("HOME").."/.screencast.process"

screencast.call = function()
  screencast.tootle();
  awful.spawn(os.getenv("HOME").."/.config/awesome/lib/sh/screencast3.sh")
end

screencast.runly = function()
  return fs.file_readable(screencast.PIDFILE)
end

screencast.process = function()
  return fs.file_readable(screencast.PROCESS)
end

screencast.show = function()
  screencast.widget.text = 'R'
end

screencast.hide = function()
  screencast.widget.text = ''
end

screencast.tootle = function()
  if(not screencast.runly()) then
    screencast.show()
  else
    screencast.hide()
  end
end

screencast.widget = wibox.widget {
    widget = wibox.widget.textbox,
  }
  
return screencast