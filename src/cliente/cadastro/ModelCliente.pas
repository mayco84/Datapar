unit ModelCliente;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections, // Mantenha as units do System juntas
  Data.DB,

  // --- Units FireDAC agrupadas ---
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Error,
  FireDAC.Stan.Param,
  FireDAC.Stan.Option,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Def,
  // -------------------------------

  Winapi.Windows, // Unit do Windows
  uDM;
type
  TClienteModel = class
  private
    FID: Integer;
    FNomeCompleto: string;
    FCPF: string;
    FEndereco: string;
    FBairro: string;
    FCidade: string;
    FUF: string;
    FCEP: string;
    FTelefone: string;
    FEmail: string;
    FDataNascimento: TDateTime;
    FNumero: string;
    FComplemento: string;
    FTipoPessoa: string;
    FRG: string;
    FFisicaJuridica: string;

    procedure SetID(const Value: Integer);
    procedure SetNomeCompleto(const Value: string);
    procedure SetCPF(const Value: string);
    procedure SetEndereco(const Value: string);
    procedure SetBairro(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetUF(const Value: string);
    procedure SetCEP(const Value: string);
    procedure SetTelefone(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetDataNascimento(const Value: TDateTime);
    procedure SetNumero(const Value: string);
    procedure SetComplemento(const Value: string);
    procedure SetTipoPessoa(const Value: string);
    procedure setRG(const Value: string);
    procedure SetFisicaJuridica(const Value: string);

  public
    property ID: Integer read FID write SetID;
    property NomeCompleto: string read FNomeCompleto write SetNomeCompleto;
    property TipoPessoa: string read FTipoPessoa write SetTipoPessoa;
    property FisicaJuridica: string read FFisicaJuridica write SetFisicaJuridica;
    property CPF: string read FCPF write SetCPF;
    property RG: string read FRG write setRG;
    property Endereco: string read FEndereco write SetEndereco;
    property Bairro: string read FBairro write SetBairro;
    property Cidade: string read FCidade write SetCidade;
    property UF: string read FUF write SetUF;
    property CEP: string read FCEP write SetCEP;
    property Telefone: string read FTelefone write SetTelefone;
    property Email: string read FEmail write SetEmail;
    property DataNascimento: TDateTime read FDataNascimento write SetDataNascimento;
    property Numero: string read FNumero write SetNumero;
    property Complemento: string read FComplemento write SetComplemento;

    // Métodos existentes
    function BuscarPorID(const ClienteID: Integer): TClienteModel;
    function SalvarCliente(out NovoID: Integer): Boolean;
    function DeletarCliente: Boolean;
    function AtualizarCliente: Boolean;

    // NOVO MÉTODO PARA INSERÇÃO EM LOTE (MOC)
    class function SalvarClientesEmLote(const AClientes: TList<TClienteModel>): Boolean;
  end;

implementation

{ TClienteModel }

procedure TClienteModel.SetID(const Value: Integer); begin FID := Value; end;
procedure TClienteModel.SetNomeCompleto(const Value: string); begin FNomeCompleto := Value; end;
procedure TClienteModel.SetCPF(const Value: string); begin FCPF := Value; end;
procedure TClienteModel.SetEndereco(const Value: string); begin FEndereco := Value; end;
procedure TClienteModel.SetFisicaJuridica(const Value: string); begin FFisicaJuridica := Value; end;
procedure TClienteModel.SetBairro(const Value: string); begin FBairro := Value; end;
procedure TClienteModel.SetCidade(const Value: string); begin FCidade := Value; end;
procedure TClienteModel.SetUF(const Value: string); begin FUF := Value; end;
procedure TClienteModel.SetCEP(const Value: string); begin FCEP := Value; end;
procedure TClienteModel.SetTelefone(const Value: string); begin FTelefone := Value; end;
procedure TClienteModel.SetTipoPessoa(const Value: string); begin FTipoPessoa := Value; end;
procedure TClienteModel.SetEmail(const Value: string); begin FEmail := Value; end;
procedure TClienteModel.SetDataNascimento(const Value: TDateTime); begin FDataNascimento := Value; end;
procedure TClienteModel.SetNumero(const Value: string); begin FNumero := Value; end;
procedure TClienteModel.setRG(const Value: string); begin FRG := Value; end;
procedure TClienteModel.SetComplemento(const Value: string); begin FComplemento := Value; end;

function TClienteModel.SalvarCliente(out NovoID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'INSERT INTO Cliente (NomeCompleto, FisicaJuridica, TipoPessoa, CPF, RG, Endereco, Bairro, Cidade, UF, CEP, Telefone, Email, DataNascimento, Numero, Complemento) ' +
                      'VALUES (:NomeCompleto, :FisicaJuridica, :TipoPessoa, :CPF, :RG, :Endereco, :Bairro, :Cidade, :UF, :CEP, :Telefone, :Email, :DataNascimento, :Numero, :Complemento)'+
                      ' RETURNING id'; // Mantido para inserção individual

    Query.ParamByName('NomeCompleto').AsString := FNomeCompleto;
    Query.ParamByName('FisicaJuridica').AsString := FFisicaJuridica;
    Query.ParamByName('TipoPessoa').AsString := FTipoPessoa;
    Query.ParamByName('CPF').AsString := FCPF;
    Query.ParamByName('RG').AsString := FRG;
    Query.ParamByName('Endereco').AsString := FEndereco;
    Query.ParamByName('Bairro').AsString := FBairro;
    Query.ParamByName('Cidade').AsString := FCidade;
    Query.ParamByName('UF').AsString := FUF;
    Query.ParamByName('CEP').AsString := FCEP;
    Query.ParamByName('Telefone').AsString := FTelefone;
    Query.ParamByName('Email').AsString := FEmail;
    Query.ParamByName('DataNascimento').AsDateTime := FDataNascimento;
    Query.ParamByName('Numero').AsString := FNumero;
    Query.ParamByName('Complemento').AsString := FComplemento;

    try
      Query.Open(); // Usa Open() para obter o RETURNING ID

      if not Query.IsEmpty then
      begin
        NovoID := Query.FieldByName('ID').AsInteger;
        Result := True;
      end;
    except
      on E: EFDException do
      begin
        if Pos('UNIQUE constraint failed', E.Message) > 0 then
          raise Exception.Create('Este CPF já está cadastrado no sistema. Por favor, insira um CPF diferente.')
        else
          raise Exception.Create('Erro ao salvar o cliente: ' + E.Message);
      end;
      on E: Exception do
        raise Exception.Create('Erro ao salvar o cliente: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TClienteModel.DeletarCliente: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'DELETE FROM Cliente WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := FID;

    try
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao deletar cliente: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TClienteModel.AtualizarCliente: Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'UPDATE Cliente SET NomeCompleto = :NomeCompleto, FisicaJuridica = :FisicaJuridica, ' +
                      'TipoPessoa = :TipoPessoa, CPF = :CPF, RG = :RG, Endereco = :Endereco, Bairro = :Bairro, ' +
                      'Cidade = :Cidade, UF = :UF, CEP = :CEP, Telefone = :Telefone, Email = :Email, ' +
                      'DataNascimento = :DataNascimento, Numero = :Numero, Complemento = :Complemento ' +
                      'WHERE ID = :ID';
    Query.ParamByName('NomeCompleto').AsString := FNomeCompleto;
    Query.ParamByName('FisicaJuridica').AsString := FFisicaJuridica;
    Query.ParamByName('TipoPessoa').AsString := FTipoPessoa;
    Query.ParamByName('CPF').AsString := FCPF;
    Query.ParamByName('RG').AsString := FRG;
    Query.ParamByName('Endereco').AsString := FEndereco;
    Query.ParamByName('Bairro').AsString := FBairro;
    Query.ParamByName('Cidade').AsString := FCidade;
    Query.ParamByName('UF').AsString := FUF;
    Query.ParamByName('CEP').AsString := FCEP;
    Query.ParamByName('Telefone').AsString := FTelefone;
    Query.ParamByName('Email').AsString := FEmail;
    Query.ParamByName('DataNascimento').AsDateTime := FDataNascimento;
    Query.ParamByName('Numero').AsString := FNumero;
    Query.ParamByName('Complemento').AsString := FComplemento;
    Query.ParamByName('ID').AsInteger := FID;

    try
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao atualizar o cliente: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;

function TClienteModel.BuscarPorID(const ClienteID: Integer): TClienteModel;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;
    Query.SQL.Text := 'SELECT * FROM Cliente WHERE id = :ID';
    Query.ParamByName('ID').AsInteger := ClienteID;
    Query.Open;

    if not Query.Eof then
    begin
      Result := TClienteModel.Create;
      Result.ID := Query.FieldByName('id').AsInteger;
      Result.NomeCompleto := Query.FieldByName('NomeCompleto').AsString;
      Result.Email := Query.FieldByName('Email').AsString;
      Result.Telefone := Query.FieldByName('Telefone').AsString;
      Result.CPF := Query.FieldByName('CPF').AsString;
      Result.RG := Query.FieldByName('RG').AsString;
      Result.FFisicaJuridica := Query.FieldByName('FisicaJuridica').AsString;
      Result.TipoPessoa := Query.FieldByName('TipoPessoa').AsString;
      Result.Endereco := Query.FieldByName('Endereco').AsString;
      Result.Bairro := Query.FieldByName('Bairro').AsString;
      Result.Cidade := Query.FieldByName('Cidade').AsString;
      Result.UF := Query.FieldByName('UF').AsString;
      Result.CEP := Query.FieldByName('CEP').AsString;
      Result.DataNascimento := Query.FieldByName('DataNascimento').AsDateTime;
      Result.Numero := Query.FieldByName('Numero').AsString;
      Result.Complemento := Query.FieldByName('Complemento').AsString;
    end
    else
    begin
      Result := nil;
    end;
  finally
    Query.Free;
  end;
end;

// NOVO MÉTODO PARA INSERÇÃO EM LOTE
class function TClienteModel.SalvarClientesEmLote(const AClientes: TList<TClienteModel>): Boolean;
var
  Query: TFDQuery;
  I: Integer;
begin
  Result := False;
  if AClientes.Count = 0 then
    Exit;

  Query := TFDQuery.Create(nil);
 // Query.Connection := DM.Conexao;
  try
    Query.Connection := DM.Conexao;
  //  Query.SQL.Text := 'INSERT INTO Cliente (NomeCompleto, FisicaJuridica, TipoPessoa, CPF, RG, Endereco, Bairro, Cidade, UF, CEP, Telefone, Email, DataNascimento, Numero, Complemento) ' +
   //                   'VALUES (:NomeCompleto, :FisicaJuridica, :TipoPessoa, :CPF, :RG, :Endereco, :Bairro, :Cidade, :UF, :CEP, :Telefone, :Email, :DataNascimento, :Numero, :Complemento)';
   Query.SQL.Text := 'INSERT INTO Cliente (NomeCompleto) VALUES (:NomeCompleto)';

    // Configura o Array DML
    Query.Params.ArraySize := AClientes.Count;
    Query.Params.Clear; // Limpa quaisquer parâmetros pré-existentes

    // Antes de Query.Prepare;


   Query.Prepare;

   (* Query.UpdateOptions.AssignedValues := [uvArrayDML]; // Garante que o Array DML está ativado
    Query.UpdateOptions.ArrayDML := True;               // Confirma o uso de Array DML
    Query.SQL.Add('; -- Array DML debugging'); // Adiciona um comentário para ver no log do DB

    // Captura erros de forma mais detalhada, caso o banco esteja reportando
    Query.Connection.ConnectionOptions.AutoClose := False; // Garante que a conexão não feche prematuramente
    Query.Connection.FormatOptions.MapRules.Clear; // Limpa regras de mapeamento que possam interferir
    Query.Connection.FormatOptions.MaxValues.Clear; // Limpa max values que possam cortar strings

    // Configure para capturar erros específicos de SQL
    Query.Connection.ResourceOptions.SilentError := False; // Não silenciar erros
    Query.Connection.ResourceOptions.NoLiterals := True; // Para alguns DBs, ajuda na depuração de parâmetros  *)



    // Preenche os parâmetros com os dados de todos os clientes no lote
    for I := 0 to AClientes.Count - 1 do
    begin
      Query.ParamByName('NomeCompleto').AsStrings[I] := AClientes[I].NomeCompleto;
      Query.ParamByName('FisicaJuridica').AsStrings[I] := AClientes[I].FisicaJuridica;
      Query.ParamByName('TipoPessoa').AsStrings[I] := AClientes[I].TipoPessoa;
      Query.ParamByName('CPF').AsStrings[I] := AClientes[I].CPF;
      Query.ParamByName('RG').AsStrings[I] := AClientes[I].RG;
      Query.ParamByName('Endereco').AsStrings[I] := AClientes[I].Endereco;
      Query.ParamByName('Bairro').AsStrings[I] := AClientes[I].Bairro;
      Query.ParamByName('Cidade').AsStrings[I] := AClientes[I].Cidade;
      Query.ParamByName('UF').AsStrings[I] := AClientes[I].UF;
      Query.ParamByName('CEP').AsStrings[I] := AClientes[I].CEP;
      Query.ParamByName('Telefone').AsStrings[I] := AClientes[I].Telefone;
      Query.ParamByName('Email').AsStrings[I] := AClientes[I].Email;
      Query.ParamByName('DataNascimento').AsDateTimes[I] := AClientes[I].DataNascimento; // Use AsDateTimes para TDateTime
      Query.ParamByName('Numero').AsStrings[I] := AClientes[I].Numero;
      Query.ParamByName('Complemento').AsStrings[I] := AClientes[I].Complemento;
    end;

    // Inicia a transação para garantir atomicidade e performance

    DM.Conexao.StartTransaction;
    try
      // Tenta executar. Se houver erro, a exceção deverá ser lançada.
      Query.ExecSQL; // Esta é a chamada para o Array DML
      DM.Conexao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        DM.Conexao.Rollback;
        // Adicione log detalhado aqui
        OutputDebugString(PChar('Erro no SalvarClientesEmLote: ' + E.Message));
        WriteLn('Erro no SalvarClientesEmLote: ' + E.Message); // Imprime no console
        raise; // Repropaga a exceção para que o MOC app pegue
      end;
    end;
  finally
    Query.Free;
  end;







end;

end.
