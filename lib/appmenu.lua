
local appmenu = {
      { "Base", {
            { "Screen Resolution",  "arandr"},
            { "Wallpaper",          "nitrogen "},
            { "GTK theme",          "lxappearance "},
            { "Package manager",    "synaptic-pkexec "},
            { "Taskmanager",        "xfce4-taskmanager "},
            { "OCS Store",          "ocsstore "},
          }
      },
      {"Job Programs", {
            { "phpStorm 162",       "bash ~/PhpStorm-162.1889.1/bin/phpstorm.sh "},
            { "pyCharm 5",          "bash ~/pycharm-community-5.0.4/bin/pycharm.sh "},
            { "Gogland 171",        "bash ~/Gogland-171.3780.106/bin/gogland.sh "},
            { "RubyMine 7",         "bash ~/RubyMine-7.1.4/bin/rubymine.sh "},
            { "CLion",              "bash ~/clion-2017.2.3/bin/clion.sh "},
          }
      },
      {"Programs", {
            { "File Manager",       "thunar "},
            { "TOR",                "~/TOR/Browser/start-tor-browser "},
          }
      },
      {"Info", {
            { "xprop",              terminal .. " -e xprop; read"},
            { "xwininfo",           terminal .. " -e xwininfo; read"}, 
          }
      },
      {"Edit", {
            { "Edit menu",          "leafpad ~/.config/awesome/lib/appmenu.lua"}, 
          }
      },
  }
  
  return appmenu