#!/bin/sh

case "$1" in
  toggle)
    if pgrep -x wl-screenrec >/dev/null; then
      pkill -INT -x wl-screenrec
      notify-send "Screen Recording" "Stopped"
    else
      file="$HOME/Videos/Replays/$(date +%Y-%m-%d_%H-%M-%S).mp4"
      wl-screenrec -o eDP-1 -m 60 --codec hevc --audio-codec opus -f "$file" &
      notify-send "Screen Recording" "Started: $(basename "$file")"
    fi
    pkill -RTMIN+8 waybar
    ;;
  status)
    if pgrep -x wl-screenrec >/dev/null; then
      printf '{"text":"󰻂","tooltip":"Recording","class":"recording"}\n'
    else
      printf '{"text":"󰻃","tooltip":"Not recording","class":"idle"}\n'
    fi
    ;;
esac
