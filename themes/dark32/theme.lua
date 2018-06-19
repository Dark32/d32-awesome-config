local theme = {}
theme.font          = "FontAwesome 10"

theme.bg_normal     = "#2d2d2d"
theme.bg_focus      = "#3366cc"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal


theme.lain_icons         = os.getenv("HOME") ..
                           "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = theme.lain_icons .. "centerwork.png"
theme.layout_centerworkh = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal


return theme
