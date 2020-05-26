; Script para o instalador do Componente PDF para Prisma
; requer InnoSetup 6

#include "ambiente.iss"

#define MyAppName "Componente PDF para Prisma"
#define MyAppVersion "2.1.0"
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
AlwaysRestart=True
ArchitecturesInstallIn64BitMode=x64
ChangesAssociations=True
ChangesEnvironment=true
Compression=lzma
DefaultDirName={pf}\Componente PrismaPDF
DefaultGroupName=Componente PrismaPDF
DisableReadyPage=True
DisableWelcomePage=False
MinVersion=0,6.1
OutputBaseFilename=prismapdfinstala
OutputDir=output
SetupIconFile=..\res\setupicone.ico
SolidCompression=yes
ShowLanguageDialog=no
UninstallDisplayName=Componente PrismaPDF
UninstallDisplayIcon={app}\loader.exe
UninstallDisplaySize=50000000
VersionInfoVersion=2.1.0
VersionInfoProductVersion=2.1
WizardImageFile=..\res\setupgrande.bmp
WizardSmallImageFile=..\res\setuppequeno.bmp
WizardStyle=modern

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Dirs]
Name: "{pf}\Java\jre6\bin"; Components: programa
Name: "{localappdata}\Aplicativos do INSS\Componente PrismaPDF"; Components: programa

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\bin\loader32.exe"; DestDir: "{app}"; DestName: "loader.exe"; Flags: ignoreversion 32bit; Components: programa; Check: not IsWin64
Source: "..\bin\loader64.exe"; DestDir: "{app}"; DestName: "loader.exe"; Flags: ignoreversion 64bit; Components: programa; Check: IsWin64
Source: "..\bin\manual.pdf"; DestDir: "{app}"; Flags: ignoreversion; Components: programa
Source: "..\modelos\prismapdf.prc"; DestDir: "{app}"; Flags: ignoreversion; Components: programa
Source: "..\modelos\prismapdf.prc"; DestDir: "{localappdata}\Aplicativos do INSS\Componente PrismaPDF"; DestName: "prismapdf.ini"; Flags: ignoreversion; Components: programa
Source: "..\scripts\deltmpfiles.cmd"; DestDir: "{app}"; Flags: ignoreversion; Components: programa
Source: "..\bin\jre32\*"; DestDir: "{app}\jre"; Flags: ignoreversion 64bit createallsubdirs recursesubdirs; Components: java
Source: "..\bin\jre64\*"; DestDir: "{app}\jre"; Flags: ignoreversion 32bit createallsubdirs recursesubdirs; Components: java


[Icons]
Name: "{group}\Manual para Geração de PDF no Prisma"; Filename: "{app}\manual.pdf"; WorkingDir: "{app}"
Name: "{group}\Configurações do PrismaPDF"; Filename: "{localappdata}\Aplicações do INSS\Componente PrismaPDF\config.ini"; WorkingDir: "{localappdata}\Aplicações do INSS\Componente PrismaPDF"

[Run]
Filename: "schtasks"; \
  Parameters: "/Create /RU SYSTEM /F /SC DAILY /TN ""Limpeza diária do Componente PrismaPDF"" /TR ""'{app}\deltmpfiles.bat'"" /ST 01:00"; \
  Flags: runhidden; \
  StatusMsg: "Definindo tarefas agendadas..."

Filename: "schtasks"; \
  Parameters: "/Create /RU SYSTEM /F /SC ONLOGON /TN ""Limpeza durante logon do Componente PrismaPDF"" /TR ""'{app}\deltmpfiles.bat'"""; \
  Flags: runhidden; \
  StatusMsg: "Definindo tarefas agendadas..."

[UninstallRun]
Filename: "schtasks"; \
  Parameters: "/Delete /F /TN ""Limpeza diária do Componente PrismaPDF"""; \
  Flags: runhidden; \
  StatusMsg: "Excluindo tarefas agendadas..."

Filename: "schtasks"; \
  Parameters: "/Delete /F /TN ""Limpeza durante logon do Componente PrismaPDF"""; \
  Flags: runhidden; \
  StatusMsg: "Excluindo tarefas agendadas..."

[Components]
Name: "programa"; Description: "Arquivos do programa"; ExtraDiskSpaceRequired: 1024; Types: compact custom full; Flags: fixed
Name: "java"; Description: "Subsistema Java"; Types: compact custom full; Flags: fixed

[Code]
function CreateSoftLink(lpSymlinkFileName, lpTargetFileName: String; dwFlags: Integer): Boolean;
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
  if CurStep = ssInstall then
  begin
    { Apaga o diretório C:\CNISLINHA }
    DelTree('C:\CNISLINHA', True, True, True);

    { Cria o diretório C:\cnislinha (minúsculo) }
    CreateDir('C:\cnislinha');
  end
  else if CurStep = ssPostInstall then
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
  begin
    { Apaga o softlink }
    DeleteFile(ExpandConstant('{pf}\Java\jre6\bin\java.exe'));

    { Apaga do diretório do softlink }
    DelTree(ExpandConstant('{pf}\Java\jre6'), True, True, True);

    { Apaga o diretório C:\cnislinha }
    DelTree('C:\cnislinha', True, True, True);
  end;
end;