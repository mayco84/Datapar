Sistema de Gerenciamento de Clientes
Objetivo
Este sistema permite o gerenciamento completo do cadastro de clientes, incluindo funcionalidades como busca por nome, CPF, e e-mail, além de integração com o serviço de busca de CEP para preencher automaticamente os campos de endereço. Ele também suporta múltiplos bancos de dados, permitindo flexibilidade no armazenamento dos dados.

Sistema desenvolvido em Delphi 12(Community Edition), baseando no principio da arquitetura MVC,sendo assim se faz uso de Orientação a Objetos.
Compilado em 64bits. 

Requisitos do Sistema
Conexão com a Internet: Necessária para acessar o serviço de busca de CEP (ViaCEP).
Conexão com Banco de Dados: É obrigatório para operações de CRUD no sistema.

Estrutura da Base de Dados
Nome da Base de Dados: Datapar
Sistema de Banco de Dados: PostegreSQL 16 ou superiro

Telas dos Sistemas
Cadastro de Cliente: Gerencia informações de clientes.

Campos Obrigatórios:
TipoPessoa, NomeCompleto, DataNascimento, CPF, RG, Email
Campos Opcionais:
Telefone, Endereço, Bairro, Cidade, CEP, Número, Complemento, UF

Tela de Pedido: Armazena pedidos realizados pelos clientes.
Tabela: pedido
id, DataPedido, IdCliente (referenciando a tabela Cliente), Total.

PedidoItens(Tabela para armazenamento de itens do Pedido): Detalha os itens de cada pedido.
Campos:
id, idPedido (referenciando a tabela Pedido), Quantidade, idUnidadeMedida (referenciando a tabela UnidadeMedida), Valor, Total, idProduto (referenciando a tabela Produtos).

Produtos: Registra os produtos disponíveis.

Tabela: produtos
id, idUnidadeMedida (referenciando a tabela UnidadeMedida), DataCadastro, DescricaoProduto, Valor.

UnidadeMedida: Define unidades de medida para produtos e pedidos.

Tabela: unidadedemedida
id, DescricaoUnidadeMedida, SiglaUnidadeMedida, DataCadastro.
Funcionalidades do Sistema

Tela de Pesquisa de Clientes
Filtros de Pesquisa: Código, Nome, e E-mail.
Consulta Detalhada: Exibe informações completas do cliente ao clicar duas vezes em um registro.
Navegação Intuitiva: Exibição de resultados em um grid organizado.

Tela de Cadastro de Clientes
Cadastro Completo: Inclusão, alteração, exclusão e visualização de clientes.
Validação Automática: Campos obrigatórios destacados em vermelho.
Busca por CEP: Preenchimento automático dos campos de endereço.

Tela de Pesquisa de Pedido
Filtros de Pesquisa: Código, Descrição.
Consulta Detalhada: Exibe informações completas do Pedido do Cliente ao clicar duas vezes em um registro.
Navegação Intuitiva: Exibição de resultados em um grid organizado.

Tela de Pedidos
Inserção de Pedidos: Criação de pedidos vinculados a um cliente.
Gerenciamento de Itens: Adicionar, editar ou remover itens do pedido, especificando produto, quantidade, unidade de medida e valores.
Cálculo Automático: Atualização do total do pedido com base nos itens.

Edição e Exclusão: Alterar ou excluir pedidos existentes.


Tela de Pesquisa de Prodto
Filtros de Pesquisa: Código, Descrição.
Consulta Detalhada: Exibe informações completas do Produto ao clicar duas vezes em um registro.
Navegação Intuitiva: Exibição de resultados em um grid organizado.

Tela de Produtos
Cadastro de Produtos: Adicionar novos produtos com descrição, unidade de medida e valor.
Edição e Exclusão: Atualizar ou remover produtos cadastrados.

Tela de Pesquisa de Unidade de Medidas.
Filtros de Pesquisa: Código, Descrição, e Sigla.
Consulta Detalhada: Exibe informações completas da Unidade de Medida ao clicar duas vezes em um registro.
Navegação Intuitiva: Exibição de resultados em um grid organizado.

Tela de Unidades de Medida
Cadastro de Unidades: Inserção de novas unidades com descrição e sigla.
Gerenciamento: Exibição, edição ou exclusão de unidades cadastradas.

