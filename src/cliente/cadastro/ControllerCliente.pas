unit ControllerCliente;

interface

uses
  System.SysUtils, System.StrUtils,  Vcl.Controls, System.Classes, Vcl.StdCtrls,Vcl.ExtCtrls,
  Winapi.Windows, Winapi.Messages,System.Variants,  Vcl.Graphics,ModelCliente,Vcl.Mask,
  Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids ;

type
  TControllerCliente = class
  private
    FCliente: TClienteModel;
    function RemoverCaracteres(const ATexto: string): string;
    function SoNumero(texto: string): string;

  public
    constructor Create;
    destructor Destroy; override;
    function ValidaCpfCnpj(Documento: string): Boolean;
    function CarregarClientePorID(ClienteID: Integer): TClienteModel;
    procedure LimparComponentes(Container: TWinControl);  // Usa a interface, não a classe diretamente
    procedure ValidarCampos(const NomeCompleto, DataNascimento, RG, Documento, Telefone,
                              Email, Endereco, Bairro, Cidade, UF, Numero, CEP: TCustomEdit;
                              const TipoPessoa,FisicaJuridica: TRadioGroup);
  end;

implementation

{ TControllerCliente }

constructor TControllerCliente.Create;
begin
  FCliente := TClienteModel.Create;
end;

destructor TControllerCliente.Destroy;
begin
  FCliente.Free;
  inherited;
end;

function TControllerCliente.RemoverCaracteres(const ATexto: string): string;
begin
  Result := ATexto.Replace('.', '').Replace('-', '').Replace('/', '').Trim;
end;


function TControllerCliente.SoNumero(texto: string): string;
Var
  x: Integer;
  Aux: string;
begin
  Aux := '';
  for x := 1 to Length(texto) do
  begin
    if texto[x] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
      Aux := Aux + texto[x];
  End;
  Result := Aux;

end;

function TControllerCliente.ValidaCpfCnpj(Documento: string): Boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12: Integer;
  d1, d2: Integer;
  digitado, calculado: string;
begin
  Documento := SoNumero(Documento);
  if Length(Documento) = 14 then
  //verificando cnpj
  begin
    if Documento = StringOfChar('0', 14) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('1', 14) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('2', 14) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('3', 14) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('4', 14) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('5', 14) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('6', 14) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('7', 14) then
     raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('8', 14) then
     raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('9', 14) then
      raise Exception.Create('CNPJ informado está errado');

    n1 := StrToInt(Documento[1]);
    n2 := StrToInt(Documento[2]);
    n3 := StrToInt(Documento[3]);
    n4 := StrToInt(Documento[4]);
    n5 := StrToInt(Documento[5]);
    n6 := StrToInt(Documento[6]);
    n7 := StrToInt(Documento[7]);
    n8 := StrToInt(Documento[8]);
    n9 := StrToInt(Documento[9]);
    n10 := StrToInt(Documento[10]);
    n11 := StrToInt(Documento[11]);
    n12 := StrToInt(Documento[12]);
    d1 := n12 * 2 + n11 * 3 + n10 * 4 + n9 * 5 + n8 * 6 + n7 * 7 + n6 * 8 + n5
      * 9 + n4 * 2 + n3 * 3 + n2 * 4 + n1 * 5;
    d1 := 11 - (d1 mod 11);
    if d1 >= 10 then
      d1 := 0;
    d2 := d1 * 2 + n12 * 3 + n11 * 4 + n10 * 5 + n9 * 6 + n8 * 7 + n7 * 8 + n6
      * 9 + n5 * 2 + n4 * 3 + n3 * 4 + n2 * 5 + n1 * 6;
    d2 := 11 - (d2 mod 11);
    if d2 >= 10 then
      d2 := 0;
    calculado := inttostr(d1) + inttostr(d2);
    digitado := Documento[13] + Documento[14];
    if calculado = digitado then
      ValidaCpfCnpj := true
    else
    begin
      ValidaCpfCnpj := false;
      raise Exception.Create('CNPJ informado está errado');
    end;

  end
  else if Length(Documento) = 11 then
  //verificando cpf
  begin

    if Documento = StringOfChar('0', 11) then
      raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('1', 11) then
      raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('2', 11) then
      raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('3', 11) then
      raise Exception.Create('CNPJ informado está errado');

    if Documento = StringOfChar('4', 11) then
      raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('5', 11) then
      raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('6', 11) then
      raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('7', 11) then
     raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('8', 11) then
     raise Exception.Create('CPF informado está errado');

    if Documento = StringOfChar('9', 11) then
      raise Exception.Create('CPF informado está errado');

    n1 := StrToInt(Documento[1]);
    n2 := StrToInt(Documento[2]);
    n3 := StrToInt(Documento[3]);
    n4 := StrToInt(Documento[4]);
    n5 := StrToInt(Documento[5]);
    n6 := StrToInt(Documento[6]);
    n7 := StrToInt(Documento[7]);
    n8 := StrToInt(Documento[8]);
    n9 := StrToInt(Documento[9]);
    d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 *
      9 + n1 * 10;
    d1 := 11 - (d1 mod 11);
    if d1 >= 10 then
      d1 := 0;
    d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 *
      9 + n2 * 10 + n1 * 11;
    d2 := 11 - (d2 mod 11);
    if d2 >= 10 then
      d2 := 0;
    calculado := inttostr(d1) + inttostr(d2);
    digitado := Documento[10] + Documento[11];
    if calculado = digitado then
      ValidaCpfCnpj := true
    else
    begin
      ValidaCpfCnpj := false;
      raise Exception.Create('CPF informado está errado');
    end;
  end
  else
  begin
    ValidaCpfCnpj := false;
    raise Exception.Create('Favor informar um CPF/CNPJ válido.');
  end;

