
CREATE OR ALTER PROCEDURE sp_processar_venda
(
    -- 0 para cancelar e 1 para aprovar
    @ProcessarVenda BIT = 0, 
    @NuFuncionario INT
)
AS
BEGIN

    DECLARE @NuCliente INT;

    -- VARIAVEIS
    DECLARE @NuEncomendaRegistada INT;

    SELECT TOP 1 
        @NuEncomendaRegistada=Nu_Encomenda,
        @NuCliente=Nu_Cliente
    FROM Tb_Encomenda 
    WHERE (Nu_Funcionario = @NuFuncionario AND Estado = 1) 
    ORDER BY Data_Registo DESC;

    PRINT @NuEncomendaRegistada
    PRINT @NuCliente


    return;

    IF (@ProcessarVenda = 0 AND @NuEncomendaRegistada IS NOT NULL)
    BEGIN
        BEGIN TRAN ELIMINAR_ENCOMENDA_E_DETALHES

            DELETE FROM Tb_Detalhe_Encomenda WHERE Nu_Encomenda = @NuEncomendaRegistada;
            
            IF (@@ERROR <> 0) 
            BEGIN
                PRINT('Erro ao eliminar detalhes')
                ROLLBACK TRAN;
                RETURN;
            END

            DELETE FROM Tb_Encomenda WHERE Nu_Encomenda = @NuEncomendaRegistada;

            IF (@@ERROR <> 0) ROLLBACK TRAN ELIMINAR_ENCOMENDA_E_DETALHES;
            BEGIN
                PRINT('Erro ao eliminar a encomenda')
                ROLLBACK TRAN;
                RETURN;
            END

        COMMIT

        UPDATE Tb_Encomenda SET Estado = 0 WHERE Nu_Funcionario = @NuFuncionario;

        PRINT 'Fatura cancelada com sucesso!';
        RETURN;
    END

    PRINT '
            Nenhuma operação foi executada! Escolha uma opção válida. 
            Para cancelar a fatura envie zero (0)
            Para aprovar a fatura enviei um (1)
    '

    -- IF (@ProcessarVenda = 1 AND @NuEncomendaRegistada IS NOT NULL)
END
GO

EXEC sp_processar_venda 0, 1;
GO