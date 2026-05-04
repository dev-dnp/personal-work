USE vendas_domingos;
GO



/*

EXEC sp_venda 
    @TipoOperacao = 'INICIAR_VENDA',
    @NomeCliente = N'Yuri da Silva', 
    @NuFuncionario =  1, 
    @NuProduto = 1, 
    @QtdProduto = 4,
    @TipoAtualizacao  = 'ADICAO'
GO


SELECT * from Tb_Cliente;
SELECT * from Tb_Encomenda;
SELECT * from Tb_Detalhe_Encomenda;
SELECT * from Tb_Estoque;

*/





-- SELECT * from Tb_Produto;
-- DELETE from Tb_Detalhe_Encomenda;
-- DELETE from Tb_Encomenda;
-- DELETE from Tb_Cliente;


SELECT * FROM Tb_Movimentacao_Estoque


select * from fornecedor where bairro in ('Kita','Pango-Velho')--in todos com correspondencia com esses elementos

select * from cliente where nomecliente like '%J'--Termina com: LIKE '%Silva' (Encontra "João Silva", "Maria Silva").
select * from cliente where nomecliente like 'J%'--Começa com: LIKE 'Ana%' (Encontra "Ana", "Ana Paula", "Anabel").
select * from cliente where nomecliente like '%J%'--Contém: LIKE '%Santos%' (Encontra qualquer coisa que tenha "Santos" no meio)
select * from produto where preco between 100 and 700 --retorna todos os produtos com precos entre 100 e 700