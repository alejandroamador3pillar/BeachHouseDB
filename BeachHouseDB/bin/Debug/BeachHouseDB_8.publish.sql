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
PRINT N'Creando [dbo].[Locations]...';


GO
CREATE TABLE [dbo].[Locations] (
    [Id]          BIGINT       NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creando [dbo].[ReservationDetails]...';


GO
CREATE TABLE [dbo].[ReservationDetails] (
    [Id]             BIGINT NOT NULL,
    [reservation_id] BIGINT NOT NULL,
    [date]           DATE   NOT NULL,
    [rate]           BIGINT NULL,
    CONSTRAINT [PK_ReservationDetails] PRIMARY KEY CLUSTERED ([Id] ASC, [reservation_id] ASC)
);


GO
PRINT N'Creando [dbo].[Reservations]...';


GO
CREATE TABLE [dbo].[Reservations] (
    [Id]          BIGINT   NOT NULL,
    [date]        DATETIME NOT NULL,
    [user_id]     BIGINT   NOT NULL,
    [location_id] BIGINT   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creando [dbo].[FK_ReservationDetails_ToMaster]...';


GO
ALTER TABLE [dbo].[ReservationDetails] WITH NOCHECK
    ADD CONSTRAINT [FK_ReservationDetails_ToMaster] FOREIGN KEY ([reservation_id]) REFERENCES [dbo].[Reservations] ([Id]);


GO
PRINT N'Creando [dbo].[FK_Users_ToReservation]...';


GO
ALTER TABLE [dbo].[Reservations] WITH NOCHECK
    ADD CONSTRAINT [FK_Users_ToReservation] FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users] ([id]);


GO
PRINT N'Creando [dbo].[FK_Location_ToReservation]...';


GO
ALTER TABLE [dbo].[Reservations] WITH NOCHECK
    ADD CONSTRAINT [FK_Location_ToReservation] FOREIGN KEY ([location_id]) REFERENCES [dbo].[Locations] ([Id]);


GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[ReservationDetails] WITH CHECK CHECK CONSTRAINT [FK_ReservationDetails_ToMaster];

ALTER TABLE [dbo].[Reservations] WITH CHECK CHECK CONSTRAINT [FK_Users_ToReservation];

ALTER TABLE [dbo].[Reservations] WITH CHECK CHECK CONSTRAINT [FK_Location_ToReservation];


GO
PRINT N'Actualización completada.';


GO
