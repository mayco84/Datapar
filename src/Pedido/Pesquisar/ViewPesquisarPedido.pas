unit ViewPesquisarPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, ViewPedidos,IViewPesquisarPedido,ControllerPesquisarPedido;

type
  TfrmPesquisarPedido = class(TForm, IPesquisarPedido)  // Implementa a interface
    Panel1: TPanel;
    btnNovo: TSpeedButton;
    btnEditar: TSpeedButton;
    btnPesquisar: TSpeedButton;
    edtPesquisar: TEdit;
    dbgPedido: TDBGrid;
    dtsPedido: TDataSource;
    rgpOpcoes: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure dbgPedidoDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FController: TPedidoController;  // Refer�ncia para a Controller
    procedure AtualizarGrid(ADataSet: TDataSet);  // Implementa��o do m�todo da interface
  public
    { Public declarations }
  end;

var
  frmPesquisarPedido: TfrmPesquisarPedido;

implementation

{$R *.dfm}

procedure TfrmPesquisarPedido.FormCreate(Sender: TObject);
begin
  FController := TPedidoController.Create(Self);  // Passa a refer�ncia da View (como interface) para a Controller
end;

procedure TfrmPesquisarPedido.FormDestroy(Sender: TObject);
begin
  FController.Free;  // Libera a mem�ria da Controller
end;

procedure TfrmPesquisarPedido.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      close;
  end;
end;

procedure TfrmPesquisarPedido.btnNovoClick(Sender: TObject);
var
  lTela : TfrmPedido;
begin
  lTela := TfrmPedido.Create(nil);
  try
    lTela.ShowModal;
  finally
    FreeAndNil(lTela)
  end;
end;

procedure TfrmPesquisarPedido.btnPesquisarClick(Sender: TObject);
var
  Filtro: string;
  PorCodigo, PorNome: Boolean;
begin
  Filtro := edtPesquisar.Text;
  PorCodigo := False;
  PorNome := False;

  case rgpOpcoes.ItemIndex of
    0: PorCodigo := True;
    1: PorNome := True;
  end;

  // Chama a Controller para buscar os dados
  FController.Pesquisar(Filtro, PorCodigo, PorNome);
end;

procedure TfrmPesquisarPedido.dbgPedidoDblClick(Sender: TObject);
var
  ID: Integer;
  lTela: TfrmPedido;
begin
  if Not Assigned(dtsPedido.DataSet) then
    Exit;

  // Certifica-se de que h� um registro selecionado
  if not dtsPedido.DataSet.IsEmpty then
  begin
    if dtsPedido.DataSet.FieldByName('id').AsInteger <=0 then
    begin
      MessageDlg('� necess�rio selecionar um item para editar.',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      Exit;
    end;

    ID := dtsPedido.DataSet.FieldByName('id').AsInteger;

    // Cria o formul�rio de cliente e carrega os dados
    lTela := TfrmPedido.Create(nil);
    try
      lTela.pnlDados.Enabled := True;
      // Passa o ID do cliente para o formul�rio
      lTela.CarregarPorID(ID); // Carrega os dados com o ID do cliente

      lTela.ShowModal; // Exibe o formul�rio modal
    finally
      lTela.Free;  // Libera o formul�rio ap�s o uso
    end;
  end;
end;

procedure TfrmPesquisarPedido.AtualizarGrid(ADataSet: TDataSet);
begin


// Atualiza o DataSource com o novo dataset
  if Assigned(ADataSet) then
    begin
      // Atualiza o DataSource com o novo dataset
      dtsPedido.DataSet := ADataSet;

      // Configura a DBGrid com os dados e a largura das colunas
      // (Ajuste os valores de Width conforme a necessidade do seu layout)
      dbgPedido.Columns[0].FieldName := 'id';
      dbgPedido.Columns[0].Title.Caption := 'ID';
      dbgPedido.Columns[0].Width := 50;

      dbgPedido.Columns[1].FieldName := 'descricao'; // Nome exato do campo no banco
      dbgPedido.Columns[1].Title.Caption := 'Descri��o do Produto';
      dbgPedido.Columns[1].Width := 250; // Exemplo de largura



      // Opcional: For�a a atualiza��o visual da DBGrid, �til se o conte�do muda dinamicamente
      dbgPedido.Refresh;
    end
    else
    begin
      // Se ADataSet for nil (nenhum dado retornado ou erro na Model), esvazia a grid
      dtsPedido.DataSet := nil;

      // Informa o usu�rio que nenhum resultado foi encontrado
      ShowMessage('Nenhum Pedido foi  encontrada com os crit�rios de pesquisa.');


    end;


end;

end.

