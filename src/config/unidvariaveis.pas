unit unidVariaveis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TVariaveis = class(TObject)
  private
    FArquivoConfig: String;
    FModeloConfig: String;
    FPastaApp: String;
    FPastaArqProgx86: String;
    FPastaConfig: String;
    FPastaModelos: String;
    function GetArquivoConfig: String;
    function GetModeloConfig: String;
    function GetPastaApp: String;
    function GetPastaArqProgx86: String;
    function GetPastaConfig: String;
    function GetPastaModelos: String;
  public
    constructor Create;
    function GetGrupoNome: String;
    function GetAppNome: String;
    property ArquivoConfig: String read GetArquivoConfig;
    property ModeloConfig: String read GetModeloConfig;
    property PastaApp: String read GetPastaApp;
    property PastaArqProgx86: String read GetPastaArqProgx86;
    property PastaConfig: String read GetPastaConfig;
    property PastaModelos: String read GetPastaModelos;
  end;

var
  Variaveis: TVariaveis;

implementation

uses Forms, ShlObj;

const
  APP_NOME = 'Prisma';
  GRUPO_NOME = 'Aplicativos do INSS';

constructor TVariaveis.Create;
var
  Pasta: Array[0..MaxPathLen] of Char;
begin
  inherited;

  Pasta := '';
  FArquivoConfig := 'PRISMAPDF.INI';
  FModeloConfig := 'PRISMAPDF.PRC';
  FPastaApp := ExtractFilePath(Application.ExeName);
  SHGetSpecialFolderPath(0, Pasta, CSIDL_LOCAL_APPDATA, false);
  FPastaConfig := Pasta + '\' + GetGrupoNome + '\' + GetAppNome + '\';
  SHGetSpecialFolderPath(0, Pasta, CSIDL_PROGRAM_FILESX86, false);
  FPastaArqProgx86 := Pasta + '\';
  FPastaModelos := FPastaApp + 'modelos\';
end;

function TVariaveis.GetGrupoNome: String;
begin
  Result := GRUPO_NOME;
end;

function TVariaveis.GetAppNome: String;
begin
  Result := APP_NOME;
end;

function TVariaveis.GetArquivoConfig: String;
begin
  Result := FArquivoConfig;
end;

function TVariaveis.GetModeloConfig: String;
begin
  Result := FModeloConfig;
end;

function TVariaveis.GetPastaApp: String;
begin
  Result := FPastaApp;
end;

function TVariaveis.GetPastaArqProgx86: String;
begin
  Result := FPastaArqProgx86;
end;

function TVariaveis.GetPastaConfig: String;
begin
  Result := FPastaConfig;
end;

function TVariaveis.GetPastaModelos: String;
begin
  Result := FPastaModelos;
end;

end.

