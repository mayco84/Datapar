unit ModelUnidadeMedida;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Stan.Error, uDM;

type
  TUnidadeMedidaModel = class
  private
    FID: Integer;
    FDescricao: string;
    FSigla: string;
    FDataCadastro: TDateTime; // Alterado para TDateTime para manipulação precisa de datas


    procedure SetID(const Value: Integer);
    procedure SetDescricao(const Value: string);
    procedure SetSigla(const Value: string);
    procedure SetDataNascimento(const Value: TDateTime); // Alterado para TDateTime




  public
    property ID: Integer read FID write SetID;
    property Descricao: string read FDescricao write SetDescricao;
    property DataCadastro: TDateTime read FDataCadastro write SetDataNascimento;
    property Sigla : string read FSigla write SetSigla;

    function BuscarPorID(const UnidadeMedidaID: Integer): TUnidadeMedidaModel;
    function Salvar(out NovoID: Integer): Boolean;
    function Deletar: Boolean;
    function Atualizar: Boolean;
  end;

implementation

{ TUnidadeMedidaModel }

procedure TUnidadeMedidaModel.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TUnidadeMedidaModel.SetSigla(const Value: string);
begin
  FSigla := Value;
end;

procedure TUnidadeMedidaModel.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TUnidadeMedidaModel.SetDataNascimento(const Value: TDateTime);
begin
  FDataCadastro := Value;
end;

function TUnidadeMedidaModel.Salvar(out NovoID: Integer): Boolean;
var
  Query: TFDQuery;

begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := DM.Conexao;

    Query.SQL.Text := 'INSERT INTO UnidadeMedida (DescricaoUnidadeMedida, DataCadastro, SiglaUnidadeMedida) ' +
                      'VALUES (:DescricaoUnidadeMedida, :DataCadastro, :SiglaUnidadeMedida)'+'RETURNING id';
    Query.ParamByName('DescricaoUnidadeMedida').AsString := FDescricao;
    Query.ParamByName('DataCadastro').AsDate := FDataCadastro;
    Query.ParamByName('SiglaUnidadeMedida').AsString := FSigla;


    try
      Query.Open;

      if not Query.IsEmpty then
      begin
        NovoID := Query.FieldByName('ID').AsInteger;
        Result := True;
      end;

    except
      on E: EFDException do
        raise Exception.Create('Erro ao salvar a Unidade de Medida: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TUnidadeMedidaModel.Deletar: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'DELETE FROM UnidadeMedida WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := FID;

    try
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao deletar a Unidade de Medida: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TUnidadeMedidaModel.Atualizar: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'UPDATE UnidadeMedida ' +
                      'SET DescricaoUnidadeMedida = :DescricaoUnidadeMedida, ' +
                      '    DataCadastro = :DataCadastro, ' +
                      '    SiglaUnidadeMedida = :SiglaUnidadeMedida ' +
                      'WHERE ID = :ID';

    Query.ParamByName('DescricaoUnidadeMedida').AsString := FDescricao;
    Query.ParamByName('DataCadastro').AsDate := FDataCadastro;
    Query.ParamByName('SiglaUnidadeMedida').AsString := FSigla;
    Query.ParamByName('ID').AsInteger := FID; // Supondo que você tenha uma propriedade FID para identificar o registro

    try
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao atualizar a Unidade de Medida: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;



function TUnidadeMedidaModel.BuscarPorID(const UnidadeMedidaID: Integer): TUnidadeMedidaModel;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;  // Supondo que DM.Conexao seja a conexão com o banco de dados
    Query.SQL.Text := 'SELECT * FROM UnidadeMedida WHERE id = :ID';
    Query.ParamByName('ID').AsInteger := UnidadeMedidaID;
    Query.Open;

    if not Query.Eof then
    begin
      // Preenche o objeto TUnidadeModel com os dados recuperados da consulta
      Result := TUnidadeMedidaModel.Create;
      Result.ID := Query.FieldByName('id').AsInteger;
      Result.Descricao := Query.FieldByName('DescricaoUnidadeMedida').AsString;
      Result.DataCadastro := Query.FieldByName('DataCadastro').AsDateTime;
      Result.FSigla := Query.FieldByName('SiglaUnidadeMedida').AsString;
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
