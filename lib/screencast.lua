local fs = require('gears.filesystem')
local debug = require('gears.debug')
local awful = require("awful")

local dump = debug.dump
local io = io

local home      = os.getenv("HOME")
local data_format   = '%Y-%m-%d--%H-%M-%S'
local ScreenCasts_dir = home.."/Videos/ScreenCasts/"
local PIDFILE   = home.."/.screencast.pid"
local OUTFILE   = "/tmp/out.avi"
local FINALFILE = ScreenCasts_dir.."screencast--$(date +'"..data_format.."').mkv"
local PALITRE   = '/tmp/screenpal.png'
local GIFFILE   = ScreenCasts_dir.."screencast--$(date +'"..data_format.."').gif"

return function()
  local runly = fs.file_readable(PIDFILE)
  if (runly) then
    local file = io.open(PIDFILE)
    local pid = file:read()
    file.close()
    runly = runly and fs. dir_readable('/proc/'..pid)
  end
  if (runly) then
    awful.spawn('kill $(cat '..PIDFILE..')')

    --# clear the pidfile
     awful.spawn('rm'..PIDFILE)

    --# move the screencast into the user's video directory
    
     awful.spawn('ffmpeg -y -i  '..OUTFILE..' -vf fps=25,palettegen '..PALITRE)
     awful.spawn('ffmpeg -y -i  '..OUTFILE..'  -i ${PALITRE} -filter_complex "fps=15,paletteuse" '..GIFFILE)
     awful.spawn('mv '..OUTFILE..' '..FINALFILE)
  else
    awful.spawn('echo $$ > '..PIDFILE..' &&')
    awful.spawn('read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")')
    --# let the recording process take over this pid
    awful.spawn('exec ffmpeg -f alsa -i default -ac 2 -acodec vorbis -f x11grab -r 25 -s "$W"x"$H" -i :0.0+$X,$Y -vcodec libx264 '..OUTFILE)
  end    
end