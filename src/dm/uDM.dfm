object DM: TDM
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object pgDrive: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files\PostgreSQL\16\bin\libpq.dll'
    Left = 144
    Top = 40
  end
  object Conexao: TFDConnection
    Params.Strings = (
      'Port='
      'Server='
      'Database=Datapar'
      'User_Name=postgres'
      'Password=Sandra2015;'
      'DriverID=PG')
    LoginPrompt = False
    Left = 56
    Top = 48
  end
end
