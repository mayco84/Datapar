unit ViewPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.pngimage,DBClient,
  FireDAC.Comp.Client, FireDAC.DApt,Vcl.ExtCtrls, Vcl.Grids, Data.DB,ControllerPedido,ModelPedido,
  uDM,ModelProdutos,ModelCliente,ViewPesquisarCliente,ViewPesquisarProdutos  ;

type
  TfrmPedido = class(TForm)
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
    shExcluirBranco: TShape;
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
    Label1: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtDataCadastro: TEdit;
    gbCliente: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edtCodigoCliente: TEdit;
    lblNomeCliente: TLabel;
    gbProdutos: TGroupBox;
    Shape1: TShape;
    Label5: TLabel;
    Label6: TLabel;
    imgProdutos: TImage;
    Label7: TLabel;
    lblNomeProduto: TLabel;
    edtCodigoProduto: TEdit;
    edtQuantidade: TEdit;
    GridPedido: TStringGrid;
    btAbrirClientes: TSpeedButton;
    btProdutos: TSpeedButton;
    procedure btSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btCadastrarClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btGravarClick(Sender: TObject);
    procedure imgProdutosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btAbrirClientesClick(Sender: TObject);
    procedure btProdutosClick(Sender: TObject);
  private
    { Private declarations }
    FIdUnidadeMedida,
    FNovoID: integer;
    FController: TPedidoController;
    FModel: TPedidoModel;
    function ColetarDadosItens: TArray<TFDQuery>;
    procedure LimparCampos;
  public
    { Public declarations }
    procedure CarregarPorID(ID: integer);
  end;

var
  frmPedido: TfrmPedido;

implementation

{$R *.dfm}



procedure TfrmPedido.btAbrirClientesClick(Sender: TObject);
var
  lTelaClientes : TfrmPesquisarClientes;
begin
  lTelaClientes := TfrmPesquisarClientes.Create(nil);
  try
    lTelaClientes.ModoTela := mcSelecaoC;

    if lTelaClientes.ShowModal = mrOk then
      begin
        edtCodigoCliente.Text := IntToStr(lTelaClientes.FClienteID);
        edtCodigoClienteExit(edtCodigoCliente);
      end;
  finally
    FreeAndNil(lTelaClientes)
  end;

end;

procedure TfrmPedido.btCadastrarClick(Sender: TObject);
var
  PedidoModel: TPedidoModel;
begin
  LimparCampos;
  PedidoModel := TPedidoModel.Create;
  try
    // Gerar ID de pedido antes de gravar
    FNovoID := PedidoModel.GerarNovoIDPedido();  // Método que retorna o próximo ID disponível
    edtCodigo.Text := IntToStr(FNovoID);  // Exibe o ID no campo de texto

    FIdUnidadeMedida := 0;
    btCadastrar.Enabled := False;
    btAlterar.Enabled := False;
    pnlDados.Enabled := True;
    edtDataCadastro.Text := DateToStr(Date);
  finally
    PedidoModel.Free;
  end;
end;

procedure TfrmPedido.btCancelarClick(Sender: TObject);
begin
  LimparCampos;

  btCadastrar.Enabled := True;
  btAlterar.Enabled := True;

  pnlDados.Enabled := False;
end;

procedure TfrmPedido.btGravarClick(Sender: TObject);
var
  DataPedido: TDateTime;
  IdCliente: Integer;
  Quantidade,Total: Double;
  Itens: TArray<TFDQuery>;
begin
  try
    // Validação dos campos
    if not TryStrToDate(edtDataCadastro.Text, DataPedido) then
      raise Exception.Create('Data de cadastro inválida.');

    if edtCodigoCliente.Text = '' then
      raise Exception.Create('Informe o código do cliente.');

    IdCliente := StrToIntDef(edtCodigoCliente.Text, 0);
    if IdCliente = 0 then
      raise Exception.Create('Código do cliente inválido.');

    if GridPedido.RowCount <= 1 then
      raise Exception.Create('Adicione pelo menos um produto ao pedido.');

    Quantidade := StrToFloatDef(GridPedido.Cells[3, GridPedido.RowCount - 1], 0);
    Total := StrToFloatDef(GridPedido.Cells[4, GridPedido.RowCount - 1], 0);

    // Grava o pedido
    FController.GravarPedido(DataPedido, IdCliente, Quantidade,Total, Itens);


   // Coleta dos itens do pedido
    Itens := ColetarDadosItens;


    ShowMessage('Pedido gravado com sucesso!');
    btCancelarClick(Sender);
  except
    on E: Exception do
      ShowMessage('Erro ao gravar o pedido: ' + E.Message);
  end;
end;

procedure TfrmPedido.btProdutosClick(Sender: TObject);
var
  lTelaProdutos : TfrmPesquisarProdutos;
