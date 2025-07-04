unit ControllerUnidadeMedida;

interface

uses
  System.SysUtils, System.StrUtils,  Vcl.Controls, System.Classes, Vcl.StdCtrls,Vcl.ExtCtrls,
  Winapi.Windows, Winapi.Messages,System.Variants,  Vcl.Graphics,ModelUnidadeMedida,Vcl.Mask,
  Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids ;

type
  TControllerUnidadeMedida = class
  private
    FUnidadeMedida: TUnidadeMedidaModel;
    function RemoverCaracteres(const ATexto: string): string;

  public
    constructor Create;
    destructor Destroy; override;
    function CarregarPorID(UnidadeMedidaID: Integer): TUnidadeMedidaModel;
    procedure LimparComponentes(Container: TWinControl);
    procedure ValidarCampos(const DataCadastro, Descricao, Sigla: TCustomEdit);
  end;

implementation

{ TControllerUnidadeMedida }

constructor TControllerUnidadeMedida.Create;
begin
  FUnidadeMedida := TUnidadeMedidaModel.Create;
end;

destructor TControllerUnidadeMedida.Destroy;
begin
  FUnidadeMedida.Free;
  inherited;
end;

function TControllerUnidadeMedida.RemoverCaracteres(const ATexto: string): string;
begin
  Result := ATexto.Replace('.', '').Replace('-', '').Replace('/', '').Trim;
end;


procedure TControllerUnidadeMedida.ValidarCampos(const DataCadastro, Descricao, Sigla: TCustomEdit);
var
  DataConvertida: TDateTime;
begin
  // Data Cadastro
  if not TryStrToDate(DataCadastro.Text, DataConvertida) then
  begin
    //DataCadastro.SetFocus;
    raise Exception.Create('Data de cadastro inválida.');
  end;

  // Descrição
  if Descricao.Text = '' then
  begin
    descricao.SetFocus;
    raise Exception.Create('A Descrição é obrigatório.');
  end;

  // Sigla
  if Sigla.Text = '' then
  begin
    Sigla.SetFocus;
    raise Exception.Create('A Sigla é  obrigatório.');
  end;

end;

function TControllerUnidadeMedida.CarregarPorID(UnidadeMedidaID: Integer): TUnidadeMedidaModel;
begin
  // Carrega os dados a partir do banco de dados ou outra fonte usando o método BuscarPorID
  Result := FUnidadeMedida.BuscarPorID(UnidadeMedidaID);

  if Result = nil then
    raise Exception.Create('Unidade não encontrado.');
end;

procedure TControllerUnidadeMedida.LimparComponentes(Container: TWinControl);
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

