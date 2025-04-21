
-- ===============================
-- SISTEMA DE GESTIÓN DE HISTORIA CLÍNICA ELECTRÓNICA (HCE)
-- Autor: Jose Santiago Aranda Balderas
-- Unidad 6 - Bases de Datos
-- ===============================

-- ===============================
-- 1. CREACIÓN DE TABLAS
-- ===============================

CREATE TABLE Paciente (
    ID_Paciente INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Sexo CHAR(1),
    CURP NVARCHAR(18) UNIQUE,
    Telefono NVARCHAR(15),
    Correo NVARCHAR(100)
);

CREATE TABLE Especialidad (
    ID_Especialidad INT PRIMARY KEY IDENTITY(1,1),
    NombreEspecialidad NVARCHAR(100) NOT NULL
);

CREATE TABLE Medico (
    ID_Medico INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    CedulaProfesional NVARCHAR(20) UNIQUE NOT NULL,
    ID_Especialidad INT,
    FOREIGN KEY (ID_Especialidad) REFERENCES Especialidad(ID_Especialidad)
);

CREATE TABLE HistorialMedico (
    ID_Historial INT PRIMARY KEY IDENTITY(1,1),
    ID_Paciente INT NOT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    Descripcion NVARCHAR(MAX),
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);

CREATE TABLE ConsultaMedica (
    ID_Consulta INT PRIMARY KEY IDENTITY(1,1),
    ID_Historial INT NOT NULL,
    ID_Medico INT NOT NULL,
    FechaConsulta DATETIME NOT NULL,
    MotivoConsulta NVARCHAR(200),
    Diagnostico NVARCHAR(MAX),
    FOREIGN KEY (ID_Historial) REFERENCES HistorialMedico(ID_Historial),
    FOREIGN KEY (ID_Medico) REFERENCES Medico(ID_Medico)
);

CREATE TABLE PruebaDiagnostica (
    ID_Prueba INT PRIMARY KEY IDENTITY(1,1),
    ID_Consulta INT NOT NULL,
    NombrePrueba NVARCHAR(200),
    FechaPrueba DATE,
    Resultado NVARCHAR(MAX),
    FOREIGN KEY (ID_Consulta) REFERENCES ConsultaMedica(ID_Consulta)
);

CREATE TABLE Medicamento (
    ID_Medicamento INT PRIMARY KEY IDENTITY(1,1),
    NombreMedicamento NVARCHAR(100),
    Dosis NVARCHAR(50),
    Indicaciones NVARCHAR(MAX)
);

CREATE TABLE RecetaMedica (
    ID_Receta INT PRIMARY KEY IDENTITY(1,1),
    ID_Consulta INT NOT NULL,
    FechaReceta DATE DEFAULT GETDATE(),
    FOREIGN KEY (ID_Consulta) REFERENCES ConsultaMedica(ID_Consulta)
);

CREATE TABLE RecetaMedicamento (
    ID_Receta INT,
    ID_Medicamento INT,
    PRIMARY KEY (ID_Receta, ID_Medicamento),
    FOREIGN KEY (ID_Receta) REFERENCES RecetaMedica(ID_Receta),
    FOREIGN KEY (ID_Medicamento) REFERENCES Medicamento(ID_Medicamento)
);

CREATE TABLE UsuarioSistema (
    ID_Usuario INT PRIMARY KEY IDENTITY(1,1),
    NombreUsuario NVARCHAR(100) UNIQUE NOT NULL,
    Contraseña NVARCHAR(255) NOT NULL,
    Rol NVARCHAR(50),
    FechaRegistro DATETIME DEFAULT GETDATE()
);

GO

-- ===============================
-- 2. FUNCIONES Y PROCEDIMIENTOS
-- ===============================

GO
CREATE FUNCTION fn_CalcularEdad (@FechaNacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Edad INT;
    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, GETDATE());
    IF (MONTH(@FechaNacimiento) > MONTH(GETDATE()))
       OR (MONTH(@FechaNacimiento) = MONTH(GETDATE()) AND DAY(@FechaNacimiento) > DAY(GETDATE()))
       SET @Edad = @Edad - 1;
    RETURN @Edad;
END;

GO
CREATE PROCEDURE sp_InsertarConsultaMedica
    @ID_Historial INT,
    @ID_Medico INT,
    @FechaConsulta DATETIME,
    @MotivoConsulta NVARCHAR(200),
    @Diagnostico NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO ConsultaMedica (ID_Historial, ID_Medico, FechaConsulta, MotivoConsulta, Diagnostico)
    VALUES (@ID_Historial, @ID_Medico, @FechaConsulta, @MotivoConsulta, @Diagnostico);
END;

-- ===============================
-- 3. VISTAS
-- ===============================

GO
CREATE VIEW vw_HistorialPaciente AS
SELECT 
    P.ID_Paciente,
    P.Nombre + ' ' + P.Apellido AS NombreCompleto,
    H.ID_Historial,
    H.FechaCreacion,
    C.ID_Consulta,
    C.FechaConsulta,
    C.MotivoConsulta,
    C.Diagnostico,
    M.Nombre + ' ' + M.Apellido AS MedicoTratante,
    E.NombreEspecialidad
FROM Paciente P
INNER JOIN HistorialMedico H ON P.ID_Paciente = H.ID_Paciente
INNER JOIN ConsultaMedica C ON H.ID_Historial = C.ID_Historial
INNER JOIN Medico M ON C.ID_Medico = M.ID_Medico
INNER JOIN Especialidad E ON M.ID_Especialidad = E.ID_Especialidad;

GO
CREATE VIEW vw_ResultadosPruebas AS
SELECT 
    C.ID_Consulta,
    C.FechaConsulta,
    P.Nombre + ' ' + P.Apellido AS NombrePaciente,
    PD.NombrePrueba,
    PD.FechaPrueba,
    PD.Resultado
FROM ConsultaMedica C
INNER JOIN HistorialMedico H ON C.ID_Historial = H.ID_Historial
INNER JOIN Paciente P ON H.ID_Paciente = P.ID_Paciente
INNER JOIN PruebaDiagnostica PD ON C.ID_Consulta = PD.ID_Consulta;

GO
CREATE VIEW vw_RecetasConMedicamentos AS
SELECT 
    R.ID_Receta,
    C.ID_Consulta,
    P.Nombre + ' ' + P.Apellido AS NombrePaciente,
    M.NombreMedicamento,
    M.Dosis,
    M.Indicaciones,
    R.FechaReceta
FROM RecetaMedica R
INNER JOIN ConsultaMedica C ON R.ID_Consulta = C.ID_Consulta
INNER JOIN HistorialMedico H ON C.ID_Historial = H.ID_Historial
INNER JOIN Paciente P ON H.ID_Paciente = P.ID_Paciente
INNER JOIN RecetaMedicamento RM ON R.ID_Receta = RM.ID_Receta
INNER JOIN Medicamento M ON RM.ID_Medicamento = M.ID_Medicamento;

-- ===============================
-- 4. ÍNDICES
-- ===============================

GO
CREATE NONCLUSTERED INDEX IX_FechaConsulta
ON ConsultaMedica (FechaConsulta);

GO
CREATE NONCLUSTERED INDEX IX_NombrePrueba
ON PruebaDiagnostica (NombrePrueba);
