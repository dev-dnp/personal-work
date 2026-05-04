USE vendas_domingos;
GO

CREATE OR ALTER PROCEDURE sp_venda
(
    -- PARAMETROS
    @NomeCliente NVARCHAR(100),
    @NuFuncionario INT,
    @NuProduto INT,
    @QtdProduto INT,
    @TipoOperacao VARCHAR(20) = 'INICIAR_VENDA',
    @TipoAtualizacao VARCHAR (20) = 'ADICAO'
)
AS
BEGIN

    -- VARIAVEIS
    DECLARE @NuClienteCorrente INT;
    DECLARE @NuEncomendaCorrente INT;
    DECLARE @NuProdutoExistenteEmDetalhes INT;
    DECLARE @PrecoUnitarioProduto INT;

    -- PROCURANDO UMA ENCOMENDA ABERTA
    SELECT TOP 1 
        @NuEncomendaCorrente=Nu_Encomenda,
        @NuClienteCorrente = Nu_Cliente
    FROM Tb_Encomenda 
    WHERE (Nu_Funcionario = @NuFuncionario AND Estado = 1) 
    ORDER BY Data_Registo DESC;

    IF @TipoOperacao = 'INICIAR_VENDA'
    BEGIN

        -- CASO NAO ENCONTRE NENHUMA FATURA ABERTA
        IF @NuEncomendaCorrente IS NULL
        BEGIN

            -- REGISTAR O CLIENTE
            INSERT INTO Tb_Cliente (Nome) VALUES (@NomeCliente);

            SET @NuClienteCorrente = SCOPE_IDENTITY();

            -- CRIAR A FATURA DA ENCOMENDA
            INSERT INTO Tb_Encomenda (Nu_Cliente, Nu_Funcionario) VALUES (@NuClienteCorrente, @NuFuncionario);

            SET @NuEncomendaCorrente = SCOPE_IDENTITY();
        END

        -- VERIFICAR SE O PRODUTO ESTÁ DISPONIVEL NO ESTOQUE

        IF NOT EXISTS (SELECT 1 FROM Tb_Estoque WHERE Nu_Produto = @NuProduto)
        BEGIN
            PRINT 'ESTE PRODUTO NÃO ESTÁ DISPONÍVEL NO ESTOQUE';
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Tb_Estoque WHERE Nu_Produto = @NuProduto AND Quantidade >= @QtdProduto)
        BEGIN
            PRINT 'QUANTIDADE INSUFICIENTE NO ESTOQUE';
            RETURN;
        END

        -- VERIFICAR SE O PRODUTO JA FOI ADICIONADO
        SELECT 
            @NuProdutoExistenteEmDetalhes = Nu_Produto
        FROM Tb_Detalhe_Encomenda WHERE (Nu_Produto = @NuProduto AND Nu_Encomenda = @NuEncomendaCorrente);

        IF @NuProdutoExistenteEmDetalhes IS NOT NULL
            BEGIN

                -- O PRODUTO JA ESTÁ REGISTADO, ENTÃO ATUALIZE A QUANTIDADE

                IF @TipoAtualizacao = 'ADICAO'
                BEGIN
                    UPDATE Tb_Detalhe_Encomenda
                        SET Quantidade = Quantidade + @QtdProduto
                        WHERE (Nu_Encomenda = @NuEncomendaCorrente AND Nu_Produto = @NuProduto)
                        PRINT 'QUANTIDADE DO PRODUTO ATUALIZADA COM SUCESSO!';
                END
                ELSE IF @TipoAtualizacao = 'SUBTRACAO'
                BEGIN
                    UPDATE Tb_Detalhe_Encomenda
                        SET Quantidade = Quantidade - @QtdProduto
                        WHERE (Nu_Encomenda = @NuEncomendaCorrente AND Nu_Produto = @NuProduto)
                        PRINT 'QUANTIDADE DO PRODUTO ATUALIZADA COM SUCESSO!';
                END

                RETURN(0);
            END
        
        IF NOT EXISTS (SELECT * FROM Tb_Produto WHERE Nu_Produto = @NuProduto)
        BEGIN
            PRINT 'PRODUTO NÃO ENCONTRADO';
            RETURN(0);
        END


        SELECT @PrecoUnitarioProduto = Preco FROM Tb_Produto WHERE Nu_Produto = @NuProduto;

        -- REGISTAR O PRODUTO NO DETALHE DA FATURA PORQUE NAO FOI ADICIONADO AINDA
        INSERT INTO Tb_Detalhe_Encomenda (Nu_Encomenda, Nu_Produto, Quantidade, Preco_Unitario) 
        VALUES (@NuEncomendaCorrente, @NuProduto, @QtdProduto, @PrecoUnitarioProduto);
    END

    IF @TipoOperacao = 'FINALIZAR_VENDA'
    BEGIN

        IF @NuEncomendaCorrente IS NULL
        BEGIN
            PRINT 'NENHUMA FATURA ABERTA ENCONTRADA!';
            RETURN(0);
        END

        BEGIN TRANSACTION

            EXEC sp_concluir_venda @NuEncomenda = @NuEncomendaCorrente;
           
            IF @@ERROR <> 0
                BEGIN
                    PRINT 'Ocorreu um erro ao processar os detalhes ao fechar a fatura!';
                    ROLLBACK;
                    RETURN(0);
                END
            ELSE
                BEGIN
                    UPDATE Tb_Encomenda SET Estado = 0 WHERE Nu_Encomenda = @NuEncomendaCorrente;

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

    IF @TipoOperacao = 'CANCELAR_VENDA'
    BEGIN
        DELETE FROM Tb_Detalhe_Encomenda WHERE Nu_Encomenda = @NuEncomendaCorrente;
        DELETE FROM Tb_Encomenda WHERE Nu_Encomenda = @NuEncomendaCorrente;
        DELETE FROM Tb_Cliente WHERE Nu_Cliente = @NuClienteCorrente;
    END

END
GO