--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// EMPREGADOS /////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--Empregados por departamento ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Empregados_departamento AS
SELECT D.[Nome] AS 'Departamento', E.[EmpId],E.[Nome],E.[Apelido]
FROM [dbo].[Empregados] AS E
JOIN [dbo].[Empregados_Departamentos] AS D 
	ON E.[DepId] = D.[DepId];
GO

SELECT * FROM VW_Empregados_departamento;
GO
 
-- Vendas por empregado---------------------------------------------------------------------------------------------------
CREATE VIEW VW_Empregados_vendas AS
SELECT E.[EmpId], 
       SUM(R.[Valor]) AS Total_Valor,          
       COUNT(R.[ReservaId]) AS Total_Vendas, 
       MONTH(R.[Data_pagamento]) AS Mes, 
       YEAR(R.[Data_pagamento]) AS Ano
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Empregados] AS E 
	ON R.[EmpId] = E.[EmpId]                 
JOIN [dbo].[Empregados_Departamentos] AS D 
	ON D.[DepId] = E.[DepId]                
WHERE D.[Nome]= 'Vendas'
GROUP BY E.[EmpId], YEAR(R.[Data_pagamento]), MONTH(R.[Data_pagamento]);
GO

SELECT * FROM VW_Empregados_vendas;
GO
 
-- Manutenções por empregado---------------------------------------------------------------------------------------------------

CREATE VIEW VW_Empregados_Manutencao AS
SELECT E.[EmpId], 
    COUNT(M.[ManutencaoId]) AS Intervenções,
    COUNT(CASE WHEN M.[Data_fim] IS NOT NULL THEN 1 END) AS Completas,
    COUNT(CASE WHEN M.[Data_fim] IS NULL THEN 1 END) AS Ativas,
    MONTH(M.[Data_inicio]) AS Mes,
    YEAR(M.[Data_inicio]) AS Ano
FROM [dbo].[Empregados] AS E
JOIN [dbo].[Carros_Manutencao] AS M
    ON E.[EmpId] = M.[EmpId]
GROUP BY E.[EmpId], E.[Nome], E.[Apelido], YEAR(M.[Data_inicio]), MONTH(M.[Data_inicio])
GO

SELECT * FROM VW_Empregados_Manutencao;
GO
 
-- Folhas de ordenado ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Empregados_folha_vencimento AS
SELECT E.[EmpId],D.[DepId], EI.[NIF], EI.[Vencimento]
FROM [dbo].[Empregados] AS E
JOIN [dbo].[Empregados_Departamentos] AS D 
	ON E.[DepId] = D.[DepId]
JOIN [dbo].[Empregados_Info] AS EI
	ON E.[EmpId] = EI.[EmpId];
GO

SELECT * FROM VW_Empregados_folha_vencimento;
GO
 
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// CARROS /////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Carros disponíveis ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Carros_disponiveis AS
SELECT S.[Nome] AS 'Segmento', C.[Marca], C.[Modelo], C.[Ano], C.[Preco_dia],C.[CarId]
FROM [dbo].[Carros] AS C
JOIN [dbo].[Carros_Segmento] AS S
	ON C.[SegmentoId] = S.[SegmentoId]
WHERE C.[StatusId] = 'D';
GO

SELECT * FROM VW_Carros_disponiveis;
GO
 
-- Carros reservados ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Carros_reservados AS
SELECT C.[CarId],C.[Matricula],C.[Marca],C.[Modelo],
		S.[Nome] AS 'Segmento',R.[Data_inicio], R.[Data_fim],CLI.[ClienteId],E.[EmpId]
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Clientes] AS CLI
	ON R.[ClienteId] = CLI.[ClienteId]
JOIN [dbo].[Carros] AS C
	ON R.[CarId] = C.[CarId]
JOIN [dbo].[Empregados] AS E
	ON R.[EmpId] = E.[EmpId]
JOIN [dbo].[Carros_Segmento] AS S
	ON C.[SegmentoId] = S.[SegmentoId]
WHERE R.[Pagamento] = 'Pendente';
GO

SELECT * FROM VW_Carros_reservados;
GO
 
