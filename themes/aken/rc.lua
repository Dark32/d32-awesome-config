-- Стандартные библиотеки
gears = require("gears")
awful = require("awful")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
hotkeys_popup = require("awful.hotkeys_popup").widget
lain = require("lain")

local path = "themes.aken."
func = require(path.."functions")
require(path.."keyboard")
naughty.notify({text="test"})
