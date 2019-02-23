; Script para o instalador do Componente PDF para Prisma
; requer InnoSetup

#include "ambiente.iss"

#define MyAppName "Componente PDF para Prisma"
#define MyAppVersion "2.0.0"
#define MyAppPublisher "Douglas R. Almeida"
#define MyAppURL "https://github.com/douglasralmeida/lepdf"

[Setup]
AppId={{22EFC3AD-9B60-4497-A15F-1936987858C9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AllowNoIcons=yes
ArchitecturesInstallIn64BitMode=x64
ChangesEnvironment=true
Compression=lzma
DefaultDirName={pf}\Componente PDF para Prisma
DefaultGroupName=Componente PDF para Prisma
DisableWelcomePage=False
MinVersion=0,6.1
OutputBaseFilename=prismapdfinstala
SetupIconFile=..\res\setupicone.ico
SolidCompression=yes
ShowLanguageDialog=no
UninstallDisplayName=Componente PDF para Prisma
UninstallDisplayIcon={app}\loader.exe
VersionInfoVersion=2.0.0
VersionInfoProductVersion=2.0
WizardImageFile=..\res\setupgrande.bmp
WizardSmallImageFile=..\res\setuppequeno.bmp
UninstallDisplaySize=50000000
OutputDir=output
ArchitecturesAllowed=x64
DisableReadyPage=True

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\dist\loader32.exe"; DestDir: "{app}"; DestName: "loader.exe"; Flags: ignoreversion 32bit; Components: programa; Check: not IsWin64
Source: "..\dist\loader64.exe"; DestDir: "{app}"; DestName: "loader.exe"; Flags: ignoreversion 64bit; Components: programa; Check: IsWin64
Source: "..\dist\manual.pdf"; DestDir: "{app}"; Flags: ignoreversion; Components: programa
Source: "..\dist\deltmpfiles.bat"; DestDir: "{app}"; Flags: ignoreversion; Components: programa
Source: "..\dist\jre\*"; DestDir: "{app}\jre"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: java

[Dirs]
Name: "{pf}\Java\jre6\bin"; Components: programa

[Icons]
Name: "{group}\Manual para Geração de PDF no Prisma"; Filename: "{app}\manual.pdf"; WorkingDir: "{app}"

[Run]
Filename: "schtasks"; \
  Parameters: "/Create /RU SYSTEM /F /SC DAILY /TN ""Limpeza diária do Componente PDF para Prisma"" /TR ""'{app}\deltmpfiles.bat'"" /ST 01:00"; \
  Flags: runhidden; \
  StatusMsg: "Definindo tarefas agendadas..."

Filename: "schtasks"; \
  Parameters: "/Create /RU SYSTEM /F /SC ONLOGON /TN ""Limpeza durante logon do Componente PDF para Prisma"" /TR ""'{app}\deltmpfiles.bat'"""; \
  Flags: runhidden; \
  StatusMsg: "Definindo tarefas agendadas..."

[UninstallRun]
Filename: "schtasks"; \
  Parameters: "/Delete /F /TN ""Limpeza diária do Componente PDF para Prisma"""; \
  Flags: runhidden; \
  StatusMsg: "Excluindo tarefas agendadas..."

Filename: "schtasks"; \
  Parameters: "/Delete /F /TN ""Limpeza durante logon do Componente PDF para Prisma"""; \
  Flags: runhidden; \
  StatusMsg: "Excluindo tarefas agendadas..."

[Components]
Name: "programa"; Description: "Arquivos do programa"; ExtraDiskSpaceRequired: 1024; Types: compact custom full; Flags: fixed
Name: "java"; Description: "Subsistema Java"; Types: compact custom full; Flags: fixed

[Code]
function CreateSoftLink(lpSymlinkFileName, lpTargetFileName: string; dwFlags: Integer): Boolean;
  external 'CreateSymbolicLinkW@kernel32.dll stdcall';

procedure CriarJavaLink;
var
  ExistingFile, LinkFile: string;
begin
  ExistingFile := ExpandConstant('{app}\loader.exe');
  LinkFile := ExpandConstant('{pf}\Java\jre6\bin\java.exe');
  CreateSoftLink(LinkFile, ExistingFile, 0);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    
    { Remove o caminho do JRE 6 do systempath }
    EnvRemovePath(ExpandConstant('{pf}') + '\Java\jre6\bin');
    EnvRemovePath(ExpandConstant('{pf32}') + '\Java\jre6\bin');

    {  Cria um link simbolico que finge ser o executavel Java  }
    CriarJavaLink;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
    DeleteFile(ExpandConstant('{pf}\Java\jre6\bin\java.exe'));
end;