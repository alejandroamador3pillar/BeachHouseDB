/*
Script de implementación para BeachHouseDB

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BeachHouseDB"
:setvar DefaultFilePrefix "BeachHouseDB"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detectar el modo SQLCMD y deshabilitar la ejecución del script si no se admite el modo SQLCMD.
Para volver a habilitar el script después de habilitar el modo SQLCMD, ejecute lo siguiente:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'El modo SQLCMD debe estar habilitado para ejecutar correctamente este script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
El tipo de la columna updated_by en la tabla [dbo].[Params] es  DATETIME NOT NULL, pero se va a cambiar a  BIGINT NOT NULL. Si la columna contiene datos no compatibles con el tipo  BIGINT NOT NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Params])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Params]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Params] (
    [Id]            INT          NOT NULL,
    [description]   VARCHAR (50) NOT NULL,
    [value]         VARCHAR (50) NOT NULL,
    [start_date]    DATETIME     NULL,
    [end_date]      DATETIME     NULL,
    [updated_by]    BIGINT       NOT NULL,
    [last_modified] DATETIME     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Params])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Params] ([Id], [description], [value], [start_date], [end_date], [updated_by], [last_modified])
        SELECT   [Id],
                 [description],
                 [value],
                 [start_date],
                 [end_date],
                 CAST ([updated_by] AS BIGINT),
                 [last_modified]
        FROM     [dbo].[Params]
        ORDER BY [Id] ASC;
    END

DROP TABLE [dbo].[Params];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Params]', N'Params';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Actualización completada.';


GO
