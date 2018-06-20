local wibox = require("wibox")
local lain = require("lain")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

local net = wibox.widget.textbox()
local iface = 'wlp2s0'
awful.spawn.easy_async("bash -c \"ip route | awk '/^default/ { print $5 ; exit }'\"", function(stdout, stderr, reason, exit_code)
       iface = stdout
   end)
local status_update = "cat /sys/class/net/"..iface.."/operstate"
--        down = if stdout == 'up' then false else true end

local cmd = "bash -c 'ip addr show wlp2s0 | grep \"scope global\"'"
watch(status_update, 10,
    function(widget, stdout, stderr, exitreason, exitcode)
       awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code)
       net.text =  string.match(stdout, "%d%d?%d?.%d%d?%d?.%d%d?%d?.%d%d?%d?") or 'down'
    end)
    end,
    net)
return net