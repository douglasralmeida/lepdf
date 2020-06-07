program config;

{$mode objfpc}{$H+}

uses
  Windows, Forms, Interfaces, formPrincipal, unidUtils;

{$R *.res}
{$R maisrecursos.rc}

var
  Mutex: THandle;

begin
  RequireDerivedFormResource := True;
  Mutex := CriarMutex;
  Application.Title:='Configurações do PrismaPDF';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TJanelaPadrao, JanelaPadrao);
  Application.Run;
  CloseHandle(Mutex);
end.

