unit ModelPesquisarUnidadeMedida;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, uDM;

type
  TUnidadeMedidaModel = class
  public
    function Pesquisar(const Filtro: string; const PorCodigo, PorNome,PorSigla: Boolean): TDataSet;
  end;

implementation

function TUnidadeMedidaModel.Pesquisar(const Filtro: string; const PorCodigo, PorNome,PorSigla: Boolean): TDataSet;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;

    // Monta a consulta SQL inicial
    Query.SQL.Text := 'SELECT id, descricaounidademedida, siglaunidademedida FROM UnidadeMedida WHERE 1=1';

    // Adiciona condições baseadas nos filtros e os parâmetros para cada filtro aplicado
    if PorCodigo then
    begin
      Query.SQL.Add('AND id = :idFiltro'); // Mudei para :idFiltro, pois 'id' sozinho pode ser confuso
      Query.ParamByName('idFiltro').AsInteger := StrToIntDef(Filtro, 0);
    end
    else if PorNome then
    begin
      Query.SQL.Add('AND descricaounidademedida ILIKE :descricaoFiltro'); // <-- MUDOU AQUI: Agora o parâmetro é :descricaoFiltro
      Query.ParamByName('descricaoFiltro').AsString := '%' + Filtro + '%'; // <-- E AQUI: Atribuindo ao mesmo nome
    end
    else if PorSigla then
    begin
      Query.SQL.Add('AND siglaunidademedida ILIKE :siglaFiltro'); // <-- MUDOU AQUI: Agora o parâmetro é :siglaFiltro
      Query.ParamByName('siglaFiltro').AsString := '%' + Filtro + '%'; // <-- E AQUI: Atribuindo ao mesmo nome
    end;

    // Executa a consulta
    Query.Open;

    // Retorna o dataset com os dados
    Result := Query;
  except
    on E: Exception do
    begin
      Query.Free; // Libera a query somente em caso de erro
      raise;      // Relança a exceção para tratamento externo
    end;
  end;
end;


















end.

