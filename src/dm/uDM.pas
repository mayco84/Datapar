unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.IniFiles, Windows, Messages,Dialogs, Graphics,  Controls, Forms,
  ExtCtrls,  DBCtrls, StrUtils, ShellAPI,Registry, Tlhelp32,  Math, IdHTTP,
  DBXJson, XMLDoc, FireDAC.Phys.PG, FireDAC.Phys.PGDef,system.UITypes,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TDM = class(TDataModule)
    pgDrive: TFDPhysPgDriverLink;
    Conexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
    FCodUsuario:integer;
    sPath, sNomeIni,sSenhaBanco: string;//path caminho, nomeini nome do exe
  end;

var
  DM: TDM;

implementation

{$R *.dfm}



procedure TDM.DataModuleCreate(Sender: TObject);
begin
  try
    Conexao.Connected := True;
  except
    on E: Exception do
    begin

      ShowMessage('Erro ao conectar ao banco de dados: É necessário apontar corretamente a Base de Dados ');
      Application.Terminate;
    end;
  end;
end;

end.
