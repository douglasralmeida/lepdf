unit unidIni;

{$mode objfpc}{$H+}

interface

uses
  Classes, IniFiles, SysUtils;

type
  TArquivoIni = class(TObject)
  private
    FArquivoConf: String;
    FIni: TIniFile;
    function GetModoExibicao: Integer;
    function GetLocalizacaoPDF24: String;
    function GetArgumentosPDF24: String;
    function GetNomeFonte: String;
    function GetExcluirSequenciaCarac: Boolean;
    function GetSequenciaCaracAExcluir: String;
    function GetUsarParamINI: Boolean;
    procedure SetModoExibicao(Value: Integer);
    procedure SetLocalizacaoPDF24(Value: String);
    procedure SetArgumentosPDF24(Value: String);
    procedure SetNomeFonte(Value: String);
    procedure SetSequenciaCaracAExcluir(Value: String);
    procedure SetUsarParamINI(Value: Boolean);
    procedure SetExcluirSequenciaCarac(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Salvar;
    property ModoExibicao: Integer read GetModoExibicao write SetModoExibicao;
    property NomeFonte: String read GetNomeFonte write SetNomeFonte;
    property LocalizacaoPDF24: String read GetLocalizacaoPDF24 write SetLocalizacaoPDF24;
    property ArgumentosPDF24: String read GetArgumentosPDF24 write SetArgumentosPDF24;
    property SequenciaCaracAExcluir: String read GetSequenciaCaracAExcluir write SetSequenciaCaracAExcluir;
    property UsarParamINI: Boolean read GetUsarParamINI write SetUsarParamINI;
    property ExcluirSequenciaCarac: Boolean read GetExcluirSequenciaCarac write SetExcluirSequenciaCarac;
  end;

implementation

uses
  FileUtil, unidExcecoes, unidExcecoesLista, unidVariaveis, unidUtils;

constructor TArquivoIni.Create;
begin
  inherited;

  PrepararPastaConfig;
  FArquivoConf := Variaveis.PastaConfig + Variaveis.ArquivoConfig;
  if not FileExists(FArquivoConf) then
    if not CopyFile(Variaveis.PastaModelos + Variaveis.ModeloConfig, FArquivoConf, true) then
      raise EProgramaErro.Create(excecaoCopiarModeloConfig);
  FIni := TIniFile.Create(FArquivoConf);
  FIni.CacheUpdates := true;
end;

destructor TArquivoIni.Destroy;
begin
  if Assigned(FIni) then
    FIni.Free;

  inherited;
end;

function TArquivoIni.GetModoExibicao: Integer;
begin
  Result := FIni.ReadInteger('Configuracoes', 'ModoGeracao', 2);
end;

function TArquivoIni.GetLocalizacaoPDF24: String;
var
  Resultado: String;
begin
  Resultado := FIni.ReadString('Configuracoes', 'LocalizacaoPDF24', '');
  Result := Resultado.Replace('\\', '\');
end;

function TArquivoIni.GetArgumentosPDF24: String;
begin
  Result := FIni.ReadString('Configuracoes', 'ArgumentosPDF24', '');
end;

function TArquivoIni.GetExcluirSequenciaCarac: Boolean;
begin
  Result := FIni.ValueExists('Configuracoes', 'SequenciaApagar');
end;

function TArquivoIni.GetNomeFonte: String;
begin
  Result := FIni.ReadString('Configuracoes', 'NomeFonte', '');
end;

function TArquivoIni.GetSequenciaCaracAExcluir: String;
begin
  Result := FIni.ReadString('Configuracoes', 'SequenciaApagar', '');
end;

function TArquivoIni.GetUsarParamINI: Boolean;
begin
  Result := FIni.ReadBool('Configuracoes', 'UsarParamINI', false);
end;

procedure TArquivoIni.Salvar;
begin
  FIni.UpdateFile;
end;

procedure TArquivoIni.SetModoExibicao(Value: Integer);
begin
  FIni.WriteInteger('Configuracoes', 'ModoGeracao', Value);
  //FArquivoIni.UpdateFile;
end;

procedure TArquivoIni.SetLocalizacaoPDF24(Value: String);
var
  Valor: String;
begin
  Valor := Value.Replace('\', '\\');
  FIni.WriteString('Configuracoes', 'LocalizacaoPDF24', Valor);
  //FArquivoIni.UpdateFile;
end;

procedure TArquivoIni.SetArgumentosPDF24(Value: String);
begin
  FIni.WriteString('Configuracoes', 'ArgumentosPDF24', Value);
  //FArquivoIni.UpdateFile;
end;

procedure TArquivoIni.SetExcluirSequenciaCarac(Value: Boolean);
begin
  if not Value then
    FIni.DeleteKey('Configuracoes', 'SequenciaApagar');
    //FArquivoIni.UpdateFile;
end;

procedure TArquivoIni.SetNomeFonte(Value: String);
begin
  FIni.WriteString('Configuracoes', 'NomeFonte', Value);
  //FArquivoIni.UpdateFile;
end;

procedure TArquivoIni.SetSequenciaCaracAExcluir(Value: String);
begin
  FIni.WriteString('Configuracoes', 'SequenciaApagar', Value);
  //FArquivoIni.UpdateFile;
end;

procedure TArquivoIni.SetUsarParamINI(Value: Boolean);
begin
  FIni.WriteBool('Configuracoes', 'UsarParamINI', Value);
  //FArquivoIni.UpdateFile;
end;

end.
