program GDC;

uses
  Vcl.Forms,
  Principal in 'src\Principal.pas' {frmPrincipal},
  uDM in 'src\DM\uDM.pas' {DM: TDataModule},
  ViewUnidadeMedida in 'src\UnidadesMedidas\Cadastro\ViewUnidadeMedida.pas' {frmUnidadeMedida},
  VIACEP in 'src\ViaCEP\VIACEP.pas',
  ControllerCliente in 'src\Cliente\Cadastro\ControllerCliente.pas',
  ModelCliente in 'src\Cliente\Cadastro\ModelCliente.pas',
  ViewPesquisarCliente in 'src\Cliente\Pesquisar\ViewPesquisarCliente.pas' {frmPesquisarClientes},
  ModelPesquisarCliente in 'src\Cliente\Pesquisar\ModelPesquisarCliente.pas',
  ControllerPesquisarCliente in 'src\Cliente\Pesquisar\ControllerPesquisarCliente.pas',
  IViewPesquisarCliente in 'src\Cliente\Pesquisar\IViewPesquisarCliente.pas',
  ControllerUnidadeMedida in 'src\UnidadesMedidas\Cadastro\ControllerUnidadeMedida.pas',
  ModelUnidadeMedida in 'src\UnidadesMedidas\Cadastro\ModelUnidadeMedida.pas',
  ViewCliente in 'src\Cliente\Cadastro\ViewCliente.pas' {frmCliente},
  ControllerPesquisarUnidadeMedida in 'src\UnidadesMedidas\Pesquisar\ControllerPesquisarUnidadeMedida.pas',
  ModelPesquisarUnidadeMedida in 'src\UnidadesMedidas\Pesquisar\ModelPesquisarUnidadeMedida.pas',
  IViewPesquisarUnidadeMedida in 'src\UnidadesMedidas\Pesquisar\IViewPesquisarUnidadeMedida.pas',
  ViewPesquisarUnidadeMedida in 'src\UnidadesMedidas\Pesquisar\ViewPesquisarUnidadeMedida.pas' {frmPesquisarUnidadeMedida},
  ControllerProdutos in 'src\Produtos\Cadastro\ControllerProdutos.pas',
  ModelProdutos in 'src\Produtos\Cadastro\ModelProdutos.pas',
  ViewProdutos in 'src\Produtos\Cadastro\ViewProdutos.pas' {frmProdutos},
  ControllerPesquisarProdutos in 'src\Produtos\Pesquisar\ControllerPesquisarProdutos.pas',
  IViewPesquisarProdutos in 'src\Produtos\Pesquisar\IViewPesquisarProdutos.pas',
  ModelPesquisarProdutos in 'src\Produtos\Pesquisar\ModelPesquisarProdutos.pas',
  ViewPesquisarProdutos in 'src\Produtos\Pesquisar\ViewPesquisarProdutos.pas' {frmPesquisarProdutos},
  ViewPedidos in 'src\Pedido\Cadastro\ViewPedidos.pas' {frmPedido},
  ModelPedido in 'src\Pedido\Cadastro\ModelPedido.pas',
  ControllerPedido in 'src\Pedido\Cadastro\ControllerPedido.pas',
  ControllerPesquisarPedido in 'src\Pedido\Pesquisar\ControllerPesquisarPedido.pas',
  IViewPesquisarPedido in 'src\Pedido\Pesquisar\IViewPesquisarPedido.pas',
  ModelPesquisarPedido in 'src\Pedido\Pesquisar\ModelPesquisarPedido.pas',
  ViewPesquisarPedido in 'src\Pedido\Pesquisar\ViewPesquisarPedido.pas' {frmPesquisarPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDM, DM);

  Application.Run;
end.
