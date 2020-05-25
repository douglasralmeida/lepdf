unit unidExcecoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TExcecaoDados = record
    Mensagem: String;
    AjudaID: Integer;
  end;

  EProgramaErro = class(Exception)
    constructor Create(DadosExcecao: TExcecaoDados);
  end;

implementation

constructor EProgramaErro.Create(DadosExcecao: TExcecaoDados);
begin
  inherited CreateHelp(DadosExcecao.Mensagem, DadosExcecao.AjudaID);
end;

end.

