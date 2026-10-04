**Sprache / Language:** [🇩🇪 Deutsch](#doppelklick-installer) | [🇬🇧 English](#double-click-installer)

---

# Doppelklick-Installer

Vorlage, mit der dein GitHub-Projekt bei jedem Release automatisch Installer bekommt – **per Doppelklick**, wie man es von Windows kennt:

- **Linux:** drei Doppelklick-Dateien (Arch/CachyOS/Manjaro, Debian/Ubuntu, alle anderen). Sie laden immer die neueste Version, installieren nötige Pakete mit **einer** Passwortabfrage, legen einen Menüeintrag an und bieten beim erneuten Start **Aktualisieren** oder **Deinstallieren** an.
- **Windows:** eine `setup.exe` (Inno Setup) – ohne Admin-Rechte, mit Startmenü, Desktop-Verknüpfung und Deinstallation über „Apps“.

Du passt nur **eine Datei** an: `installer.conf`. Den Rest erledigt der GitHub-Workflow.

## So geht's

1. Oben auf **„Use this template“** klicken (neues Projekt daraus machen) – oder diese Dateien in dein bestehendes Projekt kopieren:
   ```
   .github/workflows/installer.yml
   vorlage/erzeugen.py
   vorlage/installieren.sh
   vorlage/setup.iss
   installer.conf
   ```
2. **`installer.conf`** ausfüllen: Name, welche Datei auf Linux bzw. Windows installiert wird, welche Pakete gebraucht werden. Jede Zeile ist dort erklärt.
3. Ein **Release** auf GitHub erstellen und die Programmdateien anhängen (die, die in `LINUX_FILE` und `WINDOWS_FILE` stehen).
4. Nach ein paar Minuten hängen am Release zusätzlich:
   - `<name>-arch-installer.desktop`, `<name>-deb-installer.desktop`, `<name>-installer.desktop`
   - `<name>-installieren.sh`
   - `<name>-setup.exe`

Den Fortschritt siehst du unter **Actions**. Lädt ein anderer Workflow deine Programmdateien erst später hoch, wartet der Installer-Workflow bis zu 10 Minuten darauf.

## Für die Leute, die dein Programm installieren

- **Linux:** passende `.desktop`-Datei herunterladen und doppelklicken. Beim ersten Mal fragt der Dateimanager, ob er sie ausführen darf.
- **Windows:** `setup.exe` herunterladen und doppelklicken. Windows SmartScreen warnt bei unsignierten Programmen – „Weitere Informationen → Trotzdem ausführen“.

Tipp für die README deines Projekts: Links auf `https://github.com/BENUTZER/REPO/releases/latest/download/DATEINAME` zeigen immer auf die neueste Version.

## Ausprobieren

Dieses Projekt installiert selbst ein kleines **Beispielprogramm** (`beispiel/`), das nur „Hallo“ sagt – die Installer dazu liegen im [neuesten Release](../../releases/latest).

## Hinweise

- Getestet unter CachyOS (KDE); Windows-Setup wird bei jedem Lauf auf GitHub still installiert und wieder entfernt.
- Die Paketnamen in `installer.conf` musst du je Distribution selbst angeben – sie heißen nicht überall gleich.
- macOS wird nicht unterstützt.

Lizenz: MIT

---

# Double-click installer

Template that gives your GitHub project installers on every release automatically – **double-click** to install, like on Windows:

- **Linux:** three double-click files (Arch/CachyOS/Manjaro, Debian/Ubuntu, everything else). They always fetch the latest version, install required packages with **one** password prompt, add a menu entry, and offer **Update** or **Uninstall** when run again.
- **Windows:** a `setup.exe` (Inno Setup) – no admin rights, Start menu entry, desktop shortcut, uninstall via *Apps*.

You only edit **one file**: `installer.conf`. The GitHub workflow does the rest.

## How to

1. Click **“Use this template”** – or copy these files into your existing project:
   ```
   .github/workflows/installer.yml
   vorlage/erzeugen.py
   vorlage/installieren.sh
   vorlage/setup.iss
   installer.conf
   ```
2. Fill in **`installer.conf`**: name, which file to install on Linux and Windows, which packages are needed. Every line is explained there (in German).
3. Create a **release** on GitHub and attach your program files (the ones named in `LINUX_FILE` and `WINDOWS_FILE`).
4. A few minutes later the release also contains the `.desktop` installers, the install script and `<name>-setup.exe`.

Progress is shown under **Actions**. If another workflow uploads your program files later, the installer workflow waits up to 10 minutes for them.

The installers' messages are in German. License: MIT
