 i3status -c ~/.i3/i3status.conf | while :; do read line; echo ": `xbacklight | cut -d '.' -f 1` | $line" || exit 1; done