end;

procedure TControllerCliente.ValidarCampos(const NomeCompleto, DataNascimento, RG, Documento, Telefone,
                              Email, Endereco, Bairro, Cidade, UF, Numero, CEP: TCustomEdit;
                              const TipoPessoa,FisicaJuridica: TRadioGroup);
var
  DataConvertida: TDateTime;
begin

  // Data de Nascimento
  if not TryStrToDate(DataNascimento.Text, DataConvertida) then
  begin
    DataNascimento.SetFocus;
    raise Exception.Create('Data de nascimento inválida.');
  end;

    // Tipo de Pessoa
  if TipoPessoa.ItemIndex = -1 then
  begin
    TipoPessoa.SetFocus;
    raise Exception.Create('É necessário selecionar o tipo de pessoa.');
  end;

  //Pessoa Fisisca ou Juridica
  if FisicaJuridica.ItemIndex = -1 then
  begin
    FisicaJuridica.SetFocus;
    raise Exception.Create('É necessário selecionar se é Física ou Jurídica.');
  end;

  // Nome Completo
  if NomeCompleto.Text = '' then
  begin
    NomeCompleto.SetFocus;
    raise Exception.Create('O nome completo é obrigatório.');
  end;

  // RG
  if RG.Text = '' then
  begin
    RG.SetFocus;
    raise Exception.Create('O R.G. é  obrigatório.');
  end;

  // Documento (CPF ou CNPJ)
  if Documento.Text = '___.___.___-__' then
  begin
    Documento.SetFocus;
    raise Exception.Create('Informe um CPF.');
  end
  else if Documento.Text = '__.___.___/____' then
  begin
    Documento.SetFocus;
    raise Exception.Create('Informe um CNPJ.');
  end;

  ValidaCpfCnpj(Documento.Text);

  // Telefone
  if Telefone.Text = '' then
  begin
    Telefone.SetFocus;
    raise Exception.Create('O telefone é obrigatório.');
  end;

  // E-mail
  if (Email.Text <> '') and ((Pos('@', Email.Text) = 0) or (Pos('.', Email.Text) = 0)) then
  begin
    Email.SetFocus;
    raise Exception.Create('E-mail inválido.');
  end;

  // Endereço
  if Endereco.Text = '' then
  begin
    Endereco.SetFocus;
    raise Exception.Create('O endereço é obrigatório.');
  end;

    // Número
  if Numero.Text = '' then
  begin
    Numero.SetFocus;
    raise Exception.Create('O número é obrigatório.');
  end;

  // Bairro
  if Bairro.Text = '' then
  begin
    Bairro.SetFocus;
    raise Exception.Create('O bairro é obrigatório.');
  end;

  // Cidade
  if Cidade.Text = '' then
  begin
    Cidade.SetFocus;
    raise Exception.Create('A cidade é obrigatória.');
  end;

  // UF
  if Length(Trim(UF.Text)) <> 2 then
  begin
    UF.SetFocus;
    raise Exception.Create('UF inválido. Informe uma sigla com exatamente 2 caracteres.');
  end;



  // CEP
  if Length(RemoverCaracteres(CEP.Text)) <> 8 then
  begin
    CEP.SetFocus;
    raise Exception.Create('CEP inválido.');
  end;

end;

function TControllerCliente.CarregarClientePorID(ClienteID: Integer): TClienteModel;
begin
  // Carrega os dados do cliente a partir do banco de dados ou outra fonte usando o método BuscarPorID
  Result := FCliente.BuscarPorID(ClienteID);

  if Result = nil then
    raise Exception.Create('Cliente não encontrado.');
end;

procedure TControllerCliente.LimparComponentes(Container: TWinControl);
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

