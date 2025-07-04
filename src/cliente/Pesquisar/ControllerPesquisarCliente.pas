unit ControllerPesquisarCliente;

interface

uses
  System.SysUtils, ModelPesquisarCliente, Data.DB, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,Vcl.Mask,
  IViewPesquisarCliente;  // Importa a interface

type
  TClienteController = class
  private
    FModel: TClienteModel;
    FView: IViewPesquisarClientes;
  public
    constructor Create(AView: IViewPesquisarClientes);  // Recebe a interface da View
    destructor Destroy; override;
    procedure PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,EMail: Boolean);

  end;


implementation

constructor TClienteController.Create(AView: IViewPesquisarClientes);
begin
  FModel := TClienteModel.Create;  // Cria a Model
  FView := AView;  // Armazena a referência da View através da interface
end;

destructor TClienteController.Destroy;
begin
  FModel.Free;
  inherited;
end;

procedure TClienteController.PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,EMail: Boolean);
var
  Clientes: TDataSet;
begin
  // Chama a Model para realizar a pesquisa
  Clientes := FModel.PesquisarClientes(Filtro, PorCodigo, PorNome,EMail);

  // A View será responsável por chamar esse método para atualizar a grid
  if Assigned(FView) then
    FView.AtualizarGrid(Clientes);  // Chama a função de atualização da Grid na View
end;




end.

