; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=AWGG
AppVerName=AWGG 0.5.1 beta
AppPublisherURL=https://sites.google.com/site/awggproject
AppSupportURL=https://sites.google.com/site/awggproject
AppUpdatesURL=https://sites.google.com/site/awggproject
DefaultDirName={pf}\AWGG
DefaultGroupName=AWGG
AllowNoIcons=yes
LicenseFile=..\..\docs\Readme.txt
OutputDir=release
Compression=lzma
SolidCompression=yes
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; On all other architectures it will install in "32-bit mode".
;ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "greek"; MessagesFile: "compiler:Languages\Greek.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "serbiancyrillic"; MessagesFile: "compiler:Languages\SerbianCyrillic.isl"
Name: "serbianlatin"; MessagesFile: "compiler:Languages\SerbianLatin.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\awgg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\awgg.zdli"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\languages\*"; DestDir: "{app}\languages"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\..\*.dll"; DestDir: "{app}"; Flags: skipifsourcedoesntexist
Source: "..\..\*.exe"; DestDir: "{app}"; Flags: skipifsourcedoesntexist

[Icons]
Name: "{group}\AWGG"; Filename: "{app}\awgg.exe"
Name: "{group}\{cm:ProgramOnTheWeb,AWGG}"; Filename: "https://sites.google.com/site/awggproject"
Name: "{group}\{cm:UninstallProgram,AWGG}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\AWGG"; Filename: "{app}\awgg.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\AWGG"; Filename: "{app}\awgg.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\awgg.exe"; Description: "{cm:LaunchProgram,AWGG}"; Flags: nowait postinstall skipifsilent

