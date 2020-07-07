unit unidReg;

{$mode objfpc}{$H+}

interface

uses
  Classes, Registry, SysUtils;

type
  TDadosRegistro = class(TObject)
  private
    FReg: TRegistry;
    FVersao: String;
    procedure Carregar;
    function GetVersao: String;
  public
    constructor Create;
    property Versao: String read GetVersao;
  end;

implementation

const
  REG_DADOS = 'SOFTWARE\INSS\Prisma';
  INFO_NAODISPONIVEL = 'Info. não disponível';

constructor TDadosRegistro.Create;
begin
  inherited;

  FReg := TRegistry.Create;
  FVersao := INFO_NAODISPONIVEL;
  Carregar;
end;

procedure TDadosRegistro.Carregar;
begin
  try
    FReg.RootKey := HKEY_LOCAL_MACHINE;
    if FReg.OpenKeyReadOnly(REG_DADOS) then
    begin
       FVersao := FReg.ReadString('Versao');
    end;
  finally
    FReg.Free;
  end;
end;

function TDadosRegistro.GetVersao: String;
begin
  Result := FVersao;
end;

end.

