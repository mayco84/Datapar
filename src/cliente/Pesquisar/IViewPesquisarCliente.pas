unit IViewPesquisarCliente;

interface

uses
  Data.DB;  // Importante para o TDataSet

type
  IViewPesquisarClientes = interface
    ['{D636C005-C68A-4469-B002-36A9F61C936D}'] // ID único para a interface
    procedure AtualizarGrid(ADataSet: TDataSet);  // Defina o método que a View implementará
  end;

implementation

end.

