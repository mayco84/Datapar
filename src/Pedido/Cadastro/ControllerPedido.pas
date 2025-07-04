unit ControllerPedido;

interface

uses
  System.SysUtils, ModelPedido, Vcl.Dialogs, FireDAC.Comp.Client;

type
  TPedidoController = class
  private
    FModel: TPedidoModel;
  public
    constructor Create;
    destructor Destroy; override;

    procedure GravarPedido(const DataPedido: TDateTime; const IdCliente: Integer;
      const Quantidade,Total: Double; const Itens: TArray<TFDQuery>);
    procedure CancelarPedido(const ID: Integer);
    procedure ObterPedido(const ID: Integer);
    function CarregarPorID(ID: Integer): TPedidoModel;
  end;

implementation

{ TPedidoController }

function TPedidoController.CarregarPorID(ID: Integer): TPedidoModel;
begin
  // Carrega os dados a partir do banco de dados ou outra fonte usando o método BuscarPorID
  Result := FModel.BuscarPorID(ID);

  if Result = nil then
    raise Exception.Create('Produto não encontrado.');
end;

constructor TPedidoController.Create;
begin
  FModel := TPedidoModel.Create;
end;

destructor TPedidoController.Destroy;
begin
  FModel.Free;
  inherited;
end;

procedure TPedidoController.GravarPedido(const DataPedido: TDateTime;
  const IdCliente: Integer; const Quantidade,Total: Double; const Itens: TArray<TFDQuery>);
begin
  FModel.DataPedido := DataPedido;
  FModel.IdCliente := IdCliente;
  FModel.Quantidade := Quantidade;
  FModel.Total := Total;

  if not FModel.GravarPedido then
    raise Exception.Create('Erro ao gravar o pedido.');


end;

procedure TPedidoController.CancelarPedido(const ID: Integer);
begin
  FModel.ID := ID;
  if not FModel.CancelarPedido then
    raise Exception.Create('Erro ao cancelar o pedido.');
end;

procedure TPedidoController.ObterPedido(const ID: Integer);
begin
  FModel.ObterPedido(ID);
end;



end.

