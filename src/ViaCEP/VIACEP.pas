unit ViaCEP;

interface

uses
  System.SysUtils, System.Classes, REST.Client, REST.Types, System.JSON;

type
  TViaCEP = class
  private
    FBaseURL: string;
    function RemoverCaracteres(const ATexto: string): string;
    //procedure ValidarCEP(const CEP: string);
  public
    constructor Create;
    function ConsultarCEP(CEP: string): TJSONObject;
  end;

implementation

{ TViaCEP }

constructor TViaCEP.Create;
begin
  FBaseURL := 'https://viacep.com.br/ws/';
end;

function TViaCEP.RemoverCaracteres(const ATexto: string): string;
begin
  Result := StringReplace(ATexto, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

//procedure TViaCEP.ValidarCEP(const CEP: string);
//begin
//  // Verifica se o CEP contém exatamente 8 dígitos numéricos
//  if (Length(CEP) <> 8) or not TryStrToInt(CEP, StrToIntDef(CEP, 0)) then
//    raise Exception.Create('CEP inválido. Certifique-se de digitar um CEP com 8 dígitos numéricos.');
//end;

function TViaCEP.ConsultarCEP(CEP: string): TJSONObject;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSON: TJSONObject;
begin
  Result := nil;

  // Remove caracteres indesejados e valida o CEP
  CEP := RemoverCaracteres(CEP);
  //ValidarCEP(CEP);

  RESTClient := TRESTClient.Create(FBaseURL + CEP + '/json/');
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);

  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Method := rmGET;
    RESTRequest.Execute;

    // Verifica se houve retorno válido
    if RESTResponse.StatusCode = 200 then
    begin
      JSON := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;

      // Verifica se o JSON contém o campo "erro"
      if Assigned(JSON) and JSON.GetValue<Boolean>('erro', False) then
      begin
        JSON.Free;
        raise Exception.Create('CEP não encontrado ou inválido.');
      end;

      Result := JSON; // Retorna o JSON válido
    end
    else
      raise Exception.CreateFmt('Erro ao consultar o CEP: %d - %s',
        [RESTResponse.StatusCode, RESTResponse.StatusText]);
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

end.

