program config;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, formPrincipal, unidVariaveis, unidIni, unidExcecoes,
  unidExcecoesLista, unidUtils
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Configurações do PrismaPDF';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TJanelaPadrao, JanelaPadrao);
  Application.Run;
end.

