

CREATE OR ALTER PROCEDURE sp_concluir_venda
(
    @NuEncomenda INT
)
AS
BEGIN

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
        END

    EXEC sp_concluir_venda @NuEncomenda = @NuEncomenda;

END
GO
-- SELECT * from Tb_Encomenda;
SELECT * from sys.procedures;

