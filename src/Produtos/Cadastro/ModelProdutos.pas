unit ModelProdutos;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Stan.Error, uDM;

type
  TProdutosModel = class
  private
    FID: Integer;
    FIDUnidadeMedida: integer;
    FDescricao: string;
    FUnidadeMedidaSigla : string;
    FUnidadeMedidaDescricao: string;
    FValor: double;
    FDataCadastro: TDateTime; // Alterado para TDateTime para manipulação precisa de datas

    procedure SetID(const Value: Integer);
    procedure SetDescricao(const Value: string);
    procedure SetValor(const Value: double);
    procedure SetDataCadastro(const Value: TDateTime);
    procedure SetIDUnidadeMedida(const Value: integer);
    procedure SetUnidadeMedidaDescricao(const Value: string);
    procedure SetUnidadeMedidaSigla(const Value: string);

  public
    property ID: Integer read FID write SetID;
    property Descricao: string read FDescricao write SetDescricao;
    property DataCadastro: TDateTime read FDataCadastro write SetDataCadastro;
    property Valor : double read FValor write SetValor;
    property IDUnidadeMedida: integer read FIDUnidadeMedida write SetIDUnidadeMedida;
    property UnidadeMedidaSigla: string read FUnidadeMedidaSigla write SetUnidadeMedidaSigla;
    property UnidadeMedidaDescricao: string read FUnidadeMedidaDescricao write SetUnidadeMedidaDescricao;

    function BuscarPorID(const ID: Integer): TProdutosModel;
    function Salvar(out NovoID: Integer): Boolean;
    function Deletar: Boolean;
    function Atualizar: Boolean;
  end;

implementation

{ TProdutosModel }

procedure TProdutosModel.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TProdutosModel.SetIDUnidadeMedida(const Value: integer);
begin
 FIDUnidadeMedida := value;
end;

procedure TProdutosModel.SetUnidadeMedidaDescricao(const Value: string);
begin
  FUnidadeMedidaDescricao := Value;
end;

procedure TProdutosModel.SetUnidadeMedidaSigla(const Value: string);
begin
  FUnidadeMedidaSigla := Value;
end;

procedure TProdutosModel.SetValor(const Value: double);
begin
  FValor := Value;
end;

procedure TProdutosModel.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TProdutosModel.SetDataCadastro(const Value: TDateTime);
begin
  FDataCadastro := Value;
end;

function TProdutosModel.Salvar(out NovoID: Integer): Boolean;
var
  Query: TFDQuery;

begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := DM.Conexao;

    Query.SQL.Text := 'INSERT INTO Produtos (DescricaoProduto, DataCadastro, Valor,idUnidadeMedida) ' +
                      'VALUES (:DescricaoProduto, :DataCadastro, :Valor, :idUnidadeMedida)'+'RETURNING id';;
    Query.ParamByName('DescricaoProduto').AsString := FDescricao;
    Query.ParamByName('DataCadastro').AsDate := FDataCadastro;
    Query.ParamByName('Valor').AsFloat := FValor;
    Query.ParamByName('idUnidadeMedida').Asinteger := FIDUnidadeMedida;

    try
      Query.open;


      if not Query.IsEmpty then
      begin
        NovoID := Query.FieldByName('ID').AsInteger;
        Result := True;
      end;

    except
      on E: EFDException do
        raise Exception.Create('Erro ao salvar o Produto ' + E.Message);
    end;
  finally
    Query.Free;

  end;
end;

function TProdutosModel.Deletar: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'DELETE FROM Produtos WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := FID;

    try
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao deletar o Produto: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TProdutosModel.Atualizar: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'UPDATE produtos ' +
                      'SET DescricaoProduto = :DescricaoProduto, ' +
                      '    DataCadastro = :DataCadastro,  ' +
                      '    idUnidadeMedida = :idUnidadeMedida,     Valor = :Valor ' +
                      'WHERE ID = :ID';

    Query.ParamByName('DescricaoProduto').AsString := FDescricao;
    Query.ParamByName('DataCadastro').AsDate := FDataCadastro;
    Query.ParamByName('Valor').Asfloat := FValor;
    Query.ParamByName('idUnidadeMedida').AsInteger := FIDUnidadeMedida;
    Query.ParamByName('ID').AsInteger := FID; // Supondo que você tenha uma propriedade FID para identificar o registro

    try
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao atualizar o Produto : ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;


function TProdutosModel.BuscarPorID(const ID: Integer): TProdutosModel;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;  // Supondo que DM.Conexao seja a conexão com o banco de dados
    Query.SQL.Text := 'SELECT  p.id AS ProdutoID, p.DescricaoProduto AS ProdutoDescricao,' +
                      '        p.Valor AS ProdutoValor,  p.DataCadastro AS ProdutoDataCadastro, ' +
                      '        u.SiglaUnidadeMedida AS UnidadeMedidaSigla,                      ' +
                      '        u.DescricaoUnidadeMedida AS UnidadeMedidaDescricao,               ' +
                      '        u.id AS UnidadeMedidaID               ' +
                      'FROM Produtos p                                                         ' +
                      'LEFT JOIN UnidadeMedida u ON p.idUnidadeMedida = u.id                   ' +
                      'WHERE p.id = :ID'; // Especifica a tabela "p" para o ID
    Query.ParamByName('ID').AsInteger := ID;
    Query.Open;

    if not Query.Eof then
    begin
      // Preenche o objeto TModel com os dados recuperados da consulta
      Result := TProdutosModel.Create;
      Result.ID := Query.FieldByName('ProdutoID').AsInteger;
      Result.Descricao := Query.FieldByName('ProdutoDescricao').AsString;
      Result.DataCadastro := Query.FieldByName('ProdutoDataCadastro').AsDateTime;
      Result.FValor := Query.FieldByName('ProdutoValor').AsFloat;
      Result.FUnidadeMedidaSigla := Query.FieldByName('UnidadeMedidaSigla').AsString;
      Result.FIDUnidadeMedida := Query.FieldByName('UnidadeMedidaID').AsInteger;
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


end.
