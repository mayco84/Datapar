unit ViewProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,Vcl.CheckLst,
  System.Classes, Vcl.Graphics, ViewPesquisarUnidadeMedida,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  System.UITypes,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, System.JSON,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, uDM, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask, ControllerProdutos,
  ModelProdutos;

type
  TfrmProdutos = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    shCadastrar: TShape;
    shCadastrarBranco: TShape;
    Image2: TImage;
    btCadastrar: TSpeedButton;
    shAlterar: TShape;
    shAlterarBranco: TShape;
    Image3: TImage;
    btAlterar: TSpeedButton;
    shExcluir: TShape;
    shExcluirBranco: TShape;
    Image5: TImage;
    btExcluir: TSpeedButton;
    shCancelar: TShape;
    shCancelarBranco: TShape;
    Image8: TImage;
    btCancelar: TSpeedButton;
    shGravar: TShape;
    shGravarBranco: TShape;
    Image7: TImage;
    btGravar: TSpeedButton;
    shSair: TShape;
    shSairBranco: TShape;
    Image4: TImage;
    btSair: TSpeedButton;
    pnlDados: TPanel;
    edtCodigo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    label99: TLabel;
    edtDescricao: TEdit;
    edtDataCadastro: TEdit;
    edtValor: TEdit;
    gbUnidades: TGroupBox;
    Label15: TLabel;
    btAbrirUnidades: TSpeedButton;
    clbUnidades: TCheckListBox;
    procedure btGravarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btCadastrarClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure clbUnidadesClickCheck(Sender: TObject);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btAbrirUnidadesClick(Sender: TObject);
  private
    FController: TControllerProdutos; // Controller privado
    FModel: TProdutosModel;
    FAcao: integer;
    procedure CarregaCombo;
    procedure CarregaUnidadeMedida;
    function RetornaProdutos(pID: integer): string;
    function GetUnidadeMedida(ListBox: TCheckListBox): Integer;
    /// 1 atualiza , 2 grava
  public
    destructor Destroy; override;
    procedure CarregarPorID(ID: integer);
    // Novo método público para carregar a unidade medida
    procedure Inicializar; // Método para inicializar a tela, se necessário
    function GetController: TControllerProdutos;
    constructor Create(AOwner: TComponent);
    // Novo método para acessar o Controller

  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.dfm}

procedure TfrmProdutos.Inicializar;
begin
  FController := TControllerProdutos.Create();
end;

procedure TfrmProdutos.CarregarPorID(ID: integer);
begin
  FModel := FController.CarregarPorID(ID);
  // Chama o método no Controller para carregar os dados

  // preenche os campos do formulário com os dados do cliente
  edtCodigo.Text := IntToStr(FModel.ID);
  edtDataCadastro.Text := DateToStr(FModel.DataCadastro);
  edtDescricao.Text := FModel.Descricao;
  edtValor.Text := FormatFloat('#,##0.00',FModel.Valor);
end;

constructor TfrmProdutos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner); // Chama o construtor da classe base
  FModel := TProdutosModel.Create;
  FController := TControllerProdutos.Create;
end;

destructor TfrmProdutos.Destroy;
begin
  FModel.Free;
  inherited;
end;

procedure TfrmProdutos.edtValorExit(Sender: TObject);
var
  Valor: Double;
begin
  if Trim(edtValor.Text) = '' then
    Exit;

  // Tenta converter o texto para um valor numérico
  if TryStrToFloat(StringReplace(edtValor.Text, ',', '.', [rfReplaceAll]), Valor) then
    edtValor.Text := FormatFloat('#,##0.00', Valor)
  else
  begin
    ShowMessage('Valor inválido. Por favor, insira um valor numérico.');
    edtValor.SetFocus;
  end;
end;

procedure TfrmProdutos.edtValorKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', ',', '.', #8]) then
  begin
    Key := #0; // Ignora qualquer outra tecla
    Exit;
  end;

  // Substitui ponto por vírgula (caso o usuário insira um ponto para centavos)
  if Key = '.' then
    Key := ',';
