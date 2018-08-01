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
ArchitecturesInstallIn64BitMode=x64
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
Source: "..\dist\java32.exe"; DestDir: "{pf}\Java\jre6\bin"; DestName: "java.exe"; Flags: ignoreversion 32bit
Source: "..\dist\java64.exe"; DestDir: "{pf}\Java\jre6\bin"; DestName: "java.exe"; Flags: ignoreversion 64bit
Source: "..\dist\lepdf.jar"; DestDir: "C:\cnislinha"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Code]
function InitializeSetup(): boolean;
var
  ResultCode: integer;
begin
  if Exec('java', '-version', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
    Result := true;    
  end
  else begin          
    if MsgBox('O Componente PDF para Prisma requer a plataforma Java instalada no seu computador. Baixe e instale o Java apropriado para o seu computador e, depois, execute este instalador novamente. Você deseja ir para o site do Java agora?', mbConfirmation, MB_YESNO) = idYes then begin
      Result := false;
      ShellExec('open', 'https://java.com/download/', '', '', SW_SHOW, ewNoWait, ResultCode);
    end;  
  end;
end;
