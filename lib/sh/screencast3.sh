#!/usr/bin/env bash

PIDFILE="${HOME}/.screencast.pid"
OUTFILE="/tmp/out.avi"
FINALFILE="${HOME}/Videos/ScreenCasts/screencast--$(date +'%Y-%m-%d--%H-%M-%S').mkv"
PALITRE='/tmp/screenpal.png'
GIFFILE="${HOME}/Videos/ScreenCasts/screencast--$(date +'%Y-%m-%d--%H-%M-%S').gif"
# check if this script is already running
if [ -s $PIDFILE ] && [ -d "/proc/$(cat $PIDFILE)" ]; then

    # send SIG_TERM to screen recorder
    kill $(cat $PIDFILE)

    # clear the pidfile
    rm $PIDFILE

    # move the screencast into the user's video directory
    
    ffmpeg -y -i  ${OUTFILE} -vf fps=25,palettegen ${PALITRE}
    ffmpeg -y -i  ${OUTFILE}  -i ${PALITRE} -filter_complex "fps=15,paletteuse" ${GIFFILE}
    mv ${OUTFILE} ${FINALFILE}
else
    # write to the pidfile
    echo $$ > $PIDFILE &&
    read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")
    sleep 10
    # let the recording process take over this pid
    exec ffmpeg \
      -f alsa \
      -i default \
      -ac 2 \
      -acodec vorbis \
      -f x11grab \
      -r 25 \
      -s "$W"x"$H" \
      -i :0.0+$X,$Y \
      -vcodec libx264 ${OUTFILE}
fi