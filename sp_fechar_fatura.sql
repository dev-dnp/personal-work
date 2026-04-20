

CREATE OR ALTER PROCEDURE sp_fechar_encomenda
(
    @NuEncomenda INT
)
AS
BEGIN

    BEGIN TRAN

        DECLARE @NuDetalheAberta INT
        DECLARE @NuProduto INT
        DECLARE @Quantidade INT
        DECLARE @QuantidadeEstoque INT


        SELECT TOP 1 
            @NuProduto = Nu_Produto,
            @Quantidade = Quantidade
        FROM Tb_Detalhe_Encomenda WHERE Nu_Encomenda = @NuEncomenda AND Estado = 1;

        IF @NuProduto IS NULL
            RETURN;

        IF EXISTS (
            SELECT 1 
            FROM Tb_Estoque 
            WHERE Nu_Produto = @NuProduto 
              AND Quantidade >= @Quantidade
        )
        BEGIN
            UPDATE Tb_Estoque SET Quantidade = (Quantidade - @Quantidade) WHERE Nu_Produto = @NuProduto;
            UPDATE Tb_Detalhe_Encomenda SET Estado = 0 WHERE Nu_Encomenda = @NuEncomenda AND Nu_Produto = @NuProduto;
            COMMIT;
        END
        ELSE
        BEGIN
            ROLLBACK;
            RETURN;
        END

    EXEC sp_fechar_encomenda @NuEncomenda = @NuEncomenda;

END

SELECT * from Tb_Encomenda;
