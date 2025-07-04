unit ViewPesquisarProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, ViewProdutos,IViewPesquisarProdutos,ControllerPesquisarProdutos;

type

  TModoTelaProdutos = (mcConsulta, mcSelecao);
  TfrmPesquisarProdutos = class(TForm, IPesquisarProdutos)  // Implementa a interface
    Panel1: TPanel;
    btnNovo: TSpeedButton;
    btnEditar: TSpeedButton;
    btnPesquisar: TSpeedButton;
    edtPesquisar: TEdit;
    dbgProdutos: TDBGrid;
    dtsProdutos: TDataSource;
    rgpOpcoes: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure dbgProdutosDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FController: TProdutosController;  // Referência para a Controller
    procedure AtualizarGrid(ADataSet: TDataSet);  // Implementação do método da interface
  public
    ModoTela : TmodoTelaProdutos;
    FProdutosID: Integer;
  end;

var
  frmPesquisarProdutos: TfrmPesquisarProdutos;

implementation

{$R *.dfm}

procedure TfrmPesquisarProdutos.FormCreate(Sender: TObject);
begin
  FController := TProdutosController.Create(Self);  // Passa a referência da View (como interface) para a Controller
end;

procedure TfrmPesquisarProdutos.FormDestroy(Sender: TObject);
begin
  FController.Free;  // Libera a memória da Controller
end;

procedure TfrmPesquisarProdutos.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      close;
  end;
end;

procedure TfrmPesquisarProdutos.btnNovoClick(Sender: TObject);
var
  lTela : TfrmProdutos;
begin
  lTela := TfrmProdutos.Create(nil);
  try
    lTela.ShowModal;
  finally
    FreeAndNil(lTela)
  end;
end;

procedure TfrmPesquisarProdutos.btnPesquisarClick(Sender: TObject);
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

procedure TfrmPesquisarProdutos.dbgProdutosDblClick(Sender: TObject);
var
  lTela: TfrmProdutos;
begin
  if Not Assigned(dtsProdutos.DataSet) then
    Exit;

  // Certifica-se de que há um registro selecionado
  if not dtsProdutos.DataSet.IsEmpty then
  begin
    if dtsProdutos.DataSet.FieldByName('id').AsInteger <=0 then
    begin
      MessageDlg('É necessário selecionar um item para editar.',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      Exit;
    end;

    FProdutosID := dtsProdutos.DataSet.FieldByName('id').AsInteger;

    case ModoTela of
      mcConsulta:
        begin
           lTela := TfrmProdutos.Create(nil);
          try
            lTela.pnlDados.Enabled := True;
            lTela.CarregarPorID(FProdutosID);
            lTela.ShowModal;
          finally
            lTela.Free;
          end;
        end;

      mcSelecao:
        begin
          ModalResult := mrOk; // Encerra o form e permite retornar o valor
        end;
    end;

  end;


end;

procedure TfrmPesquisarProdutos.AtualizarGrid(ADataSet: TDataSet);
begin

  // Atualiza o DataSource com o novo dataset
  if Assigned(ADataSet) then
    begin
      // Atualiza o DataSource com o novo dataset
      dtsProdutos.DataSet := ADataSet;

      // Configura a DBGrid com os dados e a largura das colunas
      // (Ajuste os valores de Width conforme a necessidade do seu layout)
      dbgProdutos.Columns[0].FieldName := 'id';
      dbgProdutos.Columns[0].Title.Caption := 'ID';
      dbgProdutos.Columns[0].Width := 50;

      dbgProdutos.Columns[1].FieldName := 'descricao'; // Nome exato do campo no banco
      dbgProdutos.Columns[1].Title.Caption := 'Descrição do Produto';
      dbgProdutos.Columns[1].Width := 250; // Exemplo de largura



      // Opcional: Força a atualização visual da DBGrid, útil se o conteúdo muda dinamicamente
      dbgProdutos.Refresh;
    end
    else
    begin
      // Se ADataSet for nil (nenhum dado retornado ou erro na Model), esvazia a grid
      dtsProdutos.DataSet := nil;

      // Informa o usuário que nenhum resultado foi encontrado
      ShowMessage('Nenhum Produto foi encontrado com os critérios de pesquisa.');


    end;






end;

end.

