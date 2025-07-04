unit IViewPesquisarUnidadeMedida;

interface

uses
  Data.DB;  // Importante para o TDataSet

 type
  IPesquisarUnidadeMedida = interface
   ['{4B1DF01B-E849-4A40-ADBB-A664F7416225}'] // ID único para a interface
    procedure AtualizarGrid(ADataSet: TDataSet);  // Defina o método que a View implementará
  end;

implementation

end.
