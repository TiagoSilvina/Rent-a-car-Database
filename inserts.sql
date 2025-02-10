--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// EMPREGADOS ////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO Empregados_Departamentos (Nome)
VALUES 
	('CEO'),
	('Marketing'),
	('Operações'),
	('Vendas'),
	('Contabilidade');
GO

INSERT INTO Empregados (DepId, Nome, Apelido, EmailEmp)
VALUES 
    (101, 'João', 'Silva', 'joao.silva@email.com'),
    (102, 'Ana', 'Pereira', 'ana.pereira@email.com'),
    (103, 'Carlos', 'Santos', 'carlos.santos@email.com'),
    (104, 'Mariana', 'Costa', 'mariana.costa@email.com'),
    (104, 'Rui', 'Martins', 'rui.martins@email.com'),
    (104, 'Inês', 'Fernandes', 'ines.fernandes@email.com');
GO

INSERT INTO Empregados_Info (EmpId, NIF, Vencimento, Telefone, Data_inicio, Contacto_emergencia, Nome_cont_emerg, Apelido_cont_emerg)
VALUES 
    (1, '123456789', 5000.00, '912345678', '2023-01-01', '911234567', 'Maria', 'Silva'),
    (2, '234567891', 1100.00, '913456789', '2023-01-01', '914567890', 'Pedro', 'Pereira'),
    (3, '123456790', 1100.00, '914567890', '2023-01-01', '915678901', 'Ana', 'Santos'),
    (4, '234567892', 1100.00, '915678901', '2023-01-01', '916789012', 'André', 'Costa'),
    (5, '123456791', 1100.00, '916789012', '2024-04-01', '917890123', 'Isabel', 'Martins'),
    (6, '234567893', 1100.00, '917890123', '2023-01-01', '918901234', 'João', 'Fernandes');
GO

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// CARROS ////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO Carros_Segmento (SegmentoId, Nome)
VALUES 
	('URB', 'Compacto'),
	('FAM', 'Familar'),
	('SUV', 'SUV'),
	('VAN', 'Carrinha'),
	('SPT', 'Desportivo');
GO

INSERT INTO Carros_Status (StatusId, Nome)
VALUES 
	('D', 'Disponível'),
	('R', 'Reservado'),
	('M', 'Manutenção');
GO

INSERT INTO Carros (Matricula, Marca, Modelo, Ano, SegmentoId, Combustivel, KM, Preco_dia)
VALUES 
    ('FI-01-AT', 'Fiat', '500', 2023, 'URB', 'gasolina', 22000, 25.00), 
    ('NI-55-AN', 'Nissan', 'Micra', 2023, 'URB', 'gasolina', 18000, 25.00),
    ('MB-01-MB', 'Mercedes', 'Classe-A', 2023, 'URB', 'gasolina', 18000, 30.00), 
    ('FI-02-AT', 'Fiat', 'Tipo', 2022, 'FAM', 'diesel', 45000, 40.00), 
    ('NI-52-AN', 'Nissan', 'Altima', 2023, 'FAM', 'diesel', 67000, 40.00),  
    ('MB-02-MB', 'Mercedes', 'Classe-C', 2023, 'FAM', 'diesel', 80000, 45.00), 
    ('JE-11-EP', 'Jeep', 'Wrangler', 2022, 'SUV', 'diesel', 55000, 60.00), 
    ('MB-03-MB', 'Mercedes', 'GLC', 2023, 'SUV', 'diesel', 32000, 90.00), 
    ('FI-03-AT', 'Fiat', 'Doblo', 2022, 'VAN', 'diesel', 58000, 60.00), 
    ('MB-04-MB', 'Mercedes', 'Classe-V', 2021, 'VAN', 'diesel', 42000, 90.00),
    ('IN-11-PO', 'Porsche', '911', 2023, 'SPT', 'gasolina', 7000, 200.00);
GO

INSERT INTO Carros_Manutencao (CarId, EmpId, Intervencao)
VALUES
	(1030, 3, 'Pneus'),
	(1100, 3, 'Revisão');
GO

UPDATE Carros_Manutencao
SET Data_fim = GETDATE(), Custo = 150
WHERE ManutencaoId = 2;
GO

SELECT * FROM [dbo].[Carros_Manutencao];

SELECT * FROM  [dbo].[Carros];

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// CLIENTES ////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO Clientes (Nome, Apelido, NIF, Carta)
VALUES
    ('Ricardo', 'Fernandes', '123456789', 'L-123456789'),
    ('Isabel', 'Sousa', '987654321', 'L-987654321'),
    ('Filipe', 'Martins', '112233445', 'L-112233445'),
    ('Ana', 'Pereira', '223344556', 'L-223344556'),
    ('João', 'Silva', '334455667', 'L-334455667'),
    ('Maria', 'Costa', '445566778', 'L-445566778'),
    ('Pedro', 'Oliveira', '556677889', 'L-556677889'),
    ('Carla', 'Ribeiro', '667788990', 'L-667788990'),
    ('Luís', 'Mendes', '778899001', 'L-778899001'),
    ('Sofia', 'Martins', '889900112', 'L-889900112');
GO

INSERT INTO Clientes_Info (ClienteId, Data_nascimento, Email, Telefone)
VALUES
    (1001, '1990-05-15', 'Ricardo.Fernandes@email.com', '912345678'),
    (1002, '1985-11-20', 'Isabel.Sousa@email.com', '913456789'),
    (1003, '1992-02-14', 'Filipe.Martins@email.com', '914567890'),
    (1004, '1993-04-10', 'Ana.Pereira@email.com', '915678901'),
    (1005, '1988-08-23', 'Joao.Silva@email.com', '916789012'),
    (1006, '1995-12-05', 'Maria.Costa@email.com', '917890123'),
    (1007, '1987-03-11', 'Pedro.Oliveira@email.com', '918901234'),
    (1008, '1991-07-30', 'Carla.Ribeiro@email.com', '919012345'),
    (1009, '1984-02-17', 'Luis.Mendes@email.com', '920123456'),
    (1010, '1990-11-28', 'Sofia.Martins@email.com', '921234567');
GO

INSERT INTO Clientes_Morada (ClienteId, Rua, Número, Andar, Codigo_postal, Cidade, País)
VALUES
    (1001, 'Rua da Liberdade', '10', '1º', '1100-100', 'Lisboa', 'Portugal'),
    (1002, 'Avenida da República', '22', '2º', '1200-200', 'Porto', 'Portugal'),
    (1003, 'Rua das Flores', '35', '3º', '1300-300', 'Lisboa', 'Portugal'),
    (1004, 'Rua dos Três Caminhos', '45', '1º', '1400-400', 'Coimbra', 'Portugal'),
    (1005, 'Avenida da Boavista', '88', '4º', '1500-500', 'Porto', 'Portugal'),
    (1006, 'Rua de Santa Catarina', '12', '5º', '1600-600', 'Lisboa', 'Portugal'),
    (1007, 'Praça do Comércio', '9', '2º', '1700-700', 'Lisboa', 'Portugal'),
    (1008, 'Rua do Alecrim', '51', '6º', '1800-800', 'Lisboa', 'Portugal'),
    (1009, 'Avenida do Brasil', '25', '3º', '1900-900', 'Funchal', 'Portugal'),
    (1010, 'Rua de São Bento', '37', '7º', '2000-100', 'Lisboa', 'Portugal');
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
--////////// ALUGUERES ////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Setembro ------------------------------------------------------------------------------------------------------------------------
INSERT INTO Reservas (Data_inicio, Data_fim, ClienteId, CarId, EmpId)
VALUES
    ('2024-09-01', '2024-09-05', 1001, 1010, 4),  
    ('2024-09-08', '2024-09-12', 1002, 1020, 5), 
    ('2024-09-15', '2024-09-19', 1003, 1030, 4), 
    ('2024-09-20', '2024-09-25', 1004, 1040, 5),  
    ('2024-09-26', '2024-09-30', 1005, 1050, 4);  
GO

INSERT INTO Reservas_Entrega (ReservaId, KM_finais)
VALUES
    (101, 300),
    (102, 150),
    (103, 400),
    (104, 220),
    (105, 500);
GO

-- Outubro ------------------------------------------------------------------------------------------------------------------------
INSERT INTO Reservas (Data_inicio, Data_fim, ClienteId, CarId, EmpId)
VALUES
    ('2024-10-01', '2024-10-05', 1001, 1060, 4),  
    ('2024-10-08', '2024-10-12', 1007, 1010, 5),  
    ('2024-10-15', '2024-10-19', 1003, 1080, 4),  
    ('2024-10-20', '2024-10-25', 1009, 1030, 5), 
    ('2024-10-26', '2024-10-30', 1010, 1100, 4);  
GO

INSERT INTO Reservas_Entrega (ReservaId, KM_finais)
VALUES
    (106, 310),
    (107, 160),
    (108, 420),
    (109, 230),
    (110, 510);
GO

-- Novembro ------------------------------------------------------------------------------------------------------------------------
INSERT INTO Reservas (Data_inicio, Data_fim, ClienteId, CarId, EmpId)
VALUES
    ('2024-11-01', '2024-11-05', 1002, 1030, 4),  
    ('2024-11-08', '2024-11-12', 1007, 1020, 5),  
    ('2024-11-15', '2024-11-19', 1004, 1050, 4),  
    ('2024-11-20', '2024-11-25', 1008, 1100, 5),  
    ('2024-11-26', '2024-11-30', 1010, 1050, 4);  
GO

INSERT INTO Reservas_Entrega (ReservaId, KM_finais)
VALUES
    (111, 410);
GO

SELECT * FROM RESERVAS
