unit ModelPedido;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt, Data.DB, uDM;

type
  TPedidoModel = class
  private
    FID: Integer;
    FDataPedido: TDateTime;
    FIdCliente: Integer;
    FTotal: Double;
    FNome: string;
    FIDProduto: integer;
    FNomeProduto: string;
    FQuantidade: double;
    FSiglaUnidadeMedida: string;
    procedure setNome(const Value: string);
    procedure SetDataPedido(const Value: TDateTime);
    procedure SetID(const Value: Integer);
    procedure SetIDCliente(const Value: Integer);
    procedure SetTotal(const Value: Double);
    procedure SetIDProduto(const Value: integer);
    procedure SetNomeProduto(const Value: string);
    procedure SetQuantidade(const Value: double);
    procedure SetSigla(const Value: string);



  public
    property ID: Integer read FID write SetID;
    property DataPedido: TDateTime read FDataPedido write SetDataPedido;
    property IdCliente: Integer read FIdCliente write SetIDCliente;
    property Total: Double read FTotal write SetTotal;
    property Nome: string read FNome write setNome;
    property IDPRODUTO: integer read FIDProduto write SetIDProduto;
    property nomeproduto: string read FNomeProduto write SetNomeProduto;
    property Quantidade: double read FQuantidade write SetQuantidade;
    property Sigla : string read FSiglaUnidadeMedida write SetSigla;

    function GravarPedido: Boolean;
    function GravarItensPedido(Items: TArray<TFDQuery>): Boolean;
    function CancelarPedido: Boolean;

    function ObterPedido(ID: Integer): TFDQuery;
    function ObterItensPedido(IDPedido: Integer): TFDQuery;
    function GerarNovoIDPedido: Integer;
    function BuscarPorID(const ID: Integer): TPedidoModel;
  end;

implementation

{ TPedidoModel }

function TPedidoModel.GravarPedido: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'INSERT INTO Pedido (DataPedido, IdCliente, Total) ' +
                      'VALUES (:DataPedido, :IdCliente, :Total)';
    Query.ParamByName('DataPedido').AsDateTime := FDataPedido;
    Query.ParamByName('IdCliente').AsInteger := FIdCliente;
    Query.ParamByName('Total').AsFloat := FTotal;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TPedidoModel.GravarItensPedido(Items: TArray<TFDQuery>): Boolean;
var
  Query: TFDQuery;
  Item: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    for Item in Items do
    begin
      Query.SQL.Text := 'INSERT INTO PedidoItens (idPedido, Quantidade, idUnidadeMedida, Valor, Total) ' +
                        'VALUES (:idPedido, :Quantidade, :idUnidadeMedida, :Valor, :Total)';
      Query.ParamByName('idPedido').AsInteger := Item.FieldByName('idPedido').AsInteger;
      Query.ParamByName('Quantidade').AsFloat := Item.FieldByName('Quantidade').AsFloat;
      Query.ParamByName('idUnidadeMedida').AsInteger := Item.FieldByName('idUnidadeMedida').AsInteger;
      Query.ParamByName('Valor').AsFloat := Item.FieldByName('Valor').AsFloat;
      Query.ParamByName('Total').AsFloat := Item.FieldByName('Total').AsFloat;
      Query.ExecSQL;
    end;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TPedidoModel.GerarNovoIDPedido: Integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'SELECT MAX(id) FROM Pedido'; // Consulta o maior ID de Pedido
    Query.Open;

   if Query.Fields[0].IsNull then
      Result := 1  // Se não houver registros, começa com o ID 1
    else
      Result := Query.Fields[0].AsInteger + 1;  // Caso contrário, incrementa o maior ID encontrado

  finally
    Query.Free;
  end;
end;


function TPedidoModel.BuscarPorID(const ID: Integer): TPedidoModel;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'SELECT  p.id, p.dataPedido, C.id, C.NomeCompleto as nome, p.total, '+
                  'PI.idUnidadeMedida, PI.Quantidade AS qtde, PI.Total, PO.id AS IDPRODUTO, PO.DescricaoProduto AS nomeproduto, '+
                  'UM.SiglaUnidadeMedida AS Sigla ' +
                  'FROM pedido P ' +
                  'LEFT JOIN cliente C ON (C.id = P.IdCliente) ' +
                  'LEFT JOIN PedidoItens PI ON (PI.idPedido = P.id) ' +
                  'LEFT JOIN UnidadeMedida UM ON (UM.id = PI.idUnidadeMedida) ' +
                  'LEFT JOIN produtos PO ON (PO.id = PI.idProduto) ' +
                  'WHERE P.id = :ID';
    Query.ParamByName('ID').AsInteger := ID;
    Query.Open;


    if not Query.Eof then
    begin
      // Preenche o objeto TModel com os dados recuperados da consulta
      Result := TPedidoModel.Create;
      Result.ID := Query.FieldByName('ID').AsInteger;
      Result.FNome := Query.FieldByName('Nome').AsString;
      Result.FDataPedido := Query.FieldByName('DataPedido').AsDateTime;
      Result.FTotal := Query.FieldByName('Total').AsFloat;
      Result.FIDProduto := Query.FieldByName('idproduto').AsInteger;
      Result.nomeproduto := Query.FieldByName('nomeproduto').Asstring;
      Result.Quantidade := Query.FieldByName('Qtde').AsFloat;
      Result.FSiglaUnidadeMedida := query.FieldByName('Sigla').AsString;
    end
    else
    begin
      Result := nil;  // Caso não encontre a unidade
    end;
  except
    Query.Free;
    raise;
  end;

end;

function TPedidoModel.CancelarPedido: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'DELETE FROM Pedido WHERE id = :ID';
    Query.ParamByName('ID').AsInteger := FID;
    Query.ExecSQL;

    Query.SQL.Text := 'DELETE FROM PedidoItens WHERE idPedido = :idPedido';
    Query.ParamByName('idPedido').AsInteger := FID;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

function TPedidoModel.ObterPedido(ID: Integer): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := DM.Conexao;
  Result.SQL.Text := 'SELECT * FROM Pedido WHERE id = :ID';
  Result.ParamByName('ID').AsInteger := ID;
  Result.Open;
end;

procedure TPedidoModel.SetDataPedido(const Value: TDateTime);
begin
  FDataPedido := Value;
end;

procedure TPedidoModel.setNome(const Value: string);
begin
  FNome := Value;
end;

procedure TPedidoModel.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TPedidoModel.SetIDCliente(const Value: Integer);
begin
  FIdCliente := Value;
end;

procedure TPedidoModel.SetIDProduto(const Value: integer);
begin
  FIDProduto := Value;
end;

procedure TPedidoModel.SetNomeProduto(const Value: string);
begin
  FNomeProduto := Value;
end;

procedure TPedidoModel.SetQuantidade(const Value: double);
begin
  FQuantidade := Value;
end;

procedure TPedidoModel.SetSigla(const Value: string);
begin
  FSiglaUnidadeMedida := Value;
end;

procedure TPedidoModel.SetTotal(const Value: Double);
begin
  FTotal := Value;
end;

function TPedidoModel.ObterItensPedido(IDPedido: Integer): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := DM.Conexao;
  Result.SQL.Text := 'SELECT * FROM PedidoItens WHERE idPedido = :idPedido';
  Result.ParamByName('idPedido').AsInteger := IDPedido;
  Result.Open;
end;

end.

