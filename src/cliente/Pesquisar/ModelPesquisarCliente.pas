unit ModelPesquisarCliente;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, uDM;

type
  TClienteModel = class
  public
    function PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,PorEMail: Boolean): TDataSet;
  end;

implementation

function TClienteModel.PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,PorEMail: Boolean): TDataSet;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;

    // Monta a consulta SQL inicial
    Query.SQL.Text := 'SELECT id, NomeCompleto, CPF, Telefone, Email FROM Cliente WHERE 1=1';

    // Adiciona condições baseadas nos filtros
    if PorCodigo then
    begin
      Query.SQL.Add('AND id = :FiltroCodigo');
      Query.ParamByName('FiltroCodigo').AsInteger := StrToIntDef(Filtro, 0);
    end
    else if PorNome then // Use else if para garantir que apenas um filtro seja aplicado
    begin
      Query.SQL.Add('AND NomeCompleto ILIKE :FiltroNome');
      Query.ParamByName('FiltroNome').AsString := '%' + Filtro + '%';
    end
    else if PorEmail then // Use else if
    begin
      Query.SQL.Add('AND Email ILIKE :FiltroEmail');
      Query.ParamByName('FiltroEmail').AsString := '%' + Filtro + '%';
    end;


    Query.Open; // <--- Abre a Query UMA ÚNICA VEZ, após a SQL estar completa.

    // Retorna o dataset com os dados
    Result := Query; // <--- ATRIBUI Result AGORA, no final do bloco 'try'.
  except
    on E: Exception do
    begin
      Query.Free; // Libera a query somente em caso de erro
      raise;      // Relança a exceção para tratamento externo
    end;
  end;
end;

end.

