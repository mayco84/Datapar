unit ViewCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,System.UITypes,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,System.JSON,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,uDM, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,ViaCEP,ControllerCliente,
  ModelCliente;
type
  TfrmCliente = class(TForm)
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
    edtDataNascimento: TMaskEdit;
    Label2: TLabel;
    rgpTipoPessoa: TRadioGroup;
    edtNomeCompleto: TEdit;
    Label3: TLabel;
    edtRG: TEdit;
    lblRG: TLabel;
    lblCPF: TLabel;
    lblTelefone: TLabel;
    edtEMail: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtEndereco: TEdit;
    Label9: TLabel;
    edtBairro: TEdit;
    edtCidade: TEdit;
    Label10: TLabel;
    edtUF: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    edtCEP: TMaskEdit;
    btnPesquisarCEP: TSpeedButton;
    edtNumero: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    edtComplemento: TEdit;
    rgpTipoFJ: TRadioGroup;
    edtDocumento: TMaskEdit;
    edtTelefone: TMaskEdit;
    Label4: TLabel;
    Label5: TLabel;
    procedure btGravarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btnPesquisarCEPClick(Sender: TObject);
    procedure btCadastrarClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure rgpTipoFJClick(Sender: TObject);
    procedure rgpTipoPessoaClick(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FController: TControllerCliente;  // Controller privado
    FTipo,
    FTipoPessoa: string;
    FAcao: integer; /// 1 atualiza , 2 grava
    FCliente: TClienteModel;
    procedure ConsultarCEP(CEP: string);
  public

    destructor Destroy; override;
    procedure CarregarClientePorID(ClienteID: Integer);  // Novo método público para carregar o cliente
    procedure Inicializar;  // Método para inicializar a tela, se necessário
    function GetController: TControllerCliente;
    constructor Create(AOwner: TComponent); // Novo método para acessar o Controller

  end;

var
  frmCliente: TfrmCliente;

implementation

{$R *.dfm}

procedure TfrmCliente.Inicializar;
begin
  FController := TControllerCliente.Create();
end;

procedure TfrmCliente.rgpTipoFJClick(Sender: TObject);
begin
  case rgpTipoFJ.ItemIndex of
    0: //Física
      begin
        FTipoPessoa := 'F'; //Física
        lblRG.Caption := 'R.G.';
        lblCPF.Caption := 'C.P.F.';
        edtDocumento.EditMask := '000\.000\.000\-00;1;';
      end;
    1:  //Jurídica
      begin
        FTipoPessoa := 'J'; //Jurídica
        lblRG.Caption := 'I.E.';
        lblCPF.Caption := 'C.N.P.J.';
        edtDocumento.EditMask :='00\.000\.000/0000\-00;1;';
      end;
  end;
end;

procedure TfrmCliente.rgpTipoPessoaClick(Sender: TObject);
begin
  case rgpTipoPessoa.ItemIndex of
      0: FTipo := 'C'; // Cliente
      1: FTipo := 'F'; // Fornecedor
      2: FTipo := 'T'; //Transportadora
    end;
end;

procedure TfrmCliente.CarregarClientePorID(ClienteID: Integer);
begin
  FCliente := FController.CarregarClientePorID(ClienteID);  // Chama o método no Controller para carregar os dados

  // preenche os campos do formulário com os dados do cliente
  edtCodigo.Text := IntToStr(FCliente.ID);
  edtNomeCompleto.Text := FCliente.NomeCompleto;
  edtRG.Text := FCliente.RG;
  edtDocumento.Text := FCliente.CPF;
  edtEndereco.Text := FCliente.Endereco;
  edtBairro.Text := FCliente.Bairro;
  edtCidade.Text := FCliente.Cidade;
  edtUF.Text := FCliente.UF;
  edtCEP.Text := FCliente.CEP;
  edtTelefone.Text := FCliente.Telefone;
  edtEMail.Text := FCliente.Email;
  edtDataNascimento.Text := DateToStr(FCliente.DataNascimento);
  edtNumero.Text := FCliente.Numero;
  edtComplemento.Text := FCliente.Complemento;

  case Char(FCliente.TipoPessoa[1]) of
    'C': rgpTipoPessoa.ItemIndex := 0;
    'F': rgpTipoPessoa.ItemIndex := 1;
    'T': rgpTipoPessoa.ItemIndex := 2;
  end;

  case Char(FCliente.FisicaJuridica[1]) of
    'F': rgpTipoFJ.ItemIndex := 0;
    'J': rgpTipoFJ.ItemIndex := 1;
  end;

end;


procedure TfrmCliente.ConsultarCEP(CEP: string);
var
  ViaCEP: TViaCEP;
  JSON: TJSONObject;
  Logradouro, Bairro, Cidade, UF: string;
begin
  ViaCEP := TViaCEP.Create;
  Try
    JSON := ViaCEP.ConsultarCEP(CEP);
    try
      if Assigned(JSON) then
        try
          // Lendo os dados do JSON retornado
          Logradouro := JSON.GetValue<string>('logradouro', '');
          Bairro := JSON.GetValue<string>('bairro', '');
          Cidade := JSON.GetValue<string>('localidade', '');
          UF := JSON.GetValue<string>('uf', '');

          // Exibindo os dados
          edtEndereco.Text := Logradouro;
          edtbairro.Text := Bairro;
          edtCidade.Text := Cidade;
          edtUF.Text := UF;
        finally
          JSON.Free;
        end;

    except
      on E: Exception do
        ShowMessage('Erro: ' + E.Message);
    end;
  finally
    ViaCEP.Free;
    edtNumero.SetFocus;
  end;
end;

constructor TfrmCliente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner); // Chama o construtor da classe base
  FCliente := TClienteModel.Create;
  FController := TControllerCliente.Create;
