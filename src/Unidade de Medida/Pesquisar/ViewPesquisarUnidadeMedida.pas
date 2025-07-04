unit ViewPesquisarUnidadeMedida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, ViewUnidadeMedida,IViewPesquisarUnidadeMedida,ControllerPesquisarUnidadeMedida;

type
  TfrmPesquisarUnidadeMedida = class(TForm, IPesquisarUnidadeMedida)  // Implementa a interface
    Panel1: TPanel;
    btnNovo: TSpeedButton;
    btnEditar: TSpeedButton;
    btnPesquisar: TSpeedButton;
    edtPesquisar: TEdit;
    dbgUnidadeMedida: TDBGrid;
    dtsUnidadeMedida: TDataSource;
    rgpOpcoes: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure dbgUnidadeMedidaDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FController: TUnidadeMedidaController;  // Referência para a Controller
    procedure AtualizarGrid(ADataSet: TDataSet);  // Implementação do método da interface
  public
    { Public declarations }
  end;

var
  frmPesquisarUnidadeMedida: TfrmPesquisarUnidadeMedida;

implementation

{$R *.dfm}

procedure TfrmPesquisarUnidadeMedida.FormCreate(Sender: TObject);
begin
  FController := TUnidadeMedidaController.Create(Self);  // Passa a referência da View (como interface) para a Controller
end;

procedure TfrmPesquisarUnidadeMedida.FormDestroy(Sender: TObject);
begin
  FController.Free;  // Libera a memória da Controller
end;

procedure TfrmPesquisarUnidadeMedida.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      close;
  end;
end;

procedure TfrmPesquisarUnidadeMedida.btnNovoClick(Sender: TObject);
var
  lTelaCliente : TfrmUnidadeMedida;
begin
  lTelaCliente := TfrmUnidadeMedida.Create(nil);
  try
    lTelaCliente.ShowModal;
  finally
    FreeAndNil(lTelaCliente)
  end;
end;

procedure TfrmPesquisarUnidadeMedida.btnPesquisarClick(Sender: TObject);
var
  Filtro: string;
  PorCodigo, PorNome,PorSigla: Boolean;
begin
  Filtro := edtPesquisar.Text;
  PorCodigo := False;
  PorNome := False;
  PorSigla := False;

  case rgpOpcoes.ItemIndex of
    0: PorCodigo := True;
    1: PorNome := True;
    2: PorSigla := True;
  end;

  // Chama a Controller para buscar os dados
  FController.Pesquisar(Filtro, PorCodigo, PorNome,PorSigla);
end;

procedure TfrmPesquisarUnidadeMedida.dbgUnidadeMedidaDblClick(Sender: TObject);
var
  ClienteID: Integer;
  frmCliente: TfrmUnidadeMedida;
begin
  if Not Assigned(dtsUnidadeMedida.DataSet) then
    Exit;

  // Certifica-se de que há um registro selecionado
  if not dtsUnidadeMedida.DataSet.IsEmpty then
  begin
    if dtsUnidadeMedida.DataSet.FieldByName('id').AsInteger <=0 then
    begin
      MessageDlg('É necessário selecionar um item para editar.',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      Exit;
    end;

    ClienteID := dtsUnidadeMedida.DataSet.FieldByName('id').AsInteger;

    // Cria o formulário de cliente e carrega os dados
    frmCliente := TfrmUnidadeMedida.Create(nil);
    try
      frmCliente.pnlDados.Enabled := True;
      // Passa o ID do cliente para o formulário
      frmCliente.CarregarPorID(ClienteID); // Carrega os dados com o ID do cliente

      frmCliente.ShowModal; // Exibe o formulário modal
    finally
      frmCliente.Free;  // Libera o formulário após o uso
    end;
  end;
end;

procedure TfrmPesquisarUnidadeMedida.AtualizarGrid(ADataSet: TDataSet);
begin
  // Atualiza o DataSource com o novo dataset
  if Assigned(ADataSet) then
    begin
      // Atualiza o DataSource com o novo dataset
      dtsUnidadeMedida.DataSet := ADataSet;

      // Configura a DBGrid com os dados e a largura das colunas
      // (Ajuste os valores de Width conforme a necessidade do seu layout)
      dbgUnidadeMedida.Columns[0].FieldName := 'id';
      dbgUnidadeMedida.Columns[0].Title.Caption := 'ID';
      dbgUnidadeMedida.Columns[0].Width := 50;

      dbgUnidadeMedida.Columns[1].FieldName := 'descricaounidademedida'; // Nome exato do campo no banco
      dbgUnidadeMedida.Columns[1].Title.Caption := 'Descrição';
      dbgUnidadeMedida.Columns[1].Width := 250; // Exemplo de largura

      dbgUnidadeMedida.Columns[2].FieldName := 'siglaunidademedida'; // Nome exato do campo no banco
      dbgUnidadeMedida.Columns[2].Title.Caption := 'Sigla';
      dbgUnidadeMedida.Columns[2].Width := 80;

      // Opcional: Força a atualização visual da DBGrid, útil se o conteúdo muda dinamicamente
      dbgUnidadeMedida.Refresh;
    end
    else
    begin
      // Se ADataSet for nil (nenhum dado retornado ou erro na Model), esvazia a grid
      dtsUnidadeMedida.DataSet := nil;

      // Informa o usuário que nenhum resultado foi encontrado
      ShowMessage('Nenhuma unidade de medida encontrada com os critérios de pesquisa.');


    end;
end;


end.

