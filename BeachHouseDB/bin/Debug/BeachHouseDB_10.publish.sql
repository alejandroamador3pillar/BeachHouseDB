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
Debe agregarse la columna [dbo].[Reservations].[active] de la tabla [dbo].[Reservations], pero esta columna no tiene un valor predeterminado y no admite valores NULL. Si la tabla contiene datos, el script ALTER no funcionará. Para evitar esta incidencia, agregue un valor predeterminado a la columna, márquela de modo que permita valores NULL o habilite la generación de valores predeterminados inteligentes como opción de implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Reservations])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'Quitando [dbo].[FK_ReservationDetails_ToMaster]...';


GO
ALTER TABLE [dbo].[ReservationDetails] DROP CONSTRAINT [FK_ReservationDetails_ToMaster];


GO
PRINT N'Quitando [dbo].[FK_Users_ToReservation]...';


GO
ALTER TABLE [dbo].[Reservations] DROP CONSTRAINT [FK_Users_ToReservation];


GO
PRINT N'Quitando [dbo].[FK_Location_ToReservation]...';


GO
ALTER TABLE [dbo].[Reservations] DROP CONSTRAINT [FK_Location_ToReservation];


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Reservations]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Reservations] (
    [Id]          BIGINT   IDENTITY (1, 1) NOT NULL,
    [date]        DATETIME NOT NULL,
    [user_id]     BIGINT   NOT NULL,
    [location_id] BIGINT   NOT NULL,
    [active]      BIT      NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Reservations])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Reservations] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Reservations] ([Id], [date], [user_id], [location_id])
        SELECT   [Id],
                 [date],
                 [user_id],
                 [location_id]
        FROM     [dbo].[Reservations]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Reservations] OFF;
    END

DROP TABLE [dbo].[Reservations];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Reservations]', N'Reservations';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


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
