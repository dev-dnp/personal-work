
CREATE OR ALTER PROCEDURE sp_venda
(
    -- PARAMÊTROS
    @NomeCliente NVARCHAR(100),
    @NuProduto INT,
    @QuantidadeProduto INT,
    @NuFuncionario INT,
    @Operacao INT
)
AS
BEGIN 
    SET NOCOUNT ON;

    -- VARIAVEIS
    DECLARE @NuClienteRegistado INT;
    DECLARE @NuEncomendaRegistada INT;
    DECLARE @ProdutoExistente INT;

    -- PROCURANDO UMA ENCOMENDA ABERTA
    SELECT TOP 1 @NuEncomendaRegistada=Nu_Encomenda 
        FROM Tb_Encomenda 
        WHERE (Nu_Funcionario = @NuFuncionario AND Estado = 1) 
        ORDER BY Data_Registo DESC;

    -- SE O UTILIZADOR ENVIAR ZERO (0) ENTAO A FATURA É FECHADA
    IF @Operacao = 0
    BEGIN
        UPDATE Tb_Encomenda SET Estado = 0 WHERE (Estado = 1 AND Nu_Funcionario = @NuFuncionario);
        RETURN(0);
    END

    -- PROCURAR PRODUTO
    DECLARE @QuantidadeNoEstoque INT;
    SELECT @QuantidadeNoEstoque = Quantidade FROM Tb_Estoque WHERE Nu_Produto = @NuProduto;

    IF @QuantidadeNoEstoque IS NULL
    BEGIN
        PRINT 'ESTE PRODUTO NÃO ESTÁ DISPONÍVEL NO ESTOQUE';
        RETURN(0);
    END
    ELSE IF @QuantidadeNoEstoque < @QuantidadeProduto
    BEGIN
        PRINT 'QUANTIDADE ALTA. INSIRA UMA QUANTIDADE VÁLIDA. EXISTEM ' + @QuantidadeNoEstoque + 'QTD PARA ESTE PRODUTO';
        RETURN(0);
    END

    -- CASO NAO ENCONTRE NENHUMA FATURA ABERTA
    IF @NuEncomendaRegistada IS NULL
    BEGIN

        -- REGISTAR O CLIENTE
        INSERT INTO Tb_Cliente (Nome) 
            VALUES (@NomeCliente);

        SET @NuClienteRegistado = SCOPE_IDENTITY();

        -- CRIAR A FATURA DA ENCOMENDA
        INSERT INTO Tb_Encomenda (Nu_Cliente, Nu_Funcionario) 
            VALUES (@NuClienteRegistado, @NuFuncionario);

        SET @NuEncomendaRegistada = SCOPE_IDENTITY();

    END

    -- VERIFICAR SE O PRODUTO JA FOI ADICIONADO
    SELECT @ProdutoExistente = COUNT(*) FROM Tb_Detalhe_Encomenda WHERE (Nu_Produto = @NuProduto AND Nu_Encomenda = @NuEncomendaRegistada);


    IF @ProdutoExistente > 0
    BEGIN

        -- O PRODUTO JA ESTÁ REGISTADO, ENTÃO ATUALIZE A QUANTIDADE

        UPDATE Tb_Detalhe_Encomenda
            SET Quantidade = @QuantidadeProduto
            WHERE (Nu_Encomenda = @NuEncomendaRegistada AND Nu_Produto = @NuProduto)
            PRINT 'QUANTIDADE DO PRODUTO ATUALIZADA COM SUCESSO!';

        UPDATE Tb_Estoque SET Quantidade = Quantidade - @QuantidadeProduto WHERE Nu_Produto = @NuProduto;
        RETURN(0)

    END

    -- REGISTAR O PRODUTO NO DETALHE DA FATURA PORQUE NAO FOI ADICIONADO AINDA
    INSERT INTO Tb_Detalhe_Encomenda (Nu_Encomenda, Nu_Produto, Quantidade) 
        VALUES (@NuEncomendaRegistada, @NuProduto, @QuantidadeProduto);
    
    UPDATE Tb_Estoque SET Quantidade = Quantidade - @QuantidadeProduto WHERE Nu_Produto = @NuProduto;

    
END
GO

----------------------------------------------------------------------------------

EXEC sp_venda 
    @NomeCliente = 'Domingos Pedro',
    @NuProduto = 2,
    @QuantidadeProduto = 14,
    @NuFuncionario = 1,
    @Operacao = 1
GO

SELECT * from Tb_Cliente;
SELECT * from Tb_Encomenda;
SELECT * from Tb_Detalhe_Encomenda;