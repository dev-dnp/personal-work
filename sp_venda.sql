
CREATE OR ALTER PROCEDURE sp_venda
(
    -- PARAMÊTROS
    @NomeCliente NVARCHAR(100),
    @NuProduto INT,
    @QuantidadeProduto INT,
    @NuFuncionario INT,
    @Operacao VARCHAR(20) = 'VENDER',
    @AtualizarQuantidade VARCHAR(20) = 'ADICAO'
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
    IF @Operacao = 'FINALIZAR'
    BEGIN

        IF @NuEncomendaRegistada IS NULL
        BEGIN
            PRINT 'NENHUMA FATURA ABERTA ENCONTRADA!';
            RETURN(0);
        END

        BEGIN TRANSACTION

            EXEC sp_fechar_encomenda @NuEncomenda = @NuEncomendaRegistada;
           
            IF @@ERROR <> 0
                BEGIN
                    PRINT 'Ocorreu um erro ao processar ao fechar a fatura!';
                    ROLLBACK;
                    RETURN(0);
                END
            ELSE
                BEGIN
                    UPDATE Tb_Encomenda SET Estado = 0 WHERE Nu_Encomenda = @NuEncomendaRegistada;

                    IF @@ERROR <> 0
                    BEGIN
                        PRINT 'Ocorreu um erro ao atualizar o estado da encomenda para zero (0)';
                        ROLLBACK;
                        RETURN(0);
                    END

                    COMMIT;
                    RETURN(0)
                END
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

        IF @AtualizarQuantidade = 'ADICAO'
        BEGIN
            UPDATE Tb_Detalhe_Encomenda
                SET Quantidade = Quantidade + @QuantidadeProduto
                WHERE (Nu_Encomenda = @NuEncomendaRegistada AND Nu_Produto = @NuProduto)
                PRINT 'QUANTIDADE DO PRODUTO ATUALIZADA COM SUCESSO!';
        END
        ELSE IF @AtualizarQuantidade = 'SUBTRACAO'
        BEGIN
            UPDATE Tb_Detalhe_Encomenda
                SET Quantidade = Quantidade - @QuantidadeProduto
                WHERE (Nu_Encomenda = @NuEncomendaRegistada AND Nu_Produto = @NuProduto)
                PRINT 'QUANTIDADE DO PRODUTO ATUALIZADA COM SUCESSO!';
        END

        RETURN(0);
    END

    -- REGISTAR O PRODUTO NO DETALHE DA FATURA PORQUE NAO FOI ADICIONADO AINDA
    INSERT INTO Tb_Detalhe_Encomenda (Nu_Encomenda, Nu_Produto, Quantidade) 
        VALUES (@NuEncomendaRegistada, @NuProduto, @QuantidadeProduto);
    
END
GO

----------------------------------------------------------------------------------

EXEC sp_venda 
    @Operacao = 'VENDER',
    @NuFuncionario = 1,
    @NomeCliente = 'José Fernandes',
    @NuProduto = 1,
    @QuantidadeProduto = 20
GO

SELECT * from Tb_Cliente;
SELECT * from Tb_Encomenda;
SELECT * from Tb_Detalhe_Encomenda;
SELECT * from Tb_Estoque;




DELETE from Tb_Cliente;
DELETE from Tb_Detalhe_Encomenda;
DELETE from Tb_Encomenda;