-- Carros em manutenção ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Carros_em_manutencao AS
SELECT C.[CarId],C.[Matricula],C.[Marca],C.[Modelo],C.[KM],S.[Nome] AS 'Segmento'
FROM [dbo].[Carros] AS C
JOIN [dbo].[Carros_Segmento] AS S
	ON C.[SegmentoId] = S.[SegmentoId]
WHERE C.[StatusId] = 'M';
GO

SELECT * FROM VW_Carros_em_manutencao;
GO
 
-- Histórico de manutenção ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Carros_historico_manutencao AS
SELECT C.[CarId],C.[Matricula],M.[Intervencao], M.[data_inicio], M.[data_fim], M.[Custo], M.[ManutencaoId],E.[EmpId]
FROM [dbo].[Carros] AS C
JOIN [dbo].[Carros_Manutencao] AS M
	ON C.[CarId] = M.[CarId]
JOIN [dbo].[Empregados] AS E
	ON M.[EmpId] = E.[EmpId];
GO

SELECT * FROM VW_Carros_historico_manutencao;
GO
 
-- Rendimento por carro ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Carros_rendimento_carro AS
SELECT C.[CarId], C.[Marca], C.[Modelo], SUM(R.[Valor]) AS 'Total_Rendimento'
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Carros] AS C
	ON R.[CarId] = C.[CarId]
WHERE R.[Pagamento] = 'Concluído'
GROUP BY C.[CarId], C.[Marca], C.[Modelo]
GO

SELECT * 
FROM VW_Carros_rendimento_carro 
ORDER BY 'Total_Rendimento' DESC; 
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// CLIENTES ///////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Clientes info completa ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Clientes_info_completa AS
SELECT C.[ClienteId], C.[Data_adesao], C.[Nome], C.[Apelido], C.[NIF], C.[Carta], 
		I.[Email], I.[Telefone], I.[Data_nascimento]
FROM [dbo].[Clientes] AS C
JOIN [dbo].[Clientes_Info] AS I 
	ON C.[ClienteId] = I.[ClienteId];
GO

SELECT * FROM VW_Clientes_info_completa;
GO
 
-- Morada cliente ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Clientes_morada AS
SELECT *
FROM [dbo].[Clientes_Morada];
GO

SELECT * FROM VW_Clientes_morada;
GO
 
-- Info marketing cliente ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Clientes_marketing_info AS
SELECT C.[ClienteId], C.[Nome], C.[Apelido], C.[Data_adesao],I.[Data_nascimento], I.[Email], 
		M.[Rua], M.[Número], M.[Andar], M.[Codigo_postal], M.[Cidade]
FROM [dbo].[Clientes] AS C
JOIN [dbo].[Clientes_Info] AS I
	ON I.[ClienteId] = C.[ClienteId]  
JOIN [dbo].[Clientes_Morada] AS M
	ON M.[ClienteId] = C.[ClienteId];
GO

SELECT * FROM VW_Clientes_marketing_info;
GO
 
-- Histórico cliente ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_CLientes_historico_reservas AS
SELECT CLI.[ClienteId], R.[ReservaId], C.[CarId],
		R.[data_inicio], R.[data_fim], R.[Valor], R.[Data_pagamento]
FROM [dbo].[Clientes] AS CLI
JOIN [dbo].[Reservas] AS R
	ON CLI.[ClienteId] = R.[ClienteId]
JOIN [dbo].[Carros] AS C
	ON R.[CarId] = C.[CarId];
GO

SELECT * FROM VW_CLientes_historico_reservas;
GO
 
-- Histórico cliente detalhado ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_CLientes_historico_reservas_detalhado AS
SELECT CLI.[Nome], CLI.[Apelido], C.[Matricula],C.[Marca],C.[Modelo],
		ENT.[KM_finais], R.[data_inicio], R.[data_fim], R.[Valor], R.[Data_pagamento], R.[ReservaId]
FROM [dbo].[Clientes] AS CLI
JOIN [dbo].[Reservas] AS R
	ON CLI.[ClienteId] = R.[ClienteId]
JOIN [dbo].[Carros] AS C
	ON R.[CarId] = C.[CarId]
