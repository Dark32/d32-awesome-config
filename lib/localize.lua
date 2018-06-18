local group = {
  awesome   = "awesome",
  tag       = "tag",
  client    = "client",
  launcher  = "launcher",
  screen    = "screen",
  float     = "float",
  layout    = "layout",
  }
--[[
,(.+)\s=\s\"(.+)\"  =>  , group = \1.\2
--]]
local localize = {
  globalkey = {
    help                = {description = "Справка",                           group = group.awesome},
    client_back         = {description = "Назад",                             group = group.tag},
    client_next         = {description = "Следующие окно",                    group = group.client} ,
    client_preview      = {description = "Предыдущие окно",                   group = group.client},
    menu_show           = {description = "Показать меню",                     group = group.awesome},    
    appmenu_show        = {description = "Показать меню приложений",          group = group.awesome},
    swap_next           = {description = "Поменять со следующим клиентом",    group = group.client},
    swap_prev           = {description = "Поменять с предыдущем клиентом",    group = group.client},
    screen_next         = {description = "Фокус на следующий экран",          group = group.screen},
    screen_prev         = {description = "Фокус на предыдущий экран",         group = group.screen},
    client_urgent       = {description = "Перейти к срочному клиенту",        group = group.client},
    client_story        = {description = "Назад",                             group = group.client},
    launcher_terminal   = {description = "Открыть терминал",                  group = group.launcher},
    awesome_restart     = {description = "Перезагрузить awesome",             group = group.awesome},
    awesome_quit        = {description = "Выйти из awesome",                  group = group.awesome},
    tag_factor_plus     = {description = "Добавить ширины мастеру",           group = group.layout},
    tag_factor_minus    = {description = "Убавить ширины мастеру",            group = group.layout},
    layout_master_plus  = {description = "Добавить чилсо мастер клиентов",    group = group.layout},
    layout_master_minus = {description = "Убавить чилсо мастер клиентов",     group = group.layout},
    layout_column_plus  = {description = "Добавить чилсо колон",              group = group.layout},
    layout_column_minus = {description = "Убавить чилсо колон",               group = group.layout},
    layout_next         = {description = "Выбрать следующий",                 group = group.layout},
    layout_prev         = {description = "Выбрать предыдущий",                group = group.layout},
    launcher_promt      = {description = "Выполнить",                         group = group.launcher},
    awesome_lua         = {description = "Lua",                               group = group.awesome},
    launcher_menubar    = {description = "Показать менюбар",                  group = group.launcher},
    awesome_wibox       = {description = "Переключить wibox",                 group = group.awesome},
    tag_gaps_plus       = {description = "Добавит бесполезные gaps",          group = group.tag},
    tag_gaps_minus      = {description = "Убавить бесполезные gaps",          group = group.tag},
    launcher_dmenu      = {description = "Показать dmenu",                    group = group.launcher},
    tag_view        = function(i) return {description = "Показать tag #"..i,                group = group.tag} end,
    tag_toggle      = function(i) return {description = "Переключить tag #" .. i,           group = group.tag} end,
    tag_client_move = function(i) return {description = "Переместить клиент на tag #"..i,   group = group.tag} end,
    tag_focused     = function(i) return {description = "Переключить клиент в tag #" .. i,  group = group.tag} end,
  quaqe             = {description = "Показать консоль",                      group = group.launcher}
  },
  localkey = {
    fullscreen      = {description = "toggle fullscreen",             group = group.client},
    close           = {description = "Закрыть",                       group = group.client},
    float           = {description = "Переключить плавающий режим",   group = group.client},
    move_to_screen  = {description = "move to screen",                group = group.client},
    top             = {description = "toggle keep on top",            group = group.client},
    minimize        = {description = "Свернуть",                      group = group.client},
    restore         = {description = "Востановить минимизированное",  group = group.client},
    maximize        = {description = "Максимизировать",               group = group.client},
    move_down       = {description = "Move Down",                     group = group.float},
    move_up         = {description = "Move Up",                       group = group.float},
    move_left       = {description = "Move Left",                     group = group.float},
    move_right      = {description = "Move Right",                    group = group.float},
    resize          = {description = "Resaze",                        group = group.float},
    }
}

return localize