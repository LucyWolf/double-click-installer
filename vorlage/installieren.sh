#!/usr/bin/env bash
# @APP_NAME@ — Linux-Installer (erzeugt aus vorlage/installieren.sh und installer.conf)
# Installiert mit einer einzigen Passwortabfrage: benötigte Pakete, einmalige Befehle, das Programm
# nach ~/.local/share und einen Menüeintrag. Erneut gestartet: aktualisieren oder deinstallieren.
set -euo pipefail

TITLE="@APP_NAME@"
APP_ID="@APP_ID@"
REPO="@REPO@"
LINUX_FILE="@LINUX_FILE@"
LINUX_RUN="@LINUX_RUN@"
ICON_PNG="@ICON_PNG@"
INSTALL_DIR="$HOME/.local/share/$APP_ID"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_ID.desktop"
ICON_FILE="$HOME/.local/share/icons/hicolor/256x256/apps/$APP_ID.png"
RELEASE_URL="https://github.com/$REPO/releases/latest/download"

GUI=0
if command -v kdialog >/dev/null 2>&1 && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then GUI=1
elif command -v zenity >/dev/null 2>&1 && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then GUI=2; fi

info() { case "$GUI" in 1) kdialog --title "$TITLE" --msgbox "$(printf '%b' "$1")" ;;
                        2) zenity --info --title="$TITLE" --text="$1" --width=380 ;; *) printf '%b\n' "$1" ;; esac; }
fail() { case "$GUI" in 1) kdialog --title "$TITLE" --error "$(printf '%b' "$1")" ;;
                        2) zenity --error --title="$TITLE" --text="$1" --width=380 ;; *) printf 'FEHLER: %b\n' "$1" >&2 ;; esac
         exit 1; }
as_root() { if [ "$GUI" != "0" ] && command -v pkexec >/dev/null 2>&1; then pkexec /bin/sh -c "$1"; else sudo /bin/sh -c "$1"; fi; }

uninstall() {
    rm -rf "$INSTALL_DIR"
    rm -f "$DESKTOP_FILE" "$ICON_FILE"
    command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$HOME/.local/share/applications" || true
    info "$TITLE wurde entfernt."
    exit 0
}

# Schon installiert? Dann aktualisieren oder deinstallieren
if [ -d "$INSTALL_DIR" ]; then
    Q="$TITLE ist schon installiert."
    case "$GUI" in
        1) set +e; kdialog --title "$TITLE" --yesnocancel "$Q" --yes-label "Aktualisieren" --no-label "Deinstallieren"; CHOICE=$?; set -e ;;
        2) set +e; OUT=$(zenity --question --title="$TITLE" --text="$Q" --ok-label="Aktualisieren" \
                --cancel-label="Abbrechen" --extra-button="Deinstallieren"); RC=$?; set -e
           if [ "$OUT" = "Deinstallieren" ]; then CHOICE=1; elif [ "$RC" = 0 ]; then CHOICE=0; else CHOICE=2; fi ;;
        *) read -rp "$Q [a]ktualisieren, [d]einstallieren, [x] abbrechen: " A
           case "$A" in a|A) CHOICE=0 ;; d|D) CHOICE=1 ;; *) CHOICE=2 ;; esac ;;
    esac
    case "$CHOICE" in 0) ;; 1) uninstall ;; *) exit 0 ;; esac
fi

# 1) Pakete und einmalige Befehle – alles in einem Schritt, ein Passwort
PKGS=""; HAVE=""; INSTALL=""
if command -v pacman >/dev/null 2>&1; then PKGS="@PKGS_ARCH@"; HAVE="pacman -Q"; INSTALL="pacman -S --needed --noconfirm"
elif command -v apt-get >/dev/null 2>&1; then PKGS="@PKGS_DEB@"; HAVE="dpkg -s"; INSTALL="env DEBIAN_FRONTEND=noninteractive apt-get install -y"
elif command -v dnf >/dev/null 2>&1; then PKGS="@PKGS_RPM@"; HAVE="rpm -q"; INSTALL="dnf install -y"
elif command -v zypper >/dev/null 2>&1; then PKGS="@PKGS_SUSE@"; HAVE="rpm -q"; INSTALL="zypper --non-interactive install"; fi
MISSING=""
for p in $PKGS; do $HAVE "$p" >/dev/null 2>&1 || MISSING="$MISSING $p"; done
ROOT_CMD=""
[ -n "$MISSING" ] && ROOT_CMD="$INSTALL$MISSING"
EXTRA='@ROOT_CMDS@'
[ -n "$EXTRA" ] && ROOT_CMD="${ROOT_CMD:+$ROOT_CMD && }$EXTRA"
if [ -n "$ROOT_CMD" ]; then
    MSG="Für $TITLE wird eingerichtet:"
    [ -n "$MISSING" ] && MSG="$MSG\n\nPakete:$MISSING"
    [ -n "$EXTRA" ] && MSG="$MSG\n\nEinmalige Einstellungen am System"
    MSG="$MSG\n\nDanach fragt ein Fenster einmal nach deinem Passwort."
    case "$GUI" in
        1) kdialog --title "$TITLE" --continuecancel "$(printf '%b' "$MSG")" || exit 0 ;;
        2) zenity --question --title="$TITLE" --text="$MSG" --width=420 || exit 0 ;;
        *) printf '%b\n' "$MSG" ;;
    esac
    as_root "$ROOT_CMD" || fail "Die Einrichtung wurde abgebrochen oder ist fehlgeschlagen."
fi

# 2) Programm herunterladen
command -v curl >/dev/null 2>&1 || fail "curl fehlt – damit wird das Programm geladen."
TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
curl -fsSL --retry 2 -o "$TMP" "$RELEASE_URL/$LINUX_FILE" || fail "Download fehlgeschlagen.\nBesteht eine Internetverbindung?"
mkdir -p "$INSTALL_DIR"
cp -f "$TMP" "$INSTALL_DIR/$LINUX_FILE"
chmod 755 "$INSTALL_DIR/$LINUX_FILE"

# 3) Symbol und Menüeintrag
ICON=application-x-executable
if [ -n "$ICON_PNG" ]; then
    mkdir -p "$(dirname "$ICON_FILE")"
    curl -fsSL -o "$ICON_FILE" "https://raw.githubusercontent.com/$REPO/HEAD/$ICON_PNG" 2>/dev/null && ICON="$APP_ID" || rm -f "$ICON_FILE"
fi
if [ -n "$LINUX_RUN" ]; then EXEC="${LINUX_RUN//\{file\}/$INSTALL_DIR/$LINUX_FILE}"; else EXEC="$INSTALL_DIR/$LINUX_FILE"; fi
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" << DESKTOP
[Desktop Entry]
Type=Application
Name=$TITLE
Comment=@APP_COMMENT@
Exec=$EXEC
Icon=$ICON
Categories=Utility;
DESKTOP
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$HOME/.local/share/applications" || true

info "Installation abgeschlossen!\n\nStart über das Anwendungsmenü: $TITLE"
