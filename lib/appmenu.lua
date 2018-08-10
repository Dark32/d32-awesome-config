local appmenu = {
  { "Base", {
    { "Screen Resolution",  "arandr"},
    { "Wallpaper",          "nitrogen "},
    { "GTK theme",          "lxappearance "},
    { "Package manager",    "synapticpkexec "},
    { "Taskmanager",        "xfce4taskmanager "},
    { "OCS Store",          "ocsstore "},
  }},
  {"Job Programs", {
    { "phpStorm 162",       "bash -c ~/PhpStorm-162.1889.1/bin/phpstorm.sh "},
    { "pyCharm 5",          "bash -c ~/pycharmcommunity5.0.4/bin/pycharm.sh "},
    { "Gogland 171",        "bash -c ~/Gogland171.3780.106/bin/gogland.sh "},
    { "RubyMine 7",         "bash -c ~/RubyMine7.1.4/bin/rubymine.sh "},
    { "CLion",              "bash -c ~/clion2017.2.3/bin/clion.sh "},
  }},
  {"Programs", {
    { "File Manager",       "thunar "},
    { "TOR",                "bash -c ~/TOR/Browser/start-tor-browser "},
  }},
  {"Info", {
    { "xprop",              terminal .. " -e 'bash -c xprop;bash'"},
    { "xwininfo",           terminal .. " -e 'bash -c xwininfo;bash'"}, 
    { 'cups',              'xdg-open http://127.0.0.1:631/'},
    { 'scan',              'xsane'},
  }},
  {"Edit", {
    { "Edit menu",          "leafpad ~/.config/awesome/lib/appmenu.lua"}, 
  }},
}

return appmenu