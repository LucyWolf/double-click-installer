**Language / Sprache:** [🇬🇧 English](#double-click-installer) | [🇩🇪 Deutsch](#doppelklick-installer)

---

# Double-click installer

Template that gives your GitHub project installers on every release automatically – **double-click** to install, like on Windows:

- **Linux:** three double-click files (Arch/CachyOS/Manjaro, Debian/Ubuntu, everything else). They always fetch the latest version, install required packages with **one** password prompt, add a menu entry, and offer **Update** or **Uninstall** when run again.
- **Windows:** a `setup.exe` (Inno Setup) – no admin rights, start menu entry, desktop shortcut, uninstall via *Apps*.

You only edit **one file**: `installer.conf`. The GitHub workflow does the rest.

## How to

1. Click **“Use this template”** – or copy these files into your existing project:
   ```
   .github/workflows/installer.yml
   template/generate.py
   template/install.sh
   template/setup.iss
   installer.conf
   ```
2. Fill in **`installer.conf`**. Every setting is explained there and can be switched **on or off**:
   - without `#` in front = **on**
   - with `#` in front = **off** (the default applies)

   | Setting | Meaning | Off |
   |---|---|---|
   | `APP_NAME`, `APP_ID` | name and short name (required) | – |
   | `APP_COMMENT` | description in the menu | none |
   | `VERSION` | version number in the installers and in Windows *Apps* | taken from the release tag |
   | `LINUX_FILE`, `LINUX_RUN` | file installed on Linux and how it starts | no Linux installers |
   | `PKGS_ARCH`, `PKGS_DEB`, `PKGS_RPM`, `PKGS_SUSE` | extra packages per distribution | none |
   | `ROOT_CMDS` | commands run once with admin rights | none |
   | `WINDOWS_FILE` | file installed by the setup.exe | no Windows setup |
   | `ICON_PNG`, `ICON_ICO` | icons from the repository | default icon |
3. Create a **release** on GitHub and attach your program files (the ones in `LINUX_FILE` and `WINDOWS_FILE`).
4. A few minutes later the release also contains:
   - `<id>-arch-installer.desktop`, `<id>-deb-installer.desktop`, `<id>-installer.desktop`
   - `<id>-install.sh`
   - `<id>-setup.exe`

Progress is shown under **Actions**. If another workflow uploads your program files later, the installer workflow waits up to 10 minutes for them.

## For the people installing your program

- **Linux:** download the matching `.desktop` file and double-click it. The first time, the file manager asks whether it may run it.
- **Windows:** download `setup.exe` and double-click it. Windows SmartScreen warns about unsigned programs – “More info → Run anyway”.

Tip for your project's README: links to `https://github.com/USER/REPO/releases/latest/download/FILENAME` always point to the latest version.

## Try it

This project installs a small **example app** (`example/`) that only says “Hello” – its installers are in the [latest release](../../releases/latest).

## Notes

- Tested on CachyOS (KDE); the Windows setup is installed silently and removed again on every workflow run.
- Package names differ between distributions, so they are set per distribution.
- macOS is not supported.

License: MIT

---

# Doppelklick-Installer

Vorlage, mit der dein GitHub-Projekt bei jedem Release automatisch Installer bekommt – **per Doppelklick**, wie man es von Windows kennt:

- **Linux:** drei Doppelklick-Dateien (Arch/CachyOS/Manjaro, Debian/Ubuntu, alle anderen). Sie laden immer die neueste Version, installieren nötige Pakete mit **einer** Passwortabfrage, legen einen Menüeintrag an und bieten beim erneuten Start **Update** oder **Uninstall** an.
- **Windows:** eine `setup.exe` (Inno Setup) – ohne Admin-Rechte, mit Startmenü, Desktop-Verknüpfung und Deinstallation über „Apps“.

Du passt nur **eine Datei** an: `installer.conf`. Den Rest erledigt der GitHub-Workflow. Die Installer selbst sprechen Englisch.

## So geht's

1. Oben auf **„Use this template“** klicken – oder diese Dateien in dein bestehendes Projekt kopieren:
   ```
   .github/workflows/installer.yml
   template/generate.py
   template/install.sh
   template/setup.iss
   installer.conf
   ```
2. **`installer.conf`** ausfüllen. Jede Einstellung ist dort (englisch) erklärt und lässt sich **ein- und ausschalten**:
   - ohne `#` davor = **an**
   - mit `#` davor = **aus** (dann gilt der Standard)

   | Einstellung | Bedeutung | aus |
   |---|---|---|
   | `APP_NAME`, `APP_ID` | Name und Kurzname (Pflicht) | – |
   | `APP_COMMENT` | Beschreibung im Menü | keine |
   | `VERSION` | Versionsnummer in den Installern und unter Windows „Apps“ | aus dem Release-Tag |
   | `LINUX_FILE`, `LINUX_RUN` | Datei für Linux und wie sie startet | keine Linux-Installer |
   | `PKGS_ARCH`, `PKGS_DEB`, `PKGS_RPM`, `PKGS_SUSE` | zusätzliche Pakete je Distribution | keine |
   | `ROOT_CMDS` | Befehle, die einmal mit Admin-Rechten laufen | keine |
   | `WINDOWS_FILE` | Datei, die die setup.exe installiert | kein Windows-Setup |
   | `ICON_PNG`, `ICON_ICO` | Symbole aus dem Repo | Standardsymbol |
3. Ein **Release** auf GitHub erstellen und die Programmdateien anhängen (die aus `LINUX_FILE` und `WINDOWS_FILE`).
4. Nach ein paar Minuten hängen am Release zusätzlich die drei `.desktop`-Installer, `<id>-install.sh` und `<id>-setup.exe`.

Den Fortschritt siehst du unter **Actions**. Lädt ein anderer Workflow deine Programmdateien erst später hoch, wartet der Installer-Workflow bis zu 10 Minuten darauf.

## Für die Leute, die dein Programm installieren

- **Linux:** passende `.desktop`-Datei herunterladen und doppelklicken. Beim ersten Mal fragt der Dateimanager, ob er sie ausführen darf.
- **Windows:** `setup.exe` herunterladen und doppelklicken. Windows SmartScreen warnt bei unsignierten Programmen – „Weitere Informationen → Trotzdem ausführen“.

## Ausprobieren

Dieses Projekt installiert selbst ein kleines **Beispielprogramm** (`example/`), das nur „Hello“ sagt – die Installer dazu liegen im [neuesten Release](../../releases/latest).

Lizenz: MIT
