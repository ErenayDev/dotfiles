#!/bin/sh

case "$1" in
  toggle)
    if pgrep -x wl-screenrec >/dev/null; then
      pkill -INT -x wl-screenrec
      notify-send "Screen Recording" "Stopped"
    else
      dir="$HOME/Videos/Replays"
      mkdir -p "$dir" || {
        notify-send "Screen Recording" "Failed to create $dir"
        exit 1
      }
   		 file="$dir/$(date +%Y-%m-%d_%H-%M-%S).mp4"
		 if wl-screenrec -o eDP-1 -m 60 --codec hevc --audio --audio-device alsa_output.pci-0000_03_00.6.HiFi__Speaker__sink.monitor --audio-codec opus -f "$file"  & then
         notify-send "Screen Recording" "Started: $(basename "$file")"
      else
        notify-send "Screen Recording" "Failed to start"
        exit 1
      fi
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
