unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, ViewPesquisarProdutos,
  Vcl.Buttons,ViewCliente,ViewPesquisarCliente,ViewPesquisarUnidadeMedida,ViewPedidos,ViewPesquisarPedido;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    btnCadastro: TSpeedButton;
    popCadastros: TPopupMenu;
    Clientes1: TMenuItem;
    Unidade1: TMenuItem;
    Produto1: TMenuItem;
    btnPedidos: TSpeedButton;
    popPedidos: TPopupMenu;
    Pedidos1: TMenuItem;
    PesuisarPedidos1: TMenuItem;
    procedure btnCadastroClick(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure Unidade1Click(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure Pedidos1Click(Sender: TObject);
    procedure btnPedidosClick(Sender: TObject);
    procedure PesuisarPedidos1Click(Sender: TObject);
  private
    procedure menuPersonalizado(Botao: TSpeedButton; Pop: TPopupMenu);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnCadastroClick(Sender: TObject);
begin
    menuPersonalizado(btnCadastro,popCadastros);
end;

procedure TfrmPrincipal.btnPedidosClick(Sender: TObject);
begin
  menuPersonalizado(btnPedidos,popPedidos)
end;

procedure TfrmPrincipal.Clientes1Click(Sender: TObject);
var
  lTelaCliente : TfrmPesquisarClientes;
begin
  lTelaCliente := TfrmPesquisarClientes.Create(nil);
  try
    lTelaCliente.ModoTela := mcConsultaC;
    lTelaCliente.ShowModal;
  finally
    FreeAndNil(lTelaCliente)
  end;
end;

procedure TfrmPrincipal.menuPersonalizado(Botao: TSpeedButton; Pop: TPopupMenu);
var
  vPonto: TPoint;
begin
  vPonto := Botao.ClientToScreen(Point(0, Botao.Height));
  Pop.Popup(vPonto.X+100, vPonto.Y-15);
end;

procedure TfrmPrincipal.Pedidos1Click(Sender: TObject);
var
  lTelaPedido : TfrmPedido;
begin
  lTelaPedido := TfrmPedido.Create(nil);
  try
    lTelaPedido.ShowModal;
  finally
    FreeAndNil(lTelaPedido) ;
  end;
end;

procedure TfrmPrincipal.PesuisarPedidos1Click(Sender: TObject);
var
  lTelaPesquisaPedido : tfrmPesquisarPedido;
begin
  lTelaPesquisaPedido := TfrmPesquisarPedido.Create(nil);
  try
    lTelaPesquisaPedido.ShowModal;
  finally
    FreeAndNil(lTelaPesquisaPedido);
  end;

end;

procedure TfrmPrincipal.Produto1Click(Sender: TObject);
var
 lTelaProdutos : TfrmPesquisarProdutos;
begin
  lTelaProdutos := TfrmPesquisarProdutos.Create(nil);
  try
    lTelaProdutos.ModoTela := mcConsulta;
    lTelaProdutos.ShowModal;
  finally
    FreeAndNil(lTelaProdutos) ;
  end;
end;

procedure TfrmPrincipal.Unidade1Click(Sender: TObject);
var
  lTelaUnidade : TfrmPesquisarUnidadeMedida;
begin
  lTelaUnidade := TfrmPesquisarUnidadeMedida.Create(nil);
  try
    lTelaUnidade.ShowModal;
  finally
    FreeAndNil(lTelaUnidade)
  end;

end;

end.
