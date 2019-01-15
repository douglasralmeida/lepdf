; Script para o instalador do Componente PDF para Prisma
; requer InnoSetup

#include "ambiente.iss"

#define MyAppName "Componente PDF para Prisma"
#define MyAppVersion "1.0.0"
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
UninstallDisplayIcon={uninstallexe}
VersionInfoVersion=1.0.0
VersionInfoProductVersion=1.0
WizardImageFile=..\res\setupgrande.bmp
WizardSmallImageFile=..\res\setuppequeno.bmp

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
Source: "..\dist\java32.exe"; DestDir: "{pf}\Java\jre6\bin"; DestName: "java.exe"; Flags: ignoreversion 32bit; Check: not IsWin64
Source: "..\dist\java64.exe"; DestDir: "{pf}\Java\jre6\bin"; DestName: "java.exe"; Flags: ignoreversion 64bit; Check: IsWin64
Source: "..\dist\lepdf.jar"; DestDir: "C:\cnislinha"; Flags: ignoreversion
Source: "..\dist\manual.pdf"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\dist\deltmpfiles.bat"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Instruções para Geração de PDF no Prisma"; Filename: "{app}\manual.pdf"; WorkingDir: "{app}"

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

[Code]
function InitializeSetup(): boolean;
var
  ResultCode: integer;
begin
  { Checa a existencia do JRE instalado }
  if Exec('java', '-version', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
  begin
    Result := true;    
  end
  else
  begin          
    if MsgBox('O Componente PDF para Prisma requer a plataforma Java instalada no seu computador. Baixe e instale o Java apropriado para o seu computador e, depois, execute este instalador novamente. Você deseja ir para o site do Java agora?', mbConfirmation, MB_YESNO) = idYes then
    begin
      Result := false;
      ShellExec('open', 'https://java.com/download/', '', '', SW_SHOW, ewNoWait, ResultCode);
    end;  
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  { Remove o caminho do JRE 6 do systempath }
  if CurStep = ssPostInstall then
    EnvRemovePath(ExpandConstant('{pf}') + '\Java\jre6\bin');
end;