end;

procedure TfrmProdutos.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      close;
  end;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
begin
  CarregaCombo;
  CarregaUnidadeMedida;
end;

procedure TfrmProdutos.btGravarClick(Sender: TObject);
var
  NovoID: integer;
begin
  // Valida os campos antes de salvar
  FController.ValidarCampos(edtDataCadastro, edtDescricao, edtValor,clbUnidades);

  try
    // O ID já foi carregado anteriormente (não precisa ser definido manualmente aqui)
    FModel.Descricao := edtDescricao.Text;
    FModel.DataCadastro := StrToDate(edtDataCadastro.Text);
    FModel.Valor := StrToFloat(edtValor.Text);
    FModel.IDUnidadeMedida :=  GetUnidadeMedida(clbUnidades);

    case FAcao of
      1: // Ação de Atualizar
        begin
          if FModel.Atualizar then
            begin
              btGravar.Enabled := false;
              btAlterar.Enabled := false;
              btExcluir.Enabled := false;
              MessageDlg('Registro Atualizado com Sucesso!', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0)
            end
          else
            MessageDlg('Erro ao atualizar !', TMsgDlgType.mtError,[TMsgDlgBtn.mbOK], 0);
        end;

      2: // Ação de Gravar (Salvar)
        begin
          if FModel.Salvar(NovoID) then
          begin
            edtCodigo.Text := IntToStr(NovoID);
            FController.LimparComponentes(Self);
            btGravar.Enabled := false;
            btAlterar.Enabled := false;
            btExcluir.Enabled := false;
            MessageDlg('Registro Salvo com Sucesso!',
              TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0)
          end
          else
            MessageDlg('Erro ao salvar !', TMsgDlgType.mtError,
              [TMsgDlgBtn.mbOK], 0);
        end;
    end;

  finally
    btCadastrar.Enabled := true;
    pnlDados.Enabled := False;
  end;
end;

procedure TfrmProdutos.btSairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmProdutos.btAbrirUnidadesClick(Sender: TObject);
var
  lTelaUnidade : TfrmPesquisarUnidadeMedida;
begin
  lTelaUnidade := TfrmPesquisarUnidadeMedida.Create(nil);
  try
    lTelaUnidade.ShowModal;
    CarregaCombo;
    CarregaUnidadeMedida;
  finally
    FreeAndNil(lTelaUnidade)
  end;

end;

procedure TfrmProdutos.btAlterarClick(Sender: TObject);
begin
  btCadastrar.Enabled := False;
  btAlterar.Enabled := False;
  btExcluir.Enabled := False;
  btGravar.Enabled := True;
  pnlDados.Enabled := True;
  FAcao := 1;
  edtDataCadastro.SetFocus
end;

procedure TfrmProdutos.btCadastrarClick(Sender: TObject);
begin
  btCadastrar.Enabled := False;
  btAlterar.Enabled := False;
  btExcluir.Enabled := False;
  pnlDados.Enabled := True;
  if FAcao <> 0 then
    FController.LimparComponentes(Self);
  FAcao := 2;
  edtDataCadastro.Text := DateToStr(Date);
end;

procedure TfrmProdutos.btCancelarClick(Sender: TObject);
begin
  btCadastrar.Enabled := True;
  btAlterar.Enabled := True;
  btExcluir.Enabled := True;
  pnlDados.Enabled := False;
end;

function TfrmProdutos.GetController: TControllerProdutos;
begin
  Result := FController;
end;