begin
  lTelaProdutos := TfrmPesquisarProdutos.Create(nil);
  try
    lTelaProdutos.ModoTela := mcSelecao;

    if lTelaProdutos.ShowModal = mrOk then
      begin
        edtCodigoProduto.Text := IntToStr(lTelaProdutos.FProdutosID);
        edtCodigoProdutoExit(edtCodigoProduto);
      end;
  finally
    FreeAndNil(lTelaProdutos)
  end;
end;

procedure TfrmPedido.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  GridPedido.ColCount := 5; // Total de colunas
  GridPedido.RowCount := 1; // Inicializar com uma linha de cabeçalho
  GridPedido.Cells[0, 0] := 'ID';              // Cabeçalho da coluna 1
  GridPedido.Cells[1, 0] := 'Cliente';       // Cabeçalho da coluna 2
  GridPedido.Cells[2, 0] := 'Valor';           // Cabeçalho da coluna 3
  GridPedido.Cells[3, 0] := 'Quantidade';      // Cabeçalho da coluna 4
  GridPedido.Cells[4, 0] := 'Unidade Medida';      // Cabeçalho da coluna 5

  FModel := TPedidoModel.Create;
  FController := TPedidoController.Create;
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FController);
  FreeAndNil(FModel);
end;

procedure TfrmPedido.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfrmPedido.imgProdutosClick(Sender: TObject);
var
  ProdutoModel: TProdutosModel;
  ProdutoID: Integer;
  Linha: Integer;
begin
  // Verifique se o ID do produto é válido
  ProdutoID := StrToIntDef(edtCodigoProduto.Text, 0); // Supondo que Edit1 contém o ID do produto
  if ProdutoID = 0 then
  begin
    ShowMessage('Informe um ID válido para o produto.');
    Exit;
  end;

  ProdutoModel := TProdutosModel.Create;
  try
    ProdutoModel := ProdutoModel.BuscarPorID(ProdutoID);

    if ProdutoModel = nil then
    begin
      ShowMessage('Produto não encontrado.');
      Exit;
    end;

    // Adiciona os dados na grid
    Linha := GridPedido.RowCount;
    GridPedido.RowCount := Linha + 1;

    GridPedido.Cells[0, Linha] := ProdutoModel.ID.ToString;                    // ID
    GridPedido.Cells[1, Linha] := ProdutoModel.Descricao;                      // Descrição
    GridPedido.Cells[2, Linha] := FormatFloat('0.00', ProdutoModel.Valor);     // Valor
    GridPedido.Cells[3, Linha] := edtQuantidade.Text;                          // Quantidade
    GridPedido.Cells[4, Linha] := ProdutoModel.UnidadeMedidaSigla;            // Sigla
    FIdUnidadeMedida :=  ProdutoModel.IDUnidadeMedida;  // IDUnidadeMedida

    ShowMessage('Produto adicionado com sucesso!');
  finally
    ProdutoModel.Free;
  end;
end;

procedure TfrmPedido.CarregarPorID(ID: integer);
var
 Linha: integer;
begin
  FModel := FController.CarregarPorID(ID);

  Linha := GridPedido.RowCount;
  GridPedido.RowCount := Linha + 1;

  GridPedido.Cells[0, Linha] := FModel.ID.ToString;                 // ID
  GridPedido.Cells[1, Linha] := FModel.Nome       ;                 // Descrição
  GridPedido.Cells[2, Linha] := FormatFloat('0.00', FModel.Total);  // Valor
  GridPedido.Cells[3, Linha] := FModel.Quantidade.ToString;         // Quantidade
  GridPedido.Cells[4, Linha] := FModel.Sigla;                       // Sigla

  edtCodigo.Text := FModel.ID.ToString;
  edtDataCadastro.Text := DateToStr( fmodel.DataPedido);
  edtCodigoCliente.Text := FModel.IdCliente.ToString;
  lblNomeCliente.Caption := FModel.Nome;

end;

function TfrmPedido.ColetarDadosItens: TArray<TFDQuery>;
var
  i: Integer;
  Query: TFDQuery;
  CDS: TClientDataSet;