end;

destructor TfrmCliente.Destroy;
begin
  FCliente.Free;
  inherited;
end;

procedure TfrmCliente.edtCEPExit(Sender: TObject);
begin
  btnPesquisarCEPClick(Sender);
end;

procedure TfrmCliente.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      close;
  end;
end;

procedure TfrmCliente.btGravarClick(Sender: TObject);
var
  NovoID: Integer;
begin
    // Valida os campos antes de salvar
  FController.ValidarCampos(edtNomeCompleto, edtDataNascimento,edtRG, edtDocumento, edtTelefone, edtEmail,
                            edtEndereco, edtBairro, edtCidade, edtUF,edtNumero, edtCEP,rgpTipoFJ,rgpTipoPessoa);

  try
    // O ID já foi carregado anteriormente (não precisa ser definido manualmente aqui)
    FCliente.NomeCompleto := edtNomeCompleto.Text;
    FCliente.FisicaJuridica := FTipoPessoa;
    FCliente.TipoPessoa := FTipo;
    FCliente.CPF := edtDocumento.Text;
    FCliente.rg := edtRG.Text;
    FCliente.Endereco := edtEndereco.Text;
    FCliente.Bairro := edtBairro.Text;
    FCliente.Cidade := edtCidade.Text;
    FCliente.UF := edtUF.Text;
    FCliente.CEP := edtCEP.Text;
    FCliente.Telefone := edtTelefone.Text;
    FCliente.Email := edtEMail.Text;
    FCliente.DataNascimento := StrToDate(edtDataNascimento.Text);
    FCliente.Numero := edtNumero.Text;
    FCliente.Complemento := edtComplemento.Text;

     case FAcao of
        1: // Ação de Atualizar
          begin
            if FCliente.AtualizarCliente then
              begin
                btGravar.Enabled := false;
                btAlterar.Enabled := false;
                btExcluir.Enabled := false;
                MessageDlg('Registro Atualizado com Sucesso!', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0)
              end
            else
              MessageDlg('Erro ao atualizar cliente!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
          end;

        2:// Ação de Gravar (Salvar)
          begin
            if FCliente.SalvarCliente(NovoID) then
            begin
              edtcodigo.Text := IntToStr(NovoID);
              FController.LimparComponentes(Self);
              btGravar.Enabled := false;
              btAlterar.Enabled := false;
              btExcluir.Enabled := false;
              MessageDlg('Registro Salvo com Sucesso!', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0)
            end
            else
              MessageDlg('Erro ao salvar cliente!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
          end;
     end;

  finally
    btCadastrar.Enabled := true;
    pnlDados.Enabled := False;
  end;
end;

procedure TfrmCliente.btnPesquisarCEPClick(Sender: TObject);
begin
  ConsultarCEP(edtCEP.Text);
end;

procedure TfrmCliente.btSairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCliente.btAlterarClick(Sender: TObject);
begin
  btCadastrar.Enabled := false;
  btAlterar.Enabled := false;
  btExcluir.Enabled := false;
  btGravar.Enabled := True;
  pnlDados.Enabled := true;
  FAcao := 1;
  edtDataNascimento.SetFocus
end;

procedure TfrmCliente.btCadastrarClick(Sender: TObject);
begin
  btCadastrar.Enabled := false;
  btAlterar.Enabled := false;
  btExcluir.Enabled := false;
  btGravar.Enabled := True;
  pnlDados.Enabled := true;
  if FAcao <> 0 then
    FController.LimparComponentes(Self);
  FAcao := 2;
  edtDataNascimento.SetFocus;
end;

procedure TfrmCliente.btCancelarClick(Sender: TObject);
begin
  btCadastrar.Enabled := true;
  btAlterar.Enabled := true;
  btExcluir.Enabled := true;
  pnlDados.Enabled := false;
end;

function TfrmCliente.GetController: TControllerCliente;
begin
  Result := FController;
end;


procedure TfrmCliente.btExcluirClick(Sender: TObject);
begin
  if edtCodigo.Text = '' then
    Exit;

  if MessageDlg('Tem certeza de que deseja excluir este cliente?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  pnlDados.Enabled := True;

  try
    FCliente.ID := StrToInt(edtCodigo.Text); // Carrega o ID para exclusão

    if FCliente.DeletarCliente then
    begin
      FController.LimparComponentes(Self);
      ShowMessage('Cliente excluído com sucesso!') ;
    end
    else
      ShowMessage('Erro ao excluir cliente.');
  finally
    pnlDados.Enabled := False;
  end;
end;


end.

