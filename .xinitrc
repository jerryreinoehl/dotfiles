#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

export WINIT_X11_SCALE_FACTOR=1


configure_displays() {
  local brightness="0.73"
  local gamma="1:0.9:0.82"
  local monitors=$(
    xrandr --listactivemonitors | awk 'NR != 1 { printf "%s ", $NF }'
  )

  for monitor in $monitors; do
    xrandr --output "$monitor" --brightness "$brightness" --gamma "$gamma"
  done
}


# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

configure_displays

picom &
exec qtile start
