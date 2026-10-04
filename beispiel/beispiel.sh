#!/usr/bin/env bash
# Beispielprogramm: zeigt nur eine Nachricht. Ersetzt es durch euer eigenes Programm.
MSG="Hallo! Dieses Programm wurde mit dem Doppelklick-Installer installiert."
if command -v kdialog >/dev/null; then kdialog --title "Beispielprogramm" --msgbox "$MSG"
elif command -v zenity >/dev/null; then zenity --info --title="Beispielprogramm" --text="$MSG"
else notify-send "Beispielprogramm" "$MSG" 2>/dev/null || echo "$MSG"; fi
