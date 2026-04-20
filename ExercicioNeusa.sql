/*
    Registar o NOME do CLIENTE
    -- Manipular a tabela do CLIENTE
*/

/*
    Registar os PRODUTOS
    -- Registar uma encomenda
    -- Registar os produtos da encomenda
*/






CREATE OR ALTER PROCEDURE sp_processar_fatura
(
    @NomeCliente NVARCHAR(100),
    @NuFuncionario INT,
    @NuProduto INT,
    @QuantidadeProduto INT,
    @EstadoEncomenda INT = 1,
    @Operacao INT 
)
AS
BEGIN

    DECLARE @NuClienteGerado INT;
    DECLARE @NuEncomendaGerado INT;
    DECLARE @EncomendaAberta INT;
    DECLARE @NuEncomendaAberta INT;

    -- Será que existe uma fatura ou encomenda aberta?
    SELECT 
        @EncomendaAberta = COUNT(*), 
        @NuEncomendaAberta = Nu_Encomenda 
    FROM Tb_Encomenda WHERE Estado = 1 GROUP BY Nu_Encomenda;

    -- Caso a operação seja zero (0) vou fechar a fatura
    IF @Operacao = 0
    BEGIN
        UPDATE Tb_Encomenda SET Estado = 0 WHERE Nu_Encomenda = @NuEncomendaAberta;
        RETURN;
    END

    IF @EncomendaAberta = 0
    BEGIN
        -- Registar o cliente
        INSERT INTO Tb_Cliente(Nome) VALUES (@NomeCliente);

        SET @NuClienteGerado = SCOPE_IDENTITY();

        -- Criar encomenda (fatura)
        INSERT INTO Tb_Encomenda(Nu_Cliente, Nu_Funcionario, Estado)
        VALUES (@NuClienteGerado, @NuFuncionario, @EstadoEncomenda)

        SET @NuEncomendaGerado = SCOPE_IDENTITY();

        -- Registar os produtos no carrinho
        INSERT INTO Tb_Detalhe_Encomenda(Nu_Encomenda, Nu_Produto, Quantidade)
        VALUES (@NuEncomendaGerado, @NuProduto, @QuantidadeProduto)
    END
    ELSE 
    BEGIN

        -- Procurar se o produto já existe na tabela de detalhe de encomenda
        DECLARE @ProdutoExistente INT;

        SELECT 
            @ProdutoExistente = COUNT(*)
        FROM Tb_Detalhe_Encomenda 
        WHERE Nu_Encomenda = @NuEncomendaAberta AND Nu_Produto = @NuProduto;

        IF @ProdutoExistente = 0
        BEGIN
            -- Inserir novo produto, porque ainda nao existe na lista
            INSERT INTO Tb_Detalhe_Encomenda(Nu_Encomenda, Nu_Produto, Quantidade)
            VALUES (@NuEncomendaAberta, @NuProduto, @QuantidadeProduto)
        END
        ELSE
        BEGIN
            -- Atualizar a quantidade do produto
            UPDATE Tb_Detalhe_Encomenda 
            SET Quantidade = Quantidade + @QuantidadeProduto
            WHERE Nu_Encomenda = @NuEncomendaAberta;
        END

    END
    
END




EXECUTE sp_processar_fatura 
    @NomeCliente = 'Neusa Mujinga', 
    @NuFuncionario = 2, 
    @NuProduto = 10, 
    @QuantidadeProduto = 33,
    @Operacao = 1
GO

SELECT * FROM Tb_Cliente;
SELECT * FROM Tb_Encomenda;
SELECT * FROM Tb_Detalhe_Encomenda;




SELECT * FROM Tb_Funcionario;
SELECT * FROM Tb_Produto;

SELECT * FROM Tb_Cliente;
SELECT * FROM Tb_Encomenda;
SELECT * FROM Tb_Detalhe_Encomenda;

DELETE FROM Tb_Detalhe_Encomenda;
DELETE FROM Tb_Encomenda;
DELETE FROM Tb_Cliente;