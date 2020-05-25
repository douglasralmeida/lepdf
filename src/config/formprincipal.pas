unit formPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, EditBtn, unidIni;

type

  { TJanelaPadrao }

  TJanelaPadrao = class(TForm)
    BotaoAplicar: TButton;
    BotaoRestaurar: TButton;
    BotaoCancelar: TButton;
    BotaoOK: TButton;
    ChecExcluirSequenciaCarac: TCheckBox;
    checUsarPDFParam: TCheckBox;
    EditArgsPDF24: TEdit;
    EditSequenciaExclusao: TEdit;
    EditCaminhoPDF24: TFileNameEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Pagina: TPageControl;
    RadioNaoExecutar: TRadioButton;
    RadioExibirPDFMinimizado: TRadioButton;
    RadioExibirPDF: TRadioButton;
    RadioPDFParaPDF24: TRadioButton;
    TabPrincipal: TTabSheet;
    tabAutomacao: TTabSheet;
    tabReiniciar: TTabSheet;
    Sobre: TTabSheet;
    procedure BotaoAplicarClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure BotaoOKClick(Sender: TObject);
    procedure BotaoRestaurarClick(Sender: TObject);
    procedure ChecExcluirSequenciaCaracChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label12Click(Sender: TObject);
  private
    ArquivoINI: TArquivoIni;
    function ChecarControles: Boolean;
    procedure SalvarConfiguracoes;
  public

  end;

var
  JanelaPadrao: TJanelaPadrao;

implementation

uses LClIntf, Windows, unidVariaveis, unidUtils;

{$R *.lfm}

{ TJanelaPadrao }

procedure TJanelaPadrao.BotaoCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TJanelaPadrao.BotaoOKClick(Sender: TObject);
begin
  if ChecarControles then
  begin
    SalvarConfiguracoes;
    Close;
  end;
end;

procedure TJanelaPadrao.BotaoAplicarClick(Sender: TObject);
begin
  if ChecarControles then
    SalvarConfiguracoes;
end;

procedure TJanelaPadrao.BotaoRestaurarClick(Sender: TObject);
begin
  RadioExibirPDF.Checked := true;
  EditCaminhoPDF24.Text := Variaveis.PastaArqProgx86 + 'PDF24\pdf24-Creator.exe';
  EditArgsPDF24.Text := '%s';
  ChecExcluirSequenciaCarac.Checked := false;
  EditSequenciaExclusao.Enabled := false;
  EditSequenciaExclusao.Text := '';
  checUsarPDFParam.Checked := false;
end;

function TJanelaPadrao.ChecarControles: Boolean;
begin
  if not (RadioNaoExecutar.Checked or
          RadioExibirPDFMinimizado.Checked or
          RadioExibirPDF.Checked or
          RadioPDFParaPDF24.Checked) then
  begin
    Pagina.ActivePage := TabPrincipal;
    ExibirMensagemErro('Nenhuma ação de exibição do relatório foi selecionada. Selecione, pelo menos, uma ação antes de continuar.', 100);
    if RadioNaoExecutar.CanFocus then
      RadioNaoExecutar.SetFocus;
    Exit(false);
  end;
  if RadioPDFParaPDF24.Checked then
  begin
    if Length(Trim(EditCaminhoPDF24.Text)) = 0 then
    begin
      Pagina.ActivePage := TabPrincipal;
      ExibirMensagemErro('A localização do aplicativo PDF24 não foi informada. Informe a sua localização antes de continuar.', 100);
      if EditCaminhoPDF24.CanFocus then
        EditCaminhoPDF24.SetFocus;
      Exit(false);
    end;
  end;
  if ChecExcluirSequenciaCarac.Checked then
  begin
    if Length(Trim(EditSequenciaExclusao.Text)) = 0 then
    begin
      Pagina.ActivePage := TabAutomacao;
      ExibirMensagemErro('Você esolheu excluir do relatório uma sequencia de caracateres, mas ela não foi informada. Informe uma sequencia de caracteres antes de continuar.', 100);
      if EditSequenciaExclusao.CanFocus then
        EditSequenciaExclusao.SetFocus;
      Exit(false);
    end;
  end;
  Result := true;
end;

procedure TJanelaPadrao.ChecExcluirSequenciaCaracChange(Sender: TObject);
begin
  EditSequenciaExclusao.Enabled := ChecExcluirSequenciaCarac.Checked;
end;

procedure TJanelaPadrao.FormActivate(Sender: TObject);
begin
  Pagina.ActivePageIndex := 0;
  SetWindowLong(ChecExcluirSequenciaCarac.Handle, GWL_STYLE, GetWindowLong(ChecExcluirSequenciaCarac.Handle, GWL_STYLE) OR BS_MULTILINE);
  case ArquivoINI.ModoExibicao of
    0: RadioNaoExecutar.Checked := true;
    1: RadioExibirPDFMinimizado.Checked := true;
    2: RadioExibirPDF.Checked := true;
    3: RadioPDFParaPDF24.Checked := true;
    else
      RadioNaoExecutar.Checked := true;
  end;
  EditCaminhoPDF24.Text := ArquivoINI.LocalizacaoPDF24;
  EditArgsPDF24.Text := ArquivoINI.ArgumentosPDF24;
  ChecExcluirSequenciaCarac.Checked := ArquivoINI.ExcluirSequenciaCarac;
  if ChecExcluirSequenciaCarac.Checked then
    EditSequenciaExclusao.Text := ArquivoINI.SequenciaCaracAExcluir;
  checUsarPDFParam.Checked := ArquivoINI.UsarParamINI;
end;

procedure TJanelaPadrao.FormCreate(Sender: TObject);
begin
  Variaveis := TVariaveis.Create;
  ArquivoINI := TArquivoINI.Create;
end;

procedure TJanelaPadrao.FormDestroy(Sender: TObject);
begin
  if Assigned(ArquivoINI) then
    ArquivoINI.Free;
  if Assigned(Variaveis) then
    Variaveis.Free;
end;

procedure TJanelaPadrao.Label12Click(Sender: TObject);
begin
  OpenDocument('http://www.github.com/douglasralmeida/lepdf');
end;

procedure TJanelaPadrao.SalvarConfiguracoes;
begin
  if RadioNaoExecutar.Checked then
    ArquivoINI.ModoExibicao := 0
  else if RadioExibirPDFMinimizado.Checked then
    ArquivoINI.ModoExibicao := 1
  else if RadioExibirPDF.Checked then
    ArquivoINI.ModoExibicao := 2
  else if RadioPDFParaPDF24.Checked then
    ArquivoINI.ModoExibicao := 3;
  ArquivoINI.LocalizacaoPDF24 := EditCaminhoPDF24.Text;
  ArquivoINI.ArgumentosPDF24 := EditArgsPDF24.Text;
  if ChecExcluirSequenciaCarac.Checked then
    ArquivoINI.SequenciaCaracAExcluir := EditSequenciaExclusao.Text
  else
    ArquivoINI.ExcluirSequenciaCarac := false;
  ArquivoINI.UsarParamINI := checUsarPDFParam.Checked;
  ArquivoINI.Salvar;
end;

end.

