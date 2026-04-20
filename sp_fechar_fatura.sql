

CREATE OR ALTER PROCEDURE sp_fechar_encomenda
(
    @NuEncomenda INT
)
AS
BEGIN

    SELECT TOP 1 FROM Tb_Detalhe_Encomenda WHERE Nu_Encomenda = @NuEncomenda AND Estado = 1;

END

SELECT * from Tb_Encomenda;