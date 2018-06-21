
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local cpugraph_widget = wibox.widget {
    max_value = 100,
    color = '#74aeab',
    background_color = '#00000000',
    forced_width = 50,
    step_width = 2,
    step_spacing = 0,
    widget = wibox.widget.graph,
    
}
local cpu_text = wibox.widget {
    text   = '50%',
    widget = wibox.widget.textbox,
  }
-- mirros and pushs up a bit
local cpu_widget = wibox.container.margin(wibox.container.mirror(cpugraph_widget, { horizontal = true }), 0, 0, 0, 2)
local cpu_widget2 = wibox.widget {  
    layout = wibox.layout.stack,
    cpu_widget,
    cpu_text,    
--    shape         = gears.shape.powerline,
    
--    border_color  = beautiful.border_color,
  }

local total_prev = 0
local idle_prev = 0

watch("cat /proc/stat | grep '^cpu '", 1,
    function(widget, stdout, stderr, exitreason, exitcode)
        local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

        local total = user + nice + system + idle + iowait + irq + softirq + steal

        local diff_idle = idle - idle_prev
        local diff_total = total - total_prev
        local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10
        cpu_text.text = string.format("CPU %d%%", math.floor( diff_usage))
--        cpu_text.text ="CPU "
        if diff_usage > 80 then
          widget:set_color('#ff0000')
        elseif diff_usage > 60 then
          widget:set_color('#888800')
        else
          widget:set_color('#008800')
        end

        widget:add_value(diff_usage)

        total_prev = total
        idle_prev = idle
    end,
    cpugraph_widget
)

return cpu_widget2
