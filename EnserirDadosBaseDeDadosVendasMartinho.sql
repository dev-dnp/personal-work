INSERT INTO Tb_Categoria (Nome) VALUES
('Gestor'),
('Vendedor'),
('Caixa'),
('Logística'),
('Armazém'),
('Supervisor'),
('Administrador'),
('Marketing'),
('Financeiro'),
('RH'),
('Técnico'),
('Operador'),
('Estagiário'),
('Compras'),
('Direção');
GO

INSERT INTO Tb_Cliente (Nome) VALUES
('João Pedro'),
('Maria Silva'),
('Domingos Pedro'),
('Ana Paula'),
('José Manuel'),
('Fátima Sousa'),
('Pedro Gomes'),
('Helena Costa'),
('Rui Miguel'),
('Sandra Lopes'),
('Bruno Silva'),
('Lúcia Fernandes'),
('Tiago Santos'),
('Paulo Mendes'),
('Diana Almeida');
GO

INSERT INTO Tb_Produto (Nome, Descricao, Preco, Estado) VALUES
('Arroz', 'Pacote 1kg', 1500, 1),
('Feijão', 'Pacote 1kg', 2000, 1),
('Açúcar', 'Pacote 1kg', 1200, 1),
('Sal', 'Pacote 1kg', 500, 1),
('Óleo', 'Garrafa 1L', 3000, 1),
('Leite', 'Caixa 1L', 2500, 1),
('Café', 'Pacote 250g', 1800, 1),
('Massa', 'Pacote 500g', 1300, 1),
('Sabão', 'Barra', 900, 1),
('Detergente', '1L', 2200, 1),
('Biscoito', 'Pacote 200g', 1600, 1),
('Refrigerante', '2L', 2800, 1),
('Água', 'Garrafa 1L', 1000, 1),
('Chocolate', 'Barra 100g', 1700, 1),
('Farinha', 'Pacote 1kg', 1900, 1),
('Carne Bovina', 'Kg de carne bovina fresca', 8500, 1),
('Frango Inteiro', 'Frango fresco inteiro', 4500, 1),
('Peito de Frango', 'Kg de peito de frango', 5200, 1),
('Carne Suína', 'Kg de carne de porco', 6000, 1),
('Costela Bovina', 'Kg de costela bovina', 7800, 1),
('Arroz', 'Pacote 1kg de arroz branco', 1500, 1),
('Feijão Preto', 'Pacote 1kg de feijão', 2000, 1),
('Óleo de Cozinha', 'Garrafa 1L', 3000, 1),
('Sal', 'Pacote 1kg de sal refinado', 500, 1),
('Açúcar', 'Pacote 1kg de açúcar branco', 1200, 1),
('Linguiça', 'Kg de linguiça fresca', 4800, 1),
('Ovos', 'Dúzia de ovos frescos', 1800, 1),
('Leite', 'Caixa 1L de leite', 2500, 1),
('Manteiga', 'Tablete 250g', 3200, 1),
('Peixe Fresco', 'Kg de peixe variado', 7000, 1);
GO

INSERT INTO Tb_Funcionario (Nome, Nu_Categoria, Data_Ingresso) VALUES
('João Matos', 1, '2023-01-10'),
('Maria Santos', 2, '2023-02-15'),
('Carlos Pinto', 3, '2023-03-20'),
('Ana Costa', 4, '2023-04-25'),
('José Lima', 5, '2023-05-10'),
('Fátima Dias', 6, '2023-06-18'),
('Pedro Rocha', 7, '2023-07-22'),
('Helena Martins', 8, '2023-08-12'),
('Rui Almeida', 9, '2023-09-05'),
('Sandra Pereira', 10, '2023-10-14'),
('Bruno Gomes', 11, '2023-11-01'),
('Lúcia Ramos', 12, '2023-12-03'),
('Tiago Sousa', 13, '2024-01-08'),
('Paulo Ferreira', 14, '2024-02-11'),
('Diana Carvalho', 15, '2024-03-19');
GO


INSERT INTO Tb_Salario (Salario_Base, Mes, Ano, Nu_Categoria) VALUES
(50000, 1, 2026, 1),
(45000, 1, 2026, 2),
(30000, 1, 2026, 3),
(28000, 1, 2026, 4),
(27000, 1, 2026, 5),
(60000, 1, 2026, 6),
(80000, 1, 2026, 7),
(55000, 1, 2026, 8),
(40000, 1, 2026, 9),
(35000, 1, 2026, 10),
(25000, 1, 2026, 11),
(22000, 1, 2026, 12),
(20000, 1, 2026, 13),
(70000, 1, 2026, 14),
(90000, 1, 2026, 15);
GO

INSERT INTO Tb_Estoque (Nu_Produto, Quantidade) VALUES
(1, 100),
(2, 120),
(3, 80),
(4, 200),
(5, 50),
(6, 60),
(7, 90),
(8, 70),
(9, 300),
(10, 110),
(11, 150),
(12, 40),
(13, 500),
(14, 130),
(15, 75);
GO