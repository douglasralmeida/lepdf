unit unidUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TTupla = record
    Texto1: String;
    Texto2: String;
  end;

procedure ExibirMensagemErro(const Mensagem: String; const AjudaID: Integer=0);
function ExibirMensagemInfo(const Mensagem: String; const Desc: String; ExibirNaoMostrarNovamente: Boolean): Boolean;
function ExibirPergunta(const Mensagem: String; const Opcoes: Array of String; const Cancelar: Integer): Integer;
procedure PrepararPastaConfig;
function SepararTexto(Texto: String; Sep: Char): TTupla;

implementation

uses Controls, Dialogs, unidExcecoes, unidExcecoesLista, unidVariaveis;

function SepararTexto(Texto: String; Sep: Char): TTupla;
var
  Posicao: Integer;
begin
  Posicao := Pos(Sep, Texto);
  Result.Texto1 := LeftStr(Texto, Posicao - 1);
  Result.Texto2 := RightStr(Texto, Texto.Length - Posicao);
end;

procedure PrepararPastaConfig;
var
  PastaConfigPai: String;
begin
  PastaConfigPai := ExtractFilePath(ExcludeTrailingPathDelimiter(Variaveis.PastaConfig));
  if not DirectoryExists(PastaConfigPai) then
    if not CreateDir(PastaConfigPai) then
      raise EProgramaErro.Create(excecaoCriarDirConfig);
  if not DirectoryExists(Variaveis.PastaConfig) then
    if not CreateDir(Variaveis.PastaConfig) then
      raise EProgramaErro.Create(excecaoCriarDirConfig);
end;

function DialogoCriar(const Mensagem: String): TTaskDialog;
begin
  Result := TTaskDialog.Create(nil);
  with Result do
  begin
    CommonButtons := [];
    Flags := Flags + [tfEnableHyperlinks, tfPositionRelativeToWindow];
    Title := Mensagem;
  end;
end;

procedure ExibirMensagemErro(const Mensagem: String; const AjudaID: Integer=0);
begin
  with DialogoCriar(Mensagem) do
    try
      Caption := 'Erro';
      MainIcon := tdiError;
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := 'OK';
        ModalResult := mrOK;
      end;
      if AjudaID > 0 then
      begin
        FooterIcon := tdiInformation;
        FooterText := 'Para obter ajuda sobre este erro, <A HREF="executablestring">clique aqui</A>.';
      end;
      Execute;
    finally
      Free;
    end
end;

function ExibirMensagemInfo(const Mensagem: String; const Desc: String; ExibirNaoMostrarNovamente: Boolean): Boolean;
begin
  with DialogoCriar(Mensagem) do
    try
      Caption := 'Informação';
      ExpandedText := Desc;
      ExpandButtonCaption := 'Saiba mais sobre isso';
      MainIcon := tdiInformation;
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := 'OK';
        ModalResult := mrOK;
      end;
      if ExibirNaoMostrarNovamente then
        VerificationText := 'Não exibir esta mensagem novamente.';
      Execute;
      Result := ExibirNaoMostrarNovamente and (tfVerificationFlagChecked in Flags);
    finally
      Free;
    end
end;

function ExibirPergunta(const Mensagem: String; const Opcoes: Array of String; const Cancelar: Integer): Integer;
var
  I: Integer;
  Opcao: String;
begin
  with DialogoCriar(Mensagem) do
  begin
    try
      Caption := 'Pergunta';
      Flags := [tfUseCommandLinks];
      MainIcon := tdiQuestion;
      I := 0;
      for Opcao in Opcoes do
        with TTaskDialogButtonItem(Buttons.Add) do
        begin
          Caption := Opcao;
          ModalResult := I;
          Inc(I);
        end;
        if Execute then
          Result := ModalResult
        else
          Result := Cancelar;
    finally
      Free;
    end;
  end;
end;

end.

