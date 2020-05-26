program config;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Windows,
  Forms, lazcontrols, formPrincipal, unidVariaveis, unidIni, unidExcecoes,
  unidExcecoesLista, unidUtils
  { you can add units after this };

{$R *.res}

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

