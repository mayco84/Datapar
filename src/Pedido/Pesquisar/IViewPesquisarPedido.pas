unit IViewPesquisarPedido;

interface

uses
  Data.DB;  // Importante para o TDataSet

 type
  IPesquisarPedido = interface
  ['{59D60D8E-EBBD-4D67-9035-70EE40A585B2}'] // ID único para a interface
    procedure AtualizarGrid(ADataSet: TDataSet);  // Defina o método que a View implementará
  end;

implementation

end.
