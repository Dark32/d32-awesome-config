local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local ram_progressbar =  wibox.widget {
    max_value     = 1,
    value         = 0.5,
    forced_height = 20,
    forced_width  = 75,
    paddings      = 3,
    border_width  = 2,
    border_color  = beautiful.border_color,
    widget        = wibox.widget.progressbar,
    shape         = gears.shape.powerline,
    bar_shape     = gears.shape.powerline,
  }
  local ram_text = wibox.widget {
    text   = '50%',
    widget = wibox.widget.textbox,
  }
  
local swap_progressbar =  wibox.widget {
    max_value     = 1,
    value         = 0.5,
    forced_height = 20,
    forced_width  = 75,
    paddings      = 3,
    border_width  = 2,
    border_color  = beautiful.border_color,
    widget        = wibox.widget.progressbar,
    shape         = gears.shape.powerline,
    bar_shape     = gears.shape.powerline,
  }
  local swap_text = wibox.widget {
    text   = '50%',
    widget = wibox.widget.textbox,
  }
  
local ramgraph_widget = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
 {
    ram_progressbar,
    ram_text,
     horizontal_offset = 5,
    layout = wibox.layout.stack,
  },
  {
    swap_progressbar,
    swap_text,
    layout = wibox.layout.stack,
  },
}
watch('bash -c "free | grep -z Mem.*Swap.*"', 1,
    function(widget, stdout, stderr, exitreason, exitcode)
        total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
            stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')
        local ram = used/total
        local swap = used_swap/total_swap
        ram_text.text = string.format("MEM %d%%", math.floor(100 * ram))
        ram_progressbar.value = ram
        swap_text.text = string.format("SWAP %d%%", math.floor(100 * swap))
        swap_progressbar.value = swap
--        widget.data = { used, total-used } widget.data = { used, total-used }

    end,
    ramgraph_widget
)
return ramgraph_widget