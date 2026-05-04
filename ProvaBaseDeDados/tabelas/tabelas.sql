
USE master;
GO
DROP DATABASE IF EXISTS vendas_domingos;
GO
CREATE DATABASE vendas_domingos;
GO
USE vendas_domingos;
GO



CREATE TABLE Tb_Categoria (
    Nu_Categoria INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE Tb_Salario (
    Nu_Salario INT PRIMARY KEY IDENTITY(1,1),
    Salario_Base DECIMAL(10, 2) NOT NULL,
    Mes INT NOT NULL,
    Ano INT NOT NULL,
    Nu_Categoria INT NOT NULL,

    CONSTRAINT FK_NuCategoria_TbSalario
        FOREIGN KEY (Nu_Categoria) REFERENCES Tb_Categoria(Nu_Categoria),

    CONSTRAINT UQ_NuCategoriaMesAno_TbSalario
        UNIQUE (Nu_Categoria, Mes, Ano),

    CONSTRAINT CK_MesEntraUmEDoze_TbSalario
        CHECK (Mes BETWEEN 1 AND 12)
);
GO

CREATE TABLE Tb_Cliente (
    Nu_Cliente INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Estado BIT DEFAULT 1 NOT NULL,
    Data_Registo DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Tb_Funcionario (
    Nu_Funcionario INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Nu_Categoria INT NOT NULL,
    Data_Ingresso DATETIME NOT NULL,
    Estado BIT DEFAULT 1,

    CONSTRAINT FK_NuCategoria_TbFuncionario
        FOREIGN KEY (Nu_Categoria) REFERENCES Tb_Categoria(Nu_Categoria)
);
GO

CREATE TABLE Tb_Produto (
    Nu_Produto INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Descricao NVARCHAR(255) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    Estado BIT DEFAULT 1,

    CONSTRAINT CK_PrecoMaiorQueZero_TbProduto 
        CHECK (Preco > 0)
);
GO

CREATE TABLE Tb_Encomenda (
    Nu_Encomenda INT PRIMARY KEY IDENTITY(1,1),
    Nu_Cliente INT NOT NULL,
    Nu_Funcionario INT NOT NULL,
    Estado BIT DEFAULT 1,
    Data_Registo DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_NuCliente_TbEncomenda
        FOREIGN KEY (Nu_Cliente) REFERENCES Tb_Cliente(Nu_Cliente),

    CONSTRAINT FK_NuFuncionario_TbEncomenda 
        FOREIGN KEY (Nu_Funcionario) REFERENCES Tb_Funcionario(Nu_Funcionario)
);
GO

CREATE TABLE Tb_Detalhe_Encomenda (
    Nu_Encomenda INT NOT NULL,
    Nu_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Preco_Unitario DECIMAL(10,2) NOT NULL,
    Estado BIT DEFAULT 1,

    CONSTRAINT PK_NuEncomendaNuProduto_TbDetalheEncomenda 
        PRIMARY KEY (Nu_Encomenda, Nu_Produto),

    CONSTRAINT FK_NuEncomenda_TbDetalheEncomenda 
        FOREIGN KEY (Nu_Encomenda) REFERENCES Tb_Encomenda(Nu_Encomenda),

    CONSTRAINT FK_NuProduto_TbDetalheProduto 
        FOREIGN KEY (Nu_Produto) REFERENCES Tb_Produto(Nu_Produto),

    CONSTRAINT CK_QuantidadeMaiorQueZero_TbDetalheEncomenda
        CHECK (Quantidade > 0)
);
GO


CREATE TABLE Tb_Fornecedor
(
    Nu_Fornecedor INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL,
    Nif VARCHAR(20) NOT NULL UNIQUE,
    Email VARCHAR(200) NOT NULL UNIQUE,
    Contato NVARCHAR(200) NOT NULL,
    Data_Registo DATETIME DEFAULT GETDATE()

);
GO

CREATE TABLE Tb_Fornecedor_Produto
(
    Nu_Fornecedor INT NOT NULL,
    Nu_Produto INT NOT NULL,
    Preco_Custo DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (Nu_Fornecedor, Nu_Produto),
    
    CONSTRAINT FK_NuFornecedor_TbFornecedorProduto
        FOREIGN KEY (Nu_Fornecedor) REFERENCES Tb_Fornecedor(Nu_Fornecedor),
    
    CONSTRAINT FK_NuProduto_TbFornecedorProduto
        FOREIGN KEY (Nu_Produto) REFERENCES Tb_Produto(Nu_Produto)

);
GO


CREATE TABLE Tb_Estoque (
    Nu_Produto INT NOT NULL,
    Quantidade INT NOT NULL,

    CONSTRAINT FK_NuProduto_TbEstoque
        FOREIGN KEY (Nu_Produto)
        REFERENCES Tb_Produto(Nu_Produto),

    CONSTRAINT CK_QuantidadeMaiorOuIgualAZero_TbEstoque
        CHECK (Quantidade >= 0)
);
GO

CREATE TABLE Tb_Movimentacao_Estoque (
    Nu_Movimento INT PRIMARY KEY IDENTITY(1,1),
    Nu_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Tipo NVARCHAR(20) NOT NULL,
    Nu_Funcionario INT NOT NULL,
    Nu_Fornecedor INT,
    Preco DECIMAL(10,2),
    Estado BIT DEFAULT 1,


    Data DATETIME DEFAULT GETDATE(),

    CONSTRAINT CK_TipoDeEntrada_TbMovimentoEstoque
        CHECK (Tipo IN ('ENTRADA', 'SAIDA', 'AJUSTE', 'DEVOLUCAO')),

    CONSTRAINT CK_QuantidadeMaiorOuIgualAZero_TbMovimentoEstoque
        CHECK (Quantidade >= 0),

    CONSTRAINT FK_NuFuncionario_TbMovimentoEstoque
        FOREIGN KEY (Nu_Funcionario) REFERENCES Tb_Funcionario(Nu_Funcionario),
    
    CONSTRAINT FK_NuFornecedor_TbMovimentoEstoque
        FOREIGN KEY (Nu_Fornecedor) REFERENCES Tb_Fornecedor(Nu_Fornecedor),

    CONSTRAINT FK_NuProduto_MovimentoEstoque
        FOREIGN KEY (Nu_Produto)
        REFERENCES Tb_Produto(Nu_Produto)
);
GO