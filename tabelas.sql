CREATE DATABASE Passeios_Renting;

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// EMPREGADOS /////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Departamentos ----------------------------------------------------------------------------------------------------
CREATE TABLE Empregados_Departamentos (
	DepId INT IDENTITY(101,1) CONSTRAINT PK_Empregados_Departamentos_DepId PRIMARY KEY(DepId),
    Nome NVARCHAR(50) NOT NULL
	);
GO

-- Empregados ----------------------------------------------------------------------------------------------------
CREATE TABLE Empregados (
	EmpId INT IDENTITY(1,1) CONSTRAINT PK_Empregados_EmpId PRIMARY KEY (EmpId),
	DepId INT,
	Nome NVARCHAR(30) NOT NULL,
    Apelido NVARCHAR(30) NOT NULL,
    EmailEmp NVARCHAR(100) UNIQUE NOT NULL CONSTRAINT Ck_Empregados_EmailEmp CHECK (EmailEmp LIKE '%@%'),
	CONSTRAINT FK_Empregados_Departamentos FOREIGN KEY (DepId) REFERENCES Empregados_Departamentos(DepID)
	);
GO

CREATE INDEX IX_Empregados_DepId ON Empregados (DepId);  
GO
CREATE INDEX IX_Empregados_Apelido_Nome ON Empregados (Apelido, Nome); 
GO
CREATE INDEX IX_Empregados_EmailEmp ON Empregados (EmailEmp); 
GO

-- Empregados info ----------------------------------------------------------------------------------------------------
CREATE TABLE Empregados_Info (
	EmpId INT NOT NULL PRIMARY KEY,
	NIF VARCHAR(9) NOT NULL,
	Vencimento DECIMAL(10,2) NOT NULL,
    Telefone NVARCHAR(15) UNIQUE NOT NULL,
    Data_inicio DATE DEFAULT GETDATE(),
    Contacto_emergencia NVARCHAR(15) UNIQUE NOT NULL,
	Nome_cont_emerg NVARCHAR(30) NOT NULL,
    Apelido_cont_emerg NVARCHAR(30) NOT NULL,
	CONSTRAINT FK_Empregados_Info FOREIGN KEY (EmpId) REFERENCES Empregados(EmpId) ON DELETE CASCADE
	);
GO

CREATE INDEX IX_Empregados_Info_EmpId ON Empregados_Info (EmpId);
GO
CREATE INDEX IX_Empregados_Info_NIF ON Empregados_Info (NIF); 
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// CARROS /////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Carros Segmento ----------------------------------------------------------------------------------------------------
CREATE TABLE Carros_Segmento (
	SegmentoId NVARCHAR(3) NOT NULL CONSTRAINT PK_Carros_Segmento_SegmentoId PRIMARY KEY(SegmentoId),
    Nome NVARCHAR(50) NOT NULL
	);
GO

-- Carros Status ----------------------------------------------------------------------------------------------------
CREATE TABLE Carros_Status (
	StatusId VARCHAR(1)  NOT NULL CONSTRAINT PK_Carros_Status_carId PRIMARY KEY(StatusId),
    Nome NVARCHAR(20) NOT NULL
	);
GO

-- Carros ----------------------------------------------------------------------------------------------------
CREATE TABLE Carros (
	CarId INT IDENTITY(1010,10) CONSTRAINT PK_Carros_CarId PRIMARY KEY (CarId),
	Matricula  VARCHAR(8) UNIQUE NOT NULL CONSTRAINT CK_Carros_Matricula CHECK (Matricula LIKE '[A-JL-VXZ][A-JL-VXZ]-[0-9][0-9]-[A-JL-VXZ][A-JL-VXZ]'),
	Marca NVARCHAR(15) NOT NULL,
	Modelo NVARCHAR(15) NOT NULL,
	Ano INT NOT NULL CONSTRAINT CK_Carros_Ano CHECK (Ano BETWEEN YEAR(GETDATE()) - 5 AND YEAR(GETDATE())),
	SegmentoId NVARCHAR(3) NOT NULL,
	Combustivel NVARCHAR(10) NOT NULL CONSTRAINT CK_Carros_Combustivel CHECK (Combustivel IN ('gasolina', 'diesel')), 
	KM INT NOT NULL,
	StatusId VARCHAR(1)  NOT NULL DEFAULT 'D',
	Preco_dia DECIMAL(5, 2) NOT NULL,
	CONSTRAINT FK_Carros_Segmento FOREIGN KEY (SegmentoId) REFERENCES Carros_Segmento(SegmentoId),
	CONSTRAINT FK_Carros_Status FOREIGN KEY (StatusId) REFERENCES Carros_Status(StatusId)
	);
GO

CREATE INDEX IX_Carros_SegmentoId ON Carros (SegmentoId);
GO
CREATE INDEX IX_Carros_StatusId ON Carros (StatusId);
GO
CREATE INDEX IX_Carros_Matricula ON Carros (Matricula);
GO
CREATE INDEX IX_Carros_Marca_Modelo_Ano ON Carros (Marca, Modelo, Ano);
GO
CREATE INDEX IX_Carros_Preco_dia ON Carros (Preco_dia);
GO
CREATE INDEX IX_Carros_KM ON Carros (KM);
GO

-- Carros Manutenção ----------------------------------------------------------------------------------------------------
CREATE TABLE Carros_Manutencao (
	ManutencaoId INT IDENTITY(1,1) CONSTRAINT PK_Carros_Manutencao_ManutencaoId PRIMARY KEY(ManutencaoId),
	CarId INT NOT NULL,
	EmpId INT NOT NULL,
    Data_inicio DATE DEFAULT GETDATE(),
	Data_fim DATE,
	Intervencao  NVARCHAR(150) NOT NULL,
	Custo DECIMAL(10,2),
	CONSTRAINT FK_Carros_Manutencao FOREIGN KEY (CarId) REFERENCES Carros(CarId),
	CONSTRAINT FK_Empregados_Manutencao FOREIGN KEY (EmpId) REFERENCES Empregados(EmpId)
	);
GO

CREATE INDEX IX_Carros_Manutencao_CarId ON Carros_Manutencao (CarId);    
GO
CREATE INDEX IX_Carros_Manutencao_EmpId ON Carros_Manutencao (EmpId);  
GO
CREATE INDEX IX_Carros_Manutencao_DataInicio_DataFim ON Carros_Manutencao (Data_inicio, Data_fim);
GO
CREATE INDEX IX_Carros_Manutencao_Intervencao_Custo ON Carros_Manutencao (Intervencao, Custo);
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// CLIENTES ///////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Clientes ----------------------------------------------------------------------------------------------------
CREATE TABLE Clientes (
	ClienteId INT IDENTITY(1001,1) CONSTRAINT PK_Clientes_ClienteId PRIMARY KEY (ClienteId),
	Nome NVARCHAR(30) NOT NULL,
    Apelido NVARCHAR(30) NOT NULL,
   	NIF VARCHAR(9) NOT NULL,
    Carta NVARCHAR(15) NOT NULL CONSTRAINT CK_Clientes_Carta CHECK (Carta LIKE 'L-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    Data_adesao DATE DEFAULT GETDATE(),
	);
GO

CREATE INDEX IX_Clientes_Apelido_Nome ON Clientes (Apelido, Nome); 
GO
CREATE INDEX IX_Clientes_NIF ON Clientes (NIF); 
GO
CREATE INDEX IX_Clientes_Carta ON Clientes (Carta); 
GO
CREATE INDEX IX_Clientes_Data_adesao ON Clientes (Data_adesao); 
GO

-- Clientes Info ----------------------------------------------------------------------------------------------------
CREATE TABLE Clientes_Info (
	ClienteId INT NOT NULL PRIMARY KEY,
    Data_nascimento DATE NOT NULL CONSTRAINT CK_Clientes_Info_Data_nascimento CHECK (Data_nascimento <= DATEADD(YEAR, -18, GETDATE())),
    Email NVARCHAR(100) UNIQUE NOT NULL CONSTRAINT Ck_Clientes_Info_Email CHECK (Email LIKE '%@%'),
    Telefone NVARCHAR(15) UNIQUE NOT NULL,
	CONSTRAINT FK_Cliente_Clientes_Info FOREIGN KEY (ClienteId) REFERENCES Clientes(ClienteId) ON DELETE CASCADE
	);
GO

CREATE INDEX IX_Clientes_Info_ClienteId ON Clientes_Info (ClienteId); 
GO
CREATE INDEX IX_Clientes_Info_Data_nascimento ON Clientes_Info (Data_nascimento); 
GO
CREATE INDEX IX_Clientes_Info_Email ON Clientes_Info (Email); 
GO
CREATE INDEX IX_Clientes_Info_Telefone ON Clientes_Info (Telefone); 
GO
-- Clientes Morada ----------------------------------------------------------------------------------------------------
CREATE TABLE Clientes_Morada (
    MoradaId INT IDENTITY(1,3) PRIMARY KEY, 
    ClienteId INT NOT NULL,
    Rua NVARCHAR(255) NOT NULL,
    Número NVARCHAR(10) NOT NULL,  
    Andar NVARCHAR(10),
    Codigo_postal NVARCHAR(10),
    Cidade NVARCHAR(50),
    País NVARCHAR(50),
    CONSTRAINT FK_Cliente_Morada FOREIGN KEY (ClienteId) REFERENCES Clientes(ClienteId) ON DELETE CASCADE
);
GO

CREATE INDEX IX_Clientes_Morada_ClienteId ON Clientes_Morada (ClienteId);
GO
CREATE INDEX IX_Clientes_Morada_completa ON Clientes_Morada (Rua, Número, Andar, Codigo_postal, Cidade);
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// ALUGUERES //////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Reservas ----------------------------------------------------------------------------------------------------
CREATE TABLE Reservas (
	ReservaId INT IDENTITY(101,1) CONSTRAINT PK_Reservas_reservaId PRIMARY KEY(reservaId),
    Data_inicio DATE NOT NULL,
    Data_fim DATE NOT NULL,
	ClienteId INT NOT NULL,
	CarId INT NOT NULL,
	EmpId INT NOT NULL,
	Valor  DECIMAL(10, 2),
	Pagamento NVARCHAR(20) DEFAULT 'Pendente' CONSTRAINT CK_Reservas_Pagamento CHECK (Pagamento IN ('Pendente', 'Concluído')),
	Data_pagamento DATE,
	CONSTRAINT FK_Cliente_Reserva FOREIGN KEY (ClienteId) REFERENCES Clientes(ClienteId) ON DELETE CASCADE,
	CONSTRAINT FK_Carro_Reserva FOREIGN KEY (CarId) REFERENCES Carros(CarId),
	CONSTRAINT FK_Empregado_Reserva FOREIGN KEY (EmpId) REFERENCES Empregados(EmpId),
	CONSTRAINT CK_Reservas_data_fim CHECK (Data_inicio < Data_fim)
	);
GO

CREATE INDEX IX_Reservas_ClienteId ON Reservas (ClienteId);
GO
CREATE INDEX IX_Reservas_CarId ON Reservas (CarId);
GO
CREATE INDEX IX_Reservas_EmpId ON Reservas (EmpId);                   
GO
CREATE INDEX IX_Reservas_DataInicio_DataFim ON Reservas (Data_inicio, Data_fim);
GO
CREATE INDEX IX_Reservas_Pagamento_Data_pagamento ON Reservas (Pagamento, Data_pagamento);
GO

-- Entrega ----------------------------------------------------------------------------------------------------
CREATE TABLE Reservas_Entrega (
	EntregaId INT IDENTITY(1,1) CONSTRAINT PK_Entrega_EntregaId PRIMARY KEY(EntregaId),
	ReservaId INT NOT NULL,
	KM_finais  INT NOT NULL,
	CONSTRAINT FK_Reservas_Entrega FOREIGN KEY (ReservaId) REFERENCES Reservas(ReservaId) ON DELETE CASCADE
	);
GO

CREATE INDEX IX_Reservas_Entrega_ReservaId  ON Reservas_Entrega (ReservaId);    
GO
CREATE INDEX IX_Reservas_Entrega_KM_finais ON Reservas_Entrega (KM_finais);                   
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
--////////// TRIGGERS ////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Calcular valor ----------------------------------------------------------------------------------------------------
CREATE TRIGGER TRG_calc_valor
ON Reservas
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE R
    SET R.Valor = C.Preco_dia * DATEDIFF(DAY, I.Data_inicio, I.Data_fim)
    FROM Reservas AS R
    INNER JOIN INSERTED AS I ON R.ReservaId = I.ReservaId
    INNER JOIN Carros AS C ON I.CarId = C.CarId;
END;
GO

-- Update status carro para 'Reservado' ----------------------------------------------------------------------------------------------------
CREATE TRIGGER TRG_status_carros
ON Reservas
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE C
    SET C.StatusId = 'R'
    FROM Carros AS C
    INNER JOIN INSERTED AS I ON C.CarId = I.CarId
    WHERE I.Data_inicio <= GETDATE();
END;
GO

-- Update status carro para 'Disponível e acrescento de KM' ----------------------------------------------------------------------------------------------------
CREATE TRIGGER TRG_update_status_km_carro
ON Reservas_Entrega
AFTER INSERT
AS
BEGIN
    UPDATE C
    SET C.KM = C.KM + I.KM_finais,
        C.StatusId = 'D'
    FROM Carros AS C
    INNER JOIN Reservas AS R ON C.CarId = R.CarId
    INNER JOIN INSERTED AS I ON R.ReservaId = I.ReservaId;
END;
GO

-- Update status pagamento ----------------------------------------------------------------------------------------------------
CREATE TRIGGER TRG_update_pagamento
ON Reservas_Entrega
AFTER INSERT
AS
BEGIN
    UPDATE R
    SET R.Pagamento = 'Concluído', 
        R.Data_pagamento = GETDATE()
    FROM Reservas AS R
    INNER JOIN INSERTED AS I
        ON R.ReservaId = I.ReservaId;
END;
GO

-- Update status inicio manutencao ----------------------------------------------------------------------------------------------------
CREATE TRIGGER TRG_manutencao_inicio
ON Carros_Manutencao
AFTER INSERT
AS
BEGIN
    UPDATE C
    SET C.StatusId = 'M'
    FROM Carros AS C
    INNER JOIN INSERTED AS I ON C.CarId = I.CarId;
END;

-- Update status fim manutencao ----------------------------------------------------------------------------------------------------
CREATE TRIGGER TRG_manutencao_fim
ON Carros_Manutencao
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Data_fim)
    BEGIN
        UPDATE C
        SET C.StatusId = 'D'
        FROM Carros AS C
        INNER JOIN INSERTED AS I ON C.CarId = I.CarId
        WHERE I.Data_fim IS NOT NULL 
        AND I.ManutencaoId IN (SELECT ManutencaoId FROM INSERTED WHERE Data_fim IS NOT NULL);
    END
END;