JOIN[dbo].[Reservas_Entrega]  AS ENT
	ON ENT.[ReservaId] = R.[ReservaId];
GO

SELECT * FROM VW_CLientes_historico_reservas_detalhado;
GO
 
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// ALUGUERES //////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--Ver Reservas ativas ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Reservas_ativas AS
SELECT R.[ReservaId],E.[EmpId],C.[CarId],CLI.[ClienteId],R.[Data_inicio],R.[Data_fim],R.[Valor]
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Clientes] AS CLI
	ON R.[ClienteId] = CLI.[ClienteId]
JOIN [dbo].[Carros] AS C 
	ON R.[CarId] = C.[CarId]
JOIN [dbo].[Empregados] AS E
	ON R.[EmpId] = E.[EmpId]
WHERE R.[Data_inicio] <= GETDATE() AND R.[Data_fim] >= GETDATE();
GO

SELECT * FROM VW_Reservas_ativas;
GO

--Ver Reservas ativas com pagamento pendente ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Reservas_ativas_pagamento_pendente AS
SELECT R.[ReservaId],E.[EmpId],C.[CarId],CLI.[ClienteId],R.[Data_inicio],R.[Data_fim],R.[Valor]
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Clientes] AS CLI
	ON R.[ClienteId] = CLI.[ClienteId]
JOIN [dbo].[Carros] AS C 
	ON R.[CarId] = C.[CarId]
JOIN [dbo].[Empregados] AS E
	ON R.[EmpId] = E.[EmpId]
WHERE R.[Pagamento] = 'Pendente' AND R.[Data_inicio] <= GETDATE();
GO

SELECT * FROM VW_Reservas_ativas_pagamento_pendente;
GO

--Ver Reservas agendadas ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Reservas_agendadas AS
SELECT R.[ReservaId],E.[EmpId],C.[CarId],CLI.[ClienteId],R.[Data_inicio],R.[Data_fim],R.[Valor]
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Clientes] AS CLI
	ON R.[ClienteId] = CLI.[ClienteId]
JOIN [dbo].[Carros] AS C 
	ON R.[CarId] = C.[CarId]
JOIN [dbo].[Empregados] AS E
	ON R.[EmpId] = E.[EmpId]
WHERE R.[Data_inicio] >= GETDATE();
GO

SELECT * FROM VW_Reservas_agendadas;
GO

--Ver Entregas concluídas ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Reservas_concluidas AS
SELECT R.[ReservaId],E.[EmpId],C.[CarId],CLI.[ClienteId],R.[Data_inicio],R.[Data_fim],R.[Valor],R.[Data_pagamento]
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Clientes] AS CLI
	ON R.[ClienteId] = CLI.[ClienteId]
JOIN [dbo].[Carros] AS C 
	ON R.[CarId] = C.[CarId]
JOIN [dbo].[Empregados] AS E
	ON R.[EmpId] = E.[EmpId]
WHERE R.[Pagamento] = 'Concluído';
GO

SELECT * FROM VW_Reservas_concluidas;
GO

-- Recibo ----------------------------------------------------------------------------------------------------
CREATE VIEW VW_Reservas_recibo AS 
SELECT CLI.[Nome] AS 'Nome Cliente', CLI.[Apelido] AS 'Apelido Cliente', CLI.[NIF],
		C.[Matricula], C.[Marca], C.[Modelo], C.[Ano], C.[Preco_dia],
		R.[Valor], R.[Data_inicio], R.[Data_fim], R.[Data_pagamento],
		ENT.[KM_finais],E.[EmpId]
FROM [dbo].[Reservas] AS R
JOIN [dbo].[Clientes] AS CLI
	ON R.[ClienteId] = CLI.[ClienteId]
JOIN [dbo].[Carros] AS C 
	ON R.[CarId] = C.[CarId]
JOIN [dbo].[Empregados] AS E
	ON R.[EmpId] = E.[EmpId]
JOIN [dbo].[Reservas_Entrega] AS ENT
	ON ENT.[ReservaId] = R.[ReservaId]
WHERE R.[Pagamento] = 'Concluído';
GO

SELECT * FROM VW_Reservas_recibo where MONTH(Data_pagamento) = 11;
GO
