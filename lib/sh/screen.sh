#!/bin/bash

DISC=0
CLIPBOARD=0
FOCUS=0
SELECT=0

# process flags
while test $# -gt 0; do
 case "$1" in
                -h|--help)
                        echo "$package - attempt to capture frames"
                        echo " "
                        echo "$package [options] application [arguments]"
                        echo " "
                        echo "options:"
                        echo "-h, --help                show brief help"
                        echo "-c, --clipboard  copy screenshot to buffer"
                        echo "-d, --disc  save screenshot to disc"
			echo "-f, --focus use the currently focused window"
			echo "-s, --select   interactively choose a window or rectangle with the mouse"
                        exit 0
                        ;;
  -c|--clipboard)
   shift
   CLIPBOARD=1
   ;;
  -d|--disc)
   shift
   DISC=1
   ;;
  -f|--focus)
   shift
   FOCUS=1
   ;;
  -s|--select)
   shift
   SELECT=1
   ;;
 esac
done

# get a name for a temporary file
temp="$(mktemp -u).png"
file_name=~/Images/$(date +%F_%X_%N).png

# use scrot to put a screenshot into said temporary file
#maim $@ "$temp"

focus=""

if [ $FOCUS == 1 ];
then
  focus="-u"
fi
select=""
if [ $SELECT == 1 ];
then
  select="--select"
fi

sleep 0.2 ; scrot --silent $focus $select $@ "$temp"

# copy the image to the X clipboard, tagging it as image data 
if [ $CLIPBOARD == 1 ];
then
 cat "$temp" | xclip -selection clipboard -t image/png
 notify-send "Картинка в буфере"
 echo "Картинка сохранена в буфере"
fi

if [ $DISC == 1 ];
then
 cp $temp $file_name
 notify-send "Картинка сохранена в $file_name"
 echo "Картинка сохранена в $file_name"
fi

# remove the temporary file
rm -f "$temp"
