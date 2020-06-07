unit formPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, EditBtn, Windows, unidIni;

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
    ImagemRelatorio: TImage;
    ImagemPDF24: TImage;
    ImagemCaracteres: TImage;
    ImagemParam: TImage;
    ImagemRestaura: TImage;
    ImagemLogo: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    TextoConfigRestauradas: TLabel;
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
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure PaginaChange(Sender: TObject);
  private
    ArquivoINI: TArquivoIni;
    NomeFonte: String;
    procedure Ajuda;
    function CarregarRecursos: Boolean;
    function ChecarControles: Boolean;
    procedure SalvarConfiguracoes;
  protected
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  public

  end;

var
  JanelaPadrao: TJanelaPadrao;

implementation

uses LClIntf, LCLType, unidAjuda, unidVariaveis, unidUtils;

{$R *.lfm}

{ TJanelaPadrao }
procedure TJanelaPadrao.Ajuda;
begin
  if Pagina.ActivePage = TabPrincipal then
    ExibirAjuda('opcoesrelpdf')
  else if Pagina.ActivePage = TabAutomacao then
    ExibirAjuda('opcoesauto')
  else if Pagina.ActivePage = TabReiniciar then
    ExibirAjuda('opcoesconfigorig')
  else
    ExibirAjuda();
end;

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
  if ExibirPergunta('Você deseja restaurar as configurações para a configuração de fábrica?', ['Sim, restaurar.', 'Não, não restaurar.'], 1) = 0 then
  begin
    RadioExibirPDF.Checked := true;
    EditCaminhoPDF24.Text := Variaveis.PastaArqProgx86 + 'PDF24\pdf24-Creator.exe';
    EditArgsPDF24.Text := '%s';
    ChecExcluirSequenciaCarac.Checked := false;
    EditSequenciaExclusao.Enabled := false;
    EditSequenciaExclusao.Text := '';
    checUsarPDFParam.Checked := false;
    NomeFonte := 'CascadiaMono.ttf';
    TextoConfigRestauradas.Show;
  end;
end;

function TJanelaPadrao.CarregarRecursos: Boolean;
const
  ICO_PARAM = 1001;
  ICO_PDF = 1002;
  ICO_CARACTERE = 1003;
  ICO_PDF24 = 1004;
  ICO_RESTAURAR = 1005;
  ICO_LOGO = 1006;
var
  Icone: TIcon;
begin
  Icone := TIcon.Create;
  try
    Icone.LoadFromResourceID(HInstance, ICO_PDF);
    ImagemRelatorio.Picture.Icon.Assign(Icone);
    Icone.LoadFromResourceID(HInstance, ICO_PDF24);
    ImagemPDF24.Picture.Icon.Assign(Icone);
    Icone.LoadFromResourceID(HInstance, ICO_CARACTERE);
    ImagemCaracteres.Picture.Icon.Assign(Icone);
    Icone.LoadFromResourceID(HInstance, ICO_PARAM);
    ImagemParam.Picture.Icon.Assign(Icone);
    Icone.LoadFromResourceID(HInstance, ICO_RESTAURAR);
    ImagemRestaura.Picture.Icon.Assign(Icone);
    Icone.LoadFromResourceID(HInstance, ICO_LOGO);
    ImagemLogo.Picture.Icon.Assign(Icone);
  finally
    Icone.Free;
  end;
  Result := true;
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
  CarregarRecursos;
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
  NomeFonte := ArquivoINI.NomeFonte;
end;

procedure TJanelaPadrao.FormCreate(Sender: TObject);
begin
  Variaveis := TVariaveis.Create;
  ArquivoINI := TArquivoINI.Create;
  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'prisma.chm';
end;

procedure TJanelaPadrao.FormDestroy(Sender: TObject);
begin
  FecharAjuda;
  if Assigned(ArquivoINI) then
  begin
    ArquivoINI.PosicaoY := Top;
    ArquivoINI.PosicaoX := Left;
    ArquivoINI.Salvar;
    ArquivoINI.Free;
  end;
  if Assigned(Variaveis) then
    Variaveis.Free;
end;

procedure TJanelaPadrao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    Ajuda;
end;

procedure TJanelaPadrao.FormShow(Sender: TObject);
var
  PosX, PosY: Integer;
begin
  try
    PosX := ArquivoINI.PosicaoX;
    PosY := ArquivoINI.PosicaoY;
    if (PosX > -1) and (PosY > -1) then
    begin
      Left := PosX;
      Top := PosY;
      Position := poDesigned;
    end
    else
      Position := poScreenCenter;
  except
    on E: Exception do
    begin
      ExibirMensagemErro(E.Message, E.HelpContext);
      Variaveis.Free;
      ArquivoINI.Free;
      Halt(1);
    end;
  end;
end;

procedure TJanelaPadrao.Label12Click(Sender: TObject);
begin
  OpenDocument('http://www.github.com/douglasralmeida/lepdf');
end;

procedure TJanelaPadrao.PaginaChange(Sender: TObject);
begin
  if Pagina.ActivePage = tabReiniciar then
    TextoConfigRestauradas.Hide;
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
  ArquivoINI.NomeFonte := NomeFonte;
  ArquivoINI.Salvar;
end;

procedure TJanelaPadrao.WMSysCommand(var Message: TWMSysCommand);
begin
  if Message.CmdType = SC_CONTEXTHELP then
  begin
    Ajuda;
    Message.Result := 0;
  end else
  begin
    inherited;
  end;
end;

end.

