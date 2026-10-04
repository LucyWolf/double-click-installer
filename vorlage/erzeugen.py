#!/usr/bin/env python3
"""Erzeugt aus installer.conf und den Vorlagen die fertigen Installer-Dateien in ausgabe/.

    python3 vorlage/erzeugen.py linux   BENUTZER/REPO v1.0.1
    python3 vorlage/erzeugen.py windows BENUTZER/REPO v1.0.1
"""
import os
import re
import sys
import uuid

HIER = os.path.dirname(os.path.abspath(__file__))
WURZEL = os.path.dirname(HIER)
AUS = os.path.join(WURZEL, "ausgabe")


def lies_conf():
    conf = {}
    with open(os.path.join(WURZEL, "installer.conf"), encoding="utf-8") as f:
        for zeile in f:
            m = re.match(r'\s*([A-Z_]+)\s*=\s*"(.*)"\s*(#.*)?$', zeile)
            if m:
                conf[m.group(1)] = m.group(2)
    for pflicht in ("APP_NAME", "APP_ID"):
        if not conf.get(pflicht):
            sys.exit(f"installer.conf: {pflicht} fehlt")
    if not re.fullmatch(r"[A-Za-z0-9._-]+", conf["APP_ID"]):
        sys.exit("installer.conf: APP_ID darf nur Buchstaben, Ziffern, Punkt, Minus und Unterstrich enthalten")
    return conf


def sh_doppelt(text):   # Inhalt fuer "…" in der Shell
    return text.replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$").replace("`", "\\`")


def sh_einfach(text):   # Inhalt fuer '…' in der Shell
    return text.replace("'", "'\\''")


def ersetze(vorlage, werte):
    text = open(os.path.join(HIER, vorlage), encoding="utf-8").read()
    for k, v in werte.items():
        text = text.replace(f"@{k}@", v)
    rest = re.findall(r"@[A-Z_]+@", text)
    if rest:
        sys.exit(f"{vorlage}: nicht ersetzt: {sorted(set(rest))}")
    return text


def linux(conf, repo):
    if not conf.get("LINUX_FILE"):
        print("LINUX_FILE leer – keine Linux-Installer")
        return
    werte = {k: sh_doppelt(conf.get(k, "")) for k in ("APP_NAME", "APP_ID", "LINUX_FILE", "LINUX_RUN", "ICON_PNG",
                                                       "PKGS_ARCH", "PKGS_DEB", "PKGS_RPM", "PKGS_SUSE")}
    werte["REPO"] = repo
    werte["ROOT_CMDS"] = sh_einfach(conf.get("ROOT_CMDS", ""))
    werte["APP_COMMENT"] = conf.get("APP_COMMENT", "").replace("$", "\\$").replace("`", "\\`")
    skript = f"{conf['APP_ID']}-installieren.sh"
    with open(os.path.join(AUS, skript), "w", encoding="utf-8", newline="\n") as f:
        f.write(ersetze("installieren.sh", werte))
    os.chmod(os.path.join(AUS, skript), 0o755)
    # Doppelklick-Dateien: laden das neueste Installationsskript und starten es
    url = f"https://github.com/{repo}/releases/latest/download/{skript}"
    for kurz, zusatz in (("arch", " (Arch)"), ("deb", " (Debian/Ubuntu)"), ("", "")):
        name = f"{conf['APP_ID']}{'-' + kurz if kurz else ''}-installer.desktop"
        fehler = "Download fehlgeschlagen. Besteht eine Internetverbindung?"
        exec_ = (f'bash -c "curl -fsSL -o /tmp/{skript} {url} || {{ kdialog --error \\"{fehler}\\" || '
                 f'zenity --error --text=\\"{fehler}\\"; exit 1; }}; bash /tmp/{skript}"')
        with open(os.path.join(AUS, name), "w", encoding="utf-8", newline="\n") as f:
            f.write("[Desktop Entry]\nType=Application\n"
                    f"Name={conf['APP_NAME']} installieren{zusatz}\n"
                    "Comment=Lädt die neueste Version und installiert sie\n"
                    "Icon=system-software-install\n"
                    f"Exec={exec_}\nTerminal=false\nCategories=Utility;\n")
    print("Linux-Installer erzeugt")


def windows(conf, repo, tag):
    if not conf.get("WINDOWS_FILE"):
        print("WINDOWS_FILE leer – kein Windows-Setup")
        return
    version = re.sub(r"^[vV]", "", tag) or "1.0.0"
    icon = conf.get("ICON_ICO", "")
    werte = {"APP_NAME": conf["APP_NAME"].replace('"', "'"), "APP_ID": conf["APP_ID"], "VERSION": version,
             "WINDOWS_FILE": conf["WINDOWS_FILE"], "REPO": repo,
             "APP_GUID": str(uuid.uuid5(uuid.NAMESPACE_URL, f"https://github.com/{repo}")).upper(),
             "SETUP_ICON": f"SetupIconFile=..\\{icon.replace('/', chr(92))}" if icon else ""}
    with open(os.path.join(AUS, "setup.iss"), "w", encoding="utf-8-sig", newline="\r\n") as f:
        f.write(ersetze("setup.iss", werte))
    print("Windows-Setup-Skript erzeugt")


if __name__ == "__main__":
    if len(sys.argv) != 4 or sys.argv[1] not in ("linux", "windows"):
        sys.exit(__doc__)
    os.makedirs(AUS, exist_ok=True)
    c = lies_conf()
    (linux(c, sys.argv[2]) if sys.argv[1] == "linux" else windows(c, sys.argv[2], sys.argv[3]))