begin
  // Cria e configura o ClientDataSet
  CDS := TClientDataSet.Create(nil);
  try
    CDS.FieldDefs.Add('idPedido', ftInteger);
    CDS.FieldDefs.Add('Quantidade', ftFloat);
    CDS.FieldDefs.Add('idUnidadeMedida', ftInteger);
    CDS.FieldDefs.Add('Valor', ftFloat);
    CDS.FieldDefs.Add('Total', ftFloat);
    CDS.CreateDataSet;


    // Preenche o CDS com os dados do grid
    for i := 1 to GridPedido.RowCount - 1 do
    begin
      CDS.Append;
      CDS.FieldByName('idPedido').AsInteger := StrToIntDef(edtCodigo.Text, 0);
      CDS.FieldByName('Quantidade').AsFloat := StrToFloatDef(GridPedido.Cells[3, i], 0);
      CDS.FieldByName('idUnidadeMedida').AsInteger := FIdUnidadeMedida;
      CDS.FieldByName('Valor').AsFloat := StrToFloatDef(GridPedido.Cells[2, i], 0);
      CDS.FieldByName('Total').AsFloat := StrToFloatDef(GridPedido.Cells[5, i], 0);
      CDS.Post;
    end;

    // Cria a query para inserir os dados no banco
    SetLength(Result, CDS.RecordCount);
    Query := TFDQuery.Create(nil);
    Query.Connection := DM.Conexao; // Define a conexão para a query

    // Agora percorre o CDS e faz o append para a query
    CDS.First;
    i := 0;
    while not CDS.Eof do
    begin
      Query.SQL.Text := 'INSERT INTO PedidoItens (idPedido, Quantidade, idUnidadeMedida, Valor, Total) ' +
                        'VALUES (:idPedido, :Quantidade, :idUnidadeMedida, :Valor, :Total)';
      Query.ParamByName('idPedido').AsInteger := CDS.FieldByName('idPedido').AsInteger;
      Query.ParamByName('Quantidade').AsFloat := CDS.FieldByName('Quantidade').AsFloat;
      Query.ParamByName('idUnidadeMedida').AsInteger := CDS.FieldByName('idUnidadeMedida').AsInteger;
      Query.ParamByName('Valor').AsFloat := CDS.FieldByName('Valor').AsFloat;
      Query.ParamByName('Total').AsFloat := CDS.FieldByName('Total').AsFloat;

      // Execute o insert e armazene a query no resultado
      Query.ExecSQL;

      i := i + 1;
      CDS.Next;
    end;

  finally
    CDS.Free; // Libera o CDS após o uso
    Query.Free; // Libera a query após o uso
  end;
end;


procedure TfrmPedido.edtCodigoClienteExit(Sender: TObject);
var
  ClienteModel: TClienteModel;
  ClienteID: Integer;
begin
  if Trim(edtCodigoCliente.Text) = '' then
  begin
    lblNomeCliente.Caption := '';
    Exit;
  end;

  try
    ClienteID := StrToInt(edtCodigoCliente.Text);
    ClienteModel := TClienteModel.Create;

    try
      ClienteModel := ClienteModel.BuscarPorID(ClienteID);

      if Assigned(ClienteModel) then
      begin
        lblNomeCliente.Caption := ClienteModel.NomeCompleto;
      end
      else
      begin
        lblNomeCliente.Caption := 'Cliente não encontrado.';
        edtCodigoCliente.SetFocus;
        raise Exception.Create('Nenhum cliente encontrado para o ID informado.');
      end;

    finally
      ClienteModel.Free; // Liberar o modelo
    end;
  except
    on E: Exception do
    begin
      lblNomeCliente.Caption := '';
      ShowMessage('Erro: ' + E.Message);
      edtCodigoCliente.SetFocus;
    end;
  end;
end;

procedure TfrmPedido.edtCodigoProdutoExit(Sender: TObject);
var
  ProdutoModel: TProdutosModel;
  ProdutoID: Integer;
begin
  if Trim(edtCodigoProduto.Text) = '' then
  begin
    lblNomeProduto.Caption := '';
    Exit;
  end;

  try
    ProdutoID := StrToInt(edtCodigoProduto.Text);
    ProdutoModel := TProdutosModel.Create;

    try
      ProdutoModel := ProdutoModel.BuscarPorID(ProdutoID);

      if Assigned(ProdutoModel) then
      begin
        lblNomeProduto.Caption := ProdutoModel.Descricao;
      end
      else
      begin
        lblNomeProduto.Caption := 'Produto não encontrado.';
        edtCodigoProduto.SetFocus;
        raise Exception.Create('Nenhum produto encontrado para o ID informado.');
      end;

    finally
      ProdutoModel.Free; // Liberar o modelo
    end;
  except
    on E: Exception do
    begin
      lblNomeProduto.Caption := '';
      ShowMessage('Erro: ' + E.Message);
      edtCodigoProduto.SetFocus;
    end;
  end;

end;

procedure TfrmPedido.LimparCampos;
begin
  edtCodigo.Text := '';
  edtDataCadastro.Text := '';
  edtCodigoCliente.Text := '';
  edtQuantidade.Text := '';
  edtCodigoProduto.Text := '';
  lblNomeCliente.Caption := '';
  lblNomeProduto.Caption := '';
  GridPedido.RowCount := 1;
end;



end.
