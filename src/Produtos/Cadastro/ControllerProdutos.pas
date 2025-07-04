unit ControllerProdutos;

interface

uses
  System.SysUtils, System.StrUtils,  Vcl.Controls, System.Classes, Vcl.StdCtrls,Vcl.ExtCtrls,
  Winapi.Windows, Winapi.Messages,System.Variants,  Vcl.Graphics,Vcl.Mask, Vcl.Forms, Vcl.Dialogs,
   Data.DB, Vcl.Grids, Vcl.DBGrids,ModelProdutos,Vcl.CheckLst ;

type
  TControllerProdutos = class
  private
    FModel: TProdutosModel;
    function RemoverCaracteres(const ATexto: string): string;

  public
    constructor Create;
    destructor Destroy; override;
    function CarregarPorID(ID: Integer): TProdutosModel;
    procedure LimparComponentes(Container: TWinControl);
    procedure ValidarCampos(  const DataCadastro, Descricao, Valor: TCustomEdit;  const clbUnidades: TCheckListBox );
  end;

implementation

{ TControllerProduto }

constructor TControllerProdutos.Create;
begin
  FModel := TProdutosModel.Create;
end;

destructor TControllerProdutos.Destroy;
begin
  FModel.Free;
  inherited;
end;

function TControllerProdutos.RemoverCaracteres(const ATexto: string): string;
begin
  Result := ATexto.Replace('.', '').Replace('-', '').Replace('/', '').Trim;
end;


procedure TControllerProdutos.ValidarCampos(  const DataCadastro, Descricao, Valor: TCustomEdit;
  const clbUnidades: TCheckListBox);
var
  DataConvertida: TDateTime;
  ValorNumerico: Double;
  I, TotalMarcados: Integer;
begin
  // Validação da Data de Cadastro
  if not TryStrToDate(DataCadastro.Text, DataConvertida) then
    raise Exception.Create('Data de cadastro inválida.');

  // Validação da Descrição
  if Trim(Descricao.Text) = '' then
  begin
    Descricao.SetFocus;
    raise Exception.Create('A descrição é obrigatória.');
  end;

  // Validação do Valor
  if not TryStrToFloat(Valor.Text, ValorNumerico) then
  begin
    Valor.SetFocus;
    raise Exception.Create('Valor inválido. Por favor, insira um número válido.');
  end;
  FModel.Valor := ValorNumerico;
  Valor.Text := FormatFloat('#,##0.00', FModel.Valor);

  // Validação do CheckListBox
  TotalMarcados := 0;
  for I := 0 to clbUnidades.Items.Count - 1 do
  begin
    if clbUnidades.Checked[I] then
      Inc(TotalMarcados);
  end;

  if TotalMarcados = 0 then
  begin
    clbUnidades.SetFocus;
    raise Exception.Create('Selecione ao menos uma Produto.');
  end;
end;


function TControllerProdutos.CarregarPorID(ID: Integer): TProdutosModel;
begin
  // Carrega os dados a partir do banco de dados ou outra fonte usando o método BuscarPorID
  Result := FModel.BuscarPorID(ID);

  if Result = nil then
    raise Exception.Create('Produto não encontrado.');
end;

procedure TControllerProdutos.LimparComponentes(Container: TWinControl);
var
  I: Integer;
begin
  for I := 0 to Container.ControlCount - 1 do
  begin
    if Container.Controls[I] is TEdit then
      TEdit(Container.Controls[I]).Text := ''
    else if Container.Controls[I] is TMaskEdit then
      TMaskEdit(Container.Controls[I]).Text := ''
    else if Container.Controls[I] is TRadioGroup then
      TRadioGroup(Container.Controls[I]).ItemIndex := -1
    else if Container.Controls[I] is TWinControl then
      LimparComponentes(TWinControl(Container.Controls[I])); // Recursão
  end;
end;


end.

