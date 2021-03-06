local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local l = "⚡"

local style = require('lib.style')
local mirror = style.mirror_v

local setting = {
    height = 20,
    width = 50
}

local rect = function(cr, width, height)
    gears.shape.rectangle(cr, 50, 4)
end

local bat_progressbar = wibox.widget {
    max_value = 1,
    value = 0.5,
    forced_height = setting.height,
    forced_width = setting.width,
    border_color = beautiful.border_color,
    widget = wibox.widget.progressbar,
    color = {
        type = "linear",
        from = { 0, 0 },
        to = { setting.width, 0 },
        stops = {
            { 0, "#880000" },
            { 0.8, "#006600" }
        }
    },
    background_color = 'alpha',
    shape = rect,
    --    bar_shape     = gears.shape.powerline,
}
local bat_text = wibox.widget {
    text = '50%',
    widget = wibox.widget.textbox,
}

local batgraph_widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    {
        mirror(bat_progressbar),
        bat_text,
        layout = wibox.layout.stack,
    }
}

local function show_battery_warning()
    naughty.notify {
        icon = HOME .. "/.config/awesome/nichosi.png",
        icon_size = 100,
        text = "Huston, we have a problem",
        title = "Battery is dying",
        timeout = 5,
        hover_timeout = 0.5,
        position = "bottom_right",
        bg = "#F06060",
        fg = "#EEE9EF",
        width = 300,
    }
end

watch("acpi", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
        local batteryType
        local _, status, charge_str, time = string.match(stdout, '(.+): (%a+), (%d?%d%d)%%,? ?(%d*:?%d*)')
        local charge = tonumber(charge_str)
        if (charge and charge >= 0 and charge < 15) then
            batteryType = "battery-empty%s-symbolic"
            if status ~= 'Charging' then
                show_battery_warning()
            end
        end
        local chr
        if status == 'Full' then chr = ''
        elseif status == 'Discharging' then chr = 'DIS' .. '(' .. time .. ')'
        elseif status == 'Charging' then chr = 'CHR' .. '(' .. time .. ')'
        end
        bat_text.text = string.format("%s %d%% %s", l, charge, chr)
        bat_progressbar.value = charge / 100
    end,
    batgraph_widget)

return batgraph_widget
