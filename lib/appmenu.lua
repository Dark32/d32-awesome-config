
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
            { "phpStorm 162",       "bash -c ~/PhpStorm-162.1889.1/bin/phpstorm.sh "},
            { "pyCharm 5",          "bash -c ~/pycharm-community-5.0.4/bin/pycharm.sh "},
            { "Gogland 171",        "bash -c ~/Gogland-171.3780.106/bin/gogland.sh "},
            { "RubyMine 7",         "bash -c ~/RubyMine-7.1.4/bin/rubymine.sh "},
            { "CLion",              "bash -c ~/clion-2017.2.3/bin/clion.sh "},
          }
      },
      {"Programs", {
            { "File Manager",       "thunar "},
            { "TOR",                "bash -c ~/TOR/Browser/start-tor-browser "},
          }
      },
      {"Info", {
            { "xprop",              terminal .. " -e 'bash -c xprop;bash'"},
            { "xwininfo",           terminal .. " -e 'bash -c xwininfo;bash'"}, 
          }
      },
      {"Edit", {
            { "Edit menu",          "leafpad ~/.config/awesome/lib/appmenu.lua"}, 
          }
      },
  }
  
  return appmenu