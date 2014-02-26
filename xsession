#!/bin/sh
xrdb -merge ~/.Xresources

/home/rjoost/tools/trayer-srg/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype percent --width 10 --transparent true --tint 0x000000 &
gnome-power-manager &
xautolock -locker "xlock -mode matrix" -detectsleep &
exec dbus-launch --sh-syntax --exit-with-session xmonad
