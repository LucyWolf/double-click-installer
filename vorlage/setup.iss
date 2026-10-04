; Windows-Setup (Inno Setup), erzeugt aus vorlage/setup.iss und installer.conf
; Installiert pro Benutzer ohne Admin-Rechte, mit Startmenü, Desktop-Verknüpfung und Deinstallation.
#define AppName "@APP_NAME@"
#define AppVersion "@VERSION@"
#define AppExe "@WINDOWS_FILE@"

[Setup]
AppId={{@APP_GUID@}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisherURL=https://github.com/@REPO@
DefaultDirName={localappdata}\Programs\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableDirPage=yes
PrivilegesRequired=lowest
OutputDir=ausgabe
OutputBaseFilename=@APP_ID@-setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
@SETUP_ICON@
UninstallDisplayIcon={app}\{#AppExe}
CloseApplications=yes

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "programm\{#AppExe}"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent shellexec
