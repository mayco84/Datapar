unit ViewUnidadeMedida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,System.UITypes,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,System.JSON,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,uDM, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,ControllerUnidadeMedida,
  ModelUnidadeMedida;
type
  TfrmUnidadeMedida = class(TForm)
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
    lblRG: TLabel;
    edtDescricao: TEdit;
    edtDataCadastro: TEdit;
    edtSigla: TEdit;
    procedure btGravarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btCadastrarClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FController: TControllerUnidadeMedida;  // Controller privado
    FAcao: integer; /// 1 atualiza , 2 grava
    FUnidadeMedida: TUnidadeMedidaModel;
  public
    destructor Destroy; override;
    procedure CarregarPorID(UnidadeID: Integer);  // Novo método público para carregar a unidade medida
    procedure Inicializar;  // Método para inicializar a tela, se necessário
    function GetController: TControllerUnidadeMedida;
    constructor Create(AOwner: TComponent); // Novo método para acessar o Controller

  end;

var
  frmUnidadeMedida: TfrmUnidadeMedida;

implementation

{$R *.dfm}

procedure TfrmUnidadeMedida.Inicializar;
begin
  FController := TControllerUnidadeMedida.Create();
end;



procedure TfrmUnidadeMedida.CarregarPorID(UnidadeID: Integer);
begin
  FUnidadeMedida := FController.CarregarPorID(UnidadeID);  // Chama o método no Controller para carregar os dados

  // preenche os campos do formulário com os dados do cliente
  edtCodigo.Text := IntToStr(FUnidadeMedida.ID);
  edtDataCadastro.Text := DateToStr(FUnidadeMedida.DataCadastro);
  edtDescricao.Text := FUnidadeMedida.Descricao;
  edtSigla.Text := FUnidadeMedida.Sigla;
end;


constructor TfrmUnidadeMedida.Create(AOwner: TComponent);
begin
  inherited Create(AOwner); // Chama o construtor da classe base
  FUnidadeMedida := TUnidadeMedidaModel.Create;
  FController := TControllerUnidadeMedida.Create;
end;

destructor TfrmUnidadeMedida.Destroy;
begin
  FUnidadeMedida.Free;
  inherited;
end;



procedure TfrmUnidadeMedida.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      close;
  end;
end;

procedure TfrmUnidadeMedida.btGravarClick(Sender: TObject);
var
  NovoID: Integer;
begin
    // Valida os campos antes de salvar
  FController.ValidarCampos(edtDataCadastro,edtDescricao,edtSigla);

  try
    // O ID já foi carregado anteriormente (não precisa ser definido manualmente aqui)
    FUnidadeMedida.Descricao := edtDescricao.Text;
    FUnidadeMedida.DataCadastro := StrToDate(edtDataCadastro.Text);
    FUnidadeMedida.Sigla := edtSigla.Text;

    case FAcao of
        1: // Ação de Atualizar
          begin
            if FUnidadeMedida.Atualizar then
              begin
                btGravar.Enabled := false;
                btAlterar.Enabled := false;
                btExcluir.Enabled := false;
                MessageDlg('Registro Atualizado com Sucesso!', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0)
              end
            else
              MessageDlg('Erro ao atualizar !', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
          end;

        2:// Ação de Gravar (Salvar)
          begin
            if FUnidadeMedida.Salvar(NovoID) then
            begin
              edtcodigo.Text := IntToStr(NovoID);
              FController.LimparComponentes(Self);
              btGravar.Enabled := false;
              btAlterar.Enabled := false;
              btExcluir.Enabled := false;
              MessageDlg('Registro Salvo com Sucesso!', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0)
            end
            else
              MessageDlg('Erro ao salvar !', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
          end;
     end;

  finally
    btCadastrar.Enabled := True;
    pnlDados.Enabled := False;
  end;
end;


procedure TfrmUnidadeMedida.btSairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmUnidadeMedida.btAlterarClick(Sender: TObject);
begin
  btCadastrar.Enabled := false;
  btAlterar.Enabled := false;
  btExcluir.Enabled := false;
  btGravar.Enabled := True;
  pnlDados.Enabled := true;
  FAcao := 1;
  edtDataCadastro.SetFocus
end;

procedure TfrmUnidadeMedida.btCadastrarClick(Sender: TObject);
begin
  btCadastrar.Enabled := false;
  btAlterar.Enabled := false;
  btExcluir.Enabled := false;
  pnlDados.Enabled := true;
  if FAcao <> 0 then
    FController.LimparComponentes(Self);
  FAcao := 2;
  edtDataCadastro.text :=datetostr(Date);
end;

procedure TfrmUnidadeMedida.btCancelarClick(Sender: TObject);
begin
  btCadastrar.Enabled := true;
  btAlterar.Enabled := true;
  btExcluir.Enabled := true;
  pnlDados.Enabled := false;
end;

function TfrmUnidadeMedida.GetController: TControllerUnidadeMedida;
begin
  Result := FController;
end;


procedure TfrmUnidadeMedida.btExcluirClick(Sender: TObject);
begin
  if edtCodigo.Text = '' then
    Exit;

  if MessageDlg('Tem certeza de que deseja excluir este registro?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  pnlDados.Enabled := True;

  try
    FUnidadeMedida.ID := StrToInt(edtCodigo.Text); // Carrega o ID para exclusão

    if FUnidadeMedida.Deletar then
    begin
      FController.LimparComponentes(Self);
      ShowMessage('Registro excluído com sucesso!') ;
    end
    else
      ShowMessage('Erro ao excluir Registro.');
  finally
    pnlDados.Enabled := False;
  end;
end;


end.

