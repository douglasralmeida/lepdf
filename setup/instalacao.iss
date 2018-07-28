; Script para o instalador do Componente PDF para Prisma

#define MyAppName "Componente PDF para Prisma"
#define MyAppVersion "1.0.5"
#define MyAppPublisher "Douglas R. Almeida"
#define MyAppURL "https://github.com/douglasralmeida"

[Setup]
AppId={{22EFC3AD-9B60-4497-A15F-1936987858C9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\Aplicativos do INSS\Componente PDF para Prisma
DefaultGroupName=Aplicativos do INSS\Componente PDF para Prisma
AllowNoIcons=yes
OutputBaseFilename=prismapdfinstala
Compression=lzma
SolidCompression=yes
ShowLanguageDialog=no
UninstallDisplayName=Componente PDF para Prisma
VersionInfoVersion=1.0.5
VersionInfoProductVersion=1.0
MinVersion=0,6.1

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
Source: "..\dist\java.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\dist\lepdf.jar"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files