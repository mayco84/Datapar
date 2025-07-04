unit ViewPesquisarCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, ControllerPesquisarCliente, IViewPesquisarCliente, ViewCliente;

type
  TModoTelaCliente = (mcConsultaC, mcSelecaoC);

  TfrmPesquisarClientes = class(TForm, IViewPesquisarClientes)  // Implementa a interface
    Panel1: TPanel;
    btnNovo: TSpeedButton;
    btnEditar: TSpeedButton;
    btnPesquisar: TSpeedButton;
    edtPesquisar: TEdit;
    dbgClientes: TDBGrid;
    dtsCliente: TDataSource;
    rgpOpcoes: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure dbgClientesDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FController: TClienteController;  // Refer�ncia para a Controller
    procedure AtualizarGrid(ADataSet: TDataSet);  // Implementa��o do m�todo da interface
  public
    ModoTela : TmodoTelaCliente;
    FClienteID: Integer;
    { Public declarations }
  end;

var
  frmPesquisarClientes: TfrmPesquisarClientes;

implementation

{$R *.dfm}

procedure TfrmPesquisarClientes.FormCreate(Sender: TObject);
begin
  FController := TClienteController.Create(Self);  // Passa a refer�ncia da View (como interface) para a Controller
end;

procedure TfrmPesquisarClientes.FormDestroy(Sender: TObject);
begin
  FController.Free;  // Libera a mem�ria da Controller
end;

procedure TfrmPesquisarClientes.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      close;
  end;
end;

procedure TfrmPesquisarClientes.btnNovoClick(Sender: TObject);
var
  lTelaCliente : TfrmCliente;
begin
  lTelaCliente := TfrmCliente.Create(nil);
  try
    lTelaCliente.ShowModal;
  finally
    FreeAndNil(lTelaCliente)
  end;
end;

procedure TfrmPesquisarClientes.btnPesquisarClick(Sender: TObject);
var
  Filtro: string;
  PorCodigo, PorNome,EMail: Boolean;
begin
  Filtro := edtPesquisar.Text;
  PorCodigo := False;
  PorNome := False;
  Email := False;

  case rgpOpcoes.ItemIndex of
    0: PorCodigo := True;
    1: PorNome := True;
    2: Email := True;
  end;

  // Chama a Controller para buscar os dados
  FController.PesquisarClientes(Filtro, PorCodigo, PorNome,EMail);
end;

procedure TfrmPesquisarClientes.dbgClientesDblClick(Sender: TObject);
var
  frmCliente: TfrmCliente;
begin
  if Not Assigned(dtsCliente.DataSet) then
    Exit;

  // Certifica-se de que h� um registro selecionado
  if not dtsCliente.DataSet.IsEmpty then
  begin
    if dtsCliente.DataSet.FieldByName('id').AsInteger <=0 then
    begin
      MessageDlg('� necess�rio selecionar um item para editar.',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      Exit;
    end;

    FClienteID := dtsCliente.DataSet.FieldByName('id').AsInteger;

    case ModoTela of
        mcConsultaC:
          begin
            frmCliente := TfrmCliente.Create(nil);
            try
              frmCliente.pnlDados.Enabled := True;
              frmCliente.CarregarClientePorID(FClienteID);
              frmCliente.ShowModal;
            finally
              frmCliente.Free;
            end;
          end;

        mcSelecaoC:
          begin

            ModalResult := mrOk; // Encerra o form e permite retornar o valor
          end;
      end;

  end;

end;


procedure TfrmPesquisarClientes.AtualizarGrid(ADataSet: TDataSet);
begin
  // SEMPRE verifique se ADataSet � v�lido antes de us�-lo.
  if Assigned(ADataSet) then
  begin
    dtsCliente.DataSet := ADataSet;

    // Se ADataSet � v�lido, agora podemos configurar as colunas
dbgClientes.Columns[0].FieldName := 'id';
    dbgClientes.Columns[0].Title.Caption := 'ID'; // Adicionei um Caption para o ID, se quiser
    dbgClientes.Columns[0].Width := 50;

    dbgClientes.Columns[1].FieldName := 'NomeCompleto';
    dbgClientes.Columns[1].Title.Caption := 'Nome Completo';
    dbgClientes.Columns[1].Width := 200;

    dbgClientes.Columns[2].FieldName := 'CPF';
    dbgClientes.Columns[2].Title.Caption := 'CPF'; // Adicionei Caption
    dbgClientes.Columns[2].Width := 100;

    dbgClientes.Columns[3].FieldName := 'Telefone';
    dbgClientes.Columns[3].Title.Caption := 'Telefone'; // Adicionei Caption
    dbgClientes.Columns[3].Width := 100;

    dbgClientes.Columns[4].FieldName := 'Email';
    dbgClientes.Columns[4].Title.Caption := 'E-mail';
    dbgClientes.Columns[4].Width := 250;

    // Opcional: Recarregar a visualiza��o da DBGrid
    dbgClientes.Refresh;
  end
  else
  begin
    // Se ADataSet � nil, desvincule o DataSource da grid
    dtsCliente.DataSet := nil; // Isso vai esvaziar a grid.

    // Opcional: Mostrar uma mensagem ao usu�rio que n�o h� dados.
    ShowMessage('Nenhum cliente encontrado com os crit�rios de pesquisa.');


  end;
end;


end.

