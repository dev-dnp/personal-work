

CREATE TABLE Tb_Categoria (
    Nu_Categoria INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL
);

CREATE TABLE Tb_Salario (
    Nu_Salario INT PRIMARY KEY IDENTITY(1,1),
    Salario_Base DECIMAL(10, 2) NOT NULL,
    Mes INT NOT NULL,
    Ano INT NOT NULL,
    Nu_Categoria INT NOT NULL,

    CONSTRAINT FK_Salario_Categoria 
        FOREIGN KEY (Nu_Categoria) 
        REFERENCES Tb_Categoria(Nu_Categoria),

    CONSTRAINT UQ_Salario
        UNIQUE (Nu_Categoria, Mes, Ano)
);

CREATE TABLE Tb_Cliente (
    Nu_Cliente INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Estado BIT DEFAULT 1 NOT NULL,
    Data_Registo DATETIME DEFAULT GETDATE()
);

CREATE TABLE Tb_Funcionario (
    Nu_Funcionario INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Nu_Categoria INT NOT NULL,
    Data_Ingresso DATETIME NOT NULL,
    Estado BIT DEFAULT 1,

    CONSTRAINT FK_Funcionario_Categoria 
        FOREIGN KEY (Nu_Categoria) 
        REFERENCES Tb_Categoria(Nu_Categoria)
);

CREATE TABLE Tb_Produto (
    Nu_Produto INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Descricao NVARCHAR(255) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    Estado BIT DEFAULT 1,

    CONSTRAINT CK_Produto_Preco 
        CHECK (Preco > 0)
);

CREATE TABLE Tb_Encomenda (
    Nu_Encomenda INT PRIMARY KEY IDENTITY(1,1),
    Nu_Cliente INT NOT NULL,
    Nu_Funcionario INT NOT NULL,
    Estado BIT DEFAULT 1,
    Data_Registo DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Encomenda_Cliente 
        FOREIGN KEY (Nu_Cliente) 
        REFERENCES Tb_Cliente(Nu_Cliente),

    CONSTRAINT FK_Encomenda_Funcionario 
        FOREIGN KEY (Nu_Funcionario) 
        REFERENCES Tb_Funcionario(Nu_Funcionario)
);

CREATE TABLE Tb_Detalhe_Encomenda (
    Nu_Encomenda INT NOT NULL,
    Nu_Produto INT NOT NULL,
    Quantidade INT NOT NULL CHECK (Quantidade > 0),
    Estado BIT DEFAULT 1,

    CONSTRAINT PK_Detalhe_Encomenda 
        PRIMARY KEY (Nu_Encomenda, Nu_Produto),

    CONSTRAINT FK_Detalhe_Encomenda 
        FOREIGN KEY (Nu_Encomenda) 
        REFERENCES Tb_Encomenda(Nu_Encomenda),

    CONSTRAINT FK_Detalhe_Produto 
        FOREIGN KEY (Nu_Produto) 
        REFERENCES Tb_Produto(Nu_Produto)
);

CREATE TABLE Tb_Estoque (
    Nu_Produto INT NOT NULL PRIMARY KEY,
    Quantidade INT NOT NULL,

    CONSTRAINT FK_Produto_Estoque
        FOREIGN KEY (Nu_Produto)
        REFERENCES Tb_Produto(Nu_Produto),

    CONSTRAINT CK_Estoque_Quantidade_Positiva
        CHECK (Quantidade >= 0)
);

-- CREATE TABLE Tb_Movimentacao_Estoque (
--     Nu_Movimentacao INT PRIMARY KEY IDENTITY(1,1),
--     Nu_Produto INT NOT NULL,
--     Tipo NVARCHAR(20) NOT NULL,
--     Quantidade INT,
--     Estado BIT DEFAULT 1,
--     Data DATETIME DEFAULT GETDATE(),

--     CONSTRAINT CK_Movimentacao_Quantidade_Positiva
--         CHECK (Quantidade >= 0),

--     CONSTRAINT FK_Produto_Movimentacao_Estoque
--         FOREIGN KEY (Nu_Produto)
--         REFERENCES Tb_Produto(Nu_Produto)
-- );