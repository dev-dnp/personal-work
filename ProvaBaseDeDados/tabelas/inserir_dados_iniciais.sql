USE vendas_domingos;
GO

-- Tb_Categoria
INSERT INTO Tb_Categoria (Nome) VALUES
('Gerente'),
('Supervisor'),
('Vendedor'),
('Técnico'),
('Administrativo');

-- Tb_Salario
INSERT INTO Tb_Salario (Salario_Base, Mes, Ano, Nu_Categoria) VALUES
(250000.00, 1, 2025, 1),
(180000.00, 1, 2025, 2),
(120000.00, 1, 2025, 3),
(150000.00, 1, 2025, 4),
(130000.00, 1, 2025, 5);


-- Tb_Funcionario
INSERT INTO Tb_Funcionario (Nome, Nu_Categoria, Data_Ingresso, Estado) VALUES
('Evaney Matadi',   1, '2020-03-15', 1),
('Aristides Félix',    2, '2019-07-01', 1),
('Severina Elísio',  3, '2021-11-20', 1),
('Gelson Clemente',   4, '2022-05-10', 1)


-- Tb_Produto
INSERT INTO Tb_Produto (Nome, Descricao, Preco, Estado) VALUES
('Leite UHT Integral 1L',      'Leite longa vida integral',                    1100.00, 1),
('Leite em Pó 400g',           'Leite em pó integral',                         2800.00, 1),
('Massa Esparguete 500g',      'Massa de trigo duro tipo esparguete',           450.00, 1),
('Atum em Lata 170g',          'Atum em óleo vegetal',                          800.00, 1),
('Sardinha em Lata 125g',      'Sardinha em molho de tomate',                   600.00, 1),
('Manteiga 200g',              'Manteiga de origem animal com sal',            1200.00, 1),
('Café Moído 250g',            'Café angolano torrado e moído',                1500.00, 1),
('Sal Refinado 1kg',           'Sal iodado refinado',                           300.00, 1),
('Molho de Tomate 500g',       'Molho de tomate concentrado',                   750.00, 1),
('Azeite Extra Virgem 500ml',  'Azeite de oliva extra virgem importado',       3500.00, 1),
('Óleo de Palma 1L',           'Óleo de palma refinado',                        950.00, 1),
('Farinha de Milho 2kg',       'Fuba de milho para pirão e outros pratos',      850.00, 1),
('Flocos de Aveia 500g',       'Aveia em flocos finos',                        1200.00, 1),
('Biscoito Água e Sal 200g',   'Biscoito salgado tipo cracker',                 550.00, 1),
('Leite Condensado 395g',      'Leite condensado adoçado',                      650.00, 1),
('Ovos Brancos (12 unid.)',    'Ovos de galinha brancos categoria A',          2200.00, 1),
('Carne de Vaca 1kg',          'Carne bovina para guisado',                    4500.00, 1),
('Camarão Congelado 500g',     'Camarão médio congelado',                      3800.00, 1),
('Peixe Seco 500g',            'Peixe seco e salgado tradicional',             2000.00, 1),
('Detergente Líquido 500ml',   'Detergente para loiça concentrado',             900.00, 1);


-- Tb_Fornecedor
INSERT INTO Tb_Fornecedor (Nome, Nif, Email, Contato) VALUES
('Distribuidora Luanda Lda.',  '5417001234', 'geral@distroluanda.co.ao',   '+244 923 111 222'),
('Importadora Angola Sul',     '5417005678', 'comercial@angolasul.co.ao',  '+244 912 333 444'),
('Armazéns Norte Lda.',        '5417009012', 'vendas@armazensnorte.co.ao', '+244 933 555 666'),
('Global Trade Angola',        '5417003456', 'info@globaltrade.co.ao',     '+244 944 777 888'),
('Fornecimentos Kwanza Lda.',  '5417007890', 'geral@kwanzaforn.co.ao',     '+244 922 999 000'),
('Mercearia Central Lda.',      '5417011111', 'geral@mercecentral.co.ao',    '+244 923 100 200'),
('Importadora Benguela',        '5417022222', 'vendas@impbenguela.co.ao',    '+244 912 300 400'),
('Armazéns Huambo Lda.',        '5417033333', 'comercial@armhuambo.co.ao',   '+244 933 500 600'),
('Distribuidora Cabinda',       '5417044444', 'info@distcabinda.co.ao',      '+244 944 700 800'),
('Fornecimentos Malanje Lda.',  '5417055555', 'geral@fornmalanje.co.ao',     '+244 922 900 100');


-- Tb_Fornecedor_Produto
INSERT INTO Tb_Fornecedor_Produto (Nu_Fornecedor, Nu_Produto, Preco_Custo) VALUES
( 1,  1,  900.00),
( 1,  2, 2300.00),
( 2,  3,  350.00),
( 2,  4,  600.00),
( 3,  5, 2900.00),
( 3,  6,  780.00),
( 4,  7,  680.00),
( 4,  8,  950.00),
( 5,  9,  420.00),
( 5, 10,  500.00),
( 6, 11, 1800.00),
( 6, 12, 3800.00),
( 7, 13, 3100.00),
( 7, 14, 1600.00),
( 8, 15,  720.00),
( 8, 16,  850.00),
( 9, 17,  370.00),
( 9, 18, 2300.00),
(10, 19, 1000.00),
(10, 20, 1750.00);
