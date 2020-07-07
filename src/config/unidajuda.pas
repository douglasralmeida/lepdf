unit unidAjuda;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows;

const
  HH_DISPLAY_TOPIC        = $0000;
  HH_DISPLAY_TOC          = $0001;
  HH_CLOSE_ALL            = $0012;

type
  PHtmlHelpA = ^THtmlHelpA;
  THtmlHelpA = function(hwndCaller: HWND; pszFile: PAnsiChar; uCommand: UINT; dwData: DWORD): HWND; stdcall;

procedure ExibirAjuda(const AjudaID: String='');
procedure FecharAjuda();

const
  HELPDLL: string = 'HHCTRL.OCX';

implementation

uses
  Forms;

var
  ModuloAjuda: HModule;
  HH: THtmlHelpA;
  AjudaVerificada: Boolean;

procedure InitAjuda;
begin
  if (not AjudaVerificada) then
  begin
    AjudaVerificada := True;
    try
      ModuloAjuda := LoadLibrary(PChar(HELPDLL));
    except
      ModuloAjuda := 0;
    end;
    if ModuloAjuda <> 0 then
      try
        pointer(HH) := GetProcAddress(ModuloAjuda, 'HtmlHelpA');
      except
        pointer(HH) := nil;
      end;
  end;
end;

function HtmlHelp(hwndCaller: HWND; pszFile: PChar; uCommand: UINT; dwData: DWORD): HWND;
begin
  if uCommand = HH_CLOSE_ALL then
    if ModuloAjuda = 0 then
      Exit(0);
  InitAjuda;
  if (@HH <> nil) then
    Result := HH(hwndCaller, pszFile, uCommand, dwData)
  else
    Result := 0;
end;

procedure ExibirAjuda(const AjudaID: String);
const
  HH_COMANDO = '%s::/conteudo/%s.htm';
begin
  if AjudaID = '' then
  begin
    HtmlHelp(Application.MainForm.Handle, PChar(Application.HelpFile), HH_DISPLAY_TOC, 0);
    Exit;
  end;
  HtmlHelp(Application.MainForm.Handle, PChar(Format(HH_COMANDO, [Application.HelpFile, AjudaID])), HH_DISPLAY_TOPIC, 0);
end;

procedure FecharAjuda();
begin

end;

initialization
  ModuloAjuda := 0;
  HH := nil;
  AjudaVerificada := False;
finalization
  if (ModuloAjuda <> 0) then
    FreeLibrary(ModuloAjuda);
end.

