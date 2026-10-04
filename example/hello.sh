#!/usr/bin/env bash
# Example program: only shows a message. Replace it with your own program.
MSG="Hello! This program was installed with the double-click installer."
if command -v kdialog >/dev/null; then kdialog --title "Example App" --msgbox "$MSG"
elif command -v zenity >/dev/null; then zenity --info --title="Example App" --text="$MSG"
else notify-send "Example App" "$MSG" 2>/dev/null || echo "$MSG"; fi