procedure TfrmProdutos.btExcluirClick(Sender: TObject);
begin
  if edtCodigo.Text = '' then
    Exit;

  if MessageDlg('Tem certeza de que deseja excluir este registro?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  pnlDados.Enabled := True;

  try
    FModel.ID := StrToInt(edtCodigo.Text); // Carrega o ID para exclusão

    if FModel.Deletar then
    begin
      FController.LimparComponentes(Self);
      ShowMessage('Registro excluído com sucesso!');
    end
    else
      ShowMessage('Erro ao excluir Registro.');
  finally
    clbUnidades.Items.clear;
    pnlDados.Enabled := False;
  end;
end;

procedure TfrmProdutos.CarregaCombo;
var
  qUnidadeMedida: TFDQuery;
begin
  qUnidadeMedida := TFDQuery.Create(nil);
  Try
    qUnidadeMedida.Connection := DM.Conexao;

    with qUnidadeMedida.sql do
    begin
      clear;
      add(' select id,  DescricaoUnidadeMedida,SiglaUnidadeMedida,(id||'' - ''||DescricaoUnidadeMedida||'' - ''||SiglaUnidadeMedida)as descricao from UnidadeMedida ');
      add(' order by SiglaUnidadeMedida');
    end;
    qUnidadeMedida.open;
    qUnidadeMedida.First;

    clbUnidades.Items.clear;
    while not qUnidadeMedida.eof do
    begin
      clbUnidades.Items.add(qUnidadeMedida.FieldByName('descricao').AsString);
      qUnidadeMedida.next;
    end;
  Finally
    FreeAndNil(qUnidadeMedida);
  End;

end;


procedure TfrmProdutos.CarregaUnidadeMedida;
var
  i, n,id: integer;
  lLista: TStringList;
begin

  if edtCodigo.Text = '' then
    id := 0
  else
  id := StrToInt(edtCodigo.Text);

  lLista := TStringList.Create;
  try

    lLista.Delimiter := ',';
    lLista.StrictDelimiter := True;

    try
      for n := 0 to clbUnidades.Count - 1 do
      begin
        clbUnidades.Checked[n] := False;
      end;


      lLista.DelimitedText := RetornaProdutos(id);

      for i := 0 to lLista.Count - 1 do
      begin
        for n := 0 to clbUnidades.Count - 1 do
        begin
          if trim(Copy(clbUnidades.Items.Strings[n], 1, 2)) = lLista.Strings[i] then
            clbUnidades.Checked[n] := True;
        end;
      end;

    except
      on e: Exception do
      begin
        raise Exception.Create('Erro: ' + e.Message);
      end;
    end;

  finally
    FreeAndNil(lLista)
  end;

end;


procedure TfrmProdutos.clbUnidadesClickCheck(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to clbUnidades.Items.Count - 1 do
  begin
    // Desmarca as outras opções, exceto a que foi clicada
    if i <> clbUnidades.ItemIndex then
      clbUnidades.Checked[i] := False;
  end
end;

function TfrmProdutos.RetornaProdutos(pID:integer): string;
var
  qMenu: TFDQuery;
begin
  result:='';
  qmenu := TFDQuery.Create(nil);
  qmenu.Connection:= DM.Conexao;
  qmenu.close;

  try
    with qmenu.SQL do
    begin
      clear;
      add('select idunidademedida from produtos');
      add('where  id = :id');
    end;
    qmenu.Params.ParamByName('id').Asinteger := pID;
    qmenu.Open();

    if qMenu.IsEmpty then
     exit;

     result:=Trim(qmenu.fields.FieldByName('idunidademedida').AsString);

  finally
    FreeAndNil(qmenu);
  end;
end;

function TfrmProdutos.GetUnidadeMedida(ListBox: TCheckListBox): Integer;
var
  i: Integer;
  ItemTexto: String;
begin
  Result := -1; // Valor padrão para indicar que nada foi selecionado

  for i := 0 to ListBox.Items.Count - 1 do
  begin
    if ListBox.Checked[i] then
    begin
      // Obtém o texto completo do item selecionado
      ItemTexto := ListBox.Items[i];

      // Extrai o ID antes do primeiro "-"
      Result := StrToIntDef(Trim(Copy(ItemTexto, 1, Pos(' - ', ItemTexto) - 1)), -1);

      // Sai do loop após encontrar o primeiro item selecionado
      Exit;
    end;
  end;

  // Caso nenhum item tenha sido selecionado
  if Result = -1 then
    raise Exception.Create('Nenhuma unidade de medida selecionada.');
end;




end.
