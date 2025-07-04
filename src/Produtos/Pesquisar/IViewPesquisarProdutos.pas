unit IViewPesquisarProdutos;

interface

uses
  Data.DB;  // Importante para o TDataSet

 type
  IPesquisarProdutos = interface
  ['{C58E40D6-ABE4-4865-B3E8-9FF5C83E80D8}'] // ID único para a interface
    procedure AtualizarGrid(ADataSet: TDataSet);  // Defina o método que a View implementará
  end;

implementation

end.
