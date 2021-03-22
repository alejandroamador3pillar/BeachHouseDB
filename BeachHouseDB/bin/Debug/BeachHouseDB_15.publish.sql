/*
Script de implementación para beachhouse

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "beachhouse"
:setvar DefaultFilePrefix "beachhouse"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

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
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367)) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
    END


GO
PRINT N'La operación de refactorización Cambiar nombre con la clave 157948da-7ec8-480f-9e5d-ac2acdbb0511 se ha omitido; no se cambiará el nombre del elemento [dbo].[User].[Id] (SqlSimpleColumn) a id';


GO
PRINT N'La operación de refactorización Cambiar nombre con la clave 094332f9-b4cc-4cf3-9d94-a4d06cd4c6bd se ha omitido; no se cambiará el nombre del elemento [dbo].[Param].[created_by] (SqlSimpleColumn) a updated_by';


GO
PRINT N'Creando [dbo].[Locations]...';


GO
CREATE TABLE [dbo].[Locations] (
    [Id]          BIGINT       NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creando [dbo].[Params]...';


GO
CREATE TABLE [dbo].[Params] (
    [Id]            INT          NOT NULL,
    [description]   VARCHAR (50) NOT NULL,
    [value]         VARCHAR (50) NOT NULL,
    [start_date]    DATETIME     NULL,
    [end_date]      DATETIME     NULL,
    [updated_by]    VARCHAR (50) NOT NULL,
    [last_modified] DATETIME     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creando [dbo].[ReservationDetails]...';


GO
CREATE TABLE [dbo].[ReservationDetails] (
    [Id]             BIGINT IDENTITY (1, 1) NOT NULL,
    [reservation_id] BIGINT NOT NULL,
    [date]           DATE   NOT NULL,
    [rate]           BIGINT NULL,
    CONSTRAINT [PK_ReservationDetails] PRIMARY KEY CLUSTERED ([Id] ASC, [reservation_id] ASC)
);


GO
PRINT N'Creando [dbo].[Reservations]...';


GO
CREATE TABLE [dbo].[Reservations] (
    [Id]          BIGINT       IDENTITY (1, 1) NOT NULL,
    [date]        DATETIME     NOT NULL,
    [user_id]     VARCHAR (50) NOT NULL,
    [location_id] BIGINT       NOT NULL,
    [active]      BIT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creando [dbo].[Users]...';


GO
CREATE TABLE [dbo].[Users] (
    [id]     VARCHAR (50) NOT NULL,
    [role]   INT          NOT NULL,
    [active] BIT          NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Creando restricción sin nombre en [dbo].[Users]...';


GO
ALTER TABLE [dbo].[Users]
    ADD DEFAULT 0 FOR [role];


GO
PRINT N'Creando restricción sin nombre en [dbo].[Users]...';


GO
ALTER TABLE [dbo].[Users]
    ADD DEFAULT 1 FOR [active];


GO
PRINT N'Creando [dbo].[FK_Params_ToUser]...';


GO
ALTER TABLE [dbo].[Params] WITH NOCHECK
    ADD CONSTRAINT [FK_Params_ToUser] FOREIGN KEY ([updated_by]) REFERENCES [dbo].[Users] ([id]);


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
-- Paso de refactorización para actualizar el servidor de destino con los registros de transacciones implementadas

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '157948da-7ec8-480f-9e5d-ac2acdbb0511')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('157948da-7ec8-480f-9e5d-ac2acdbb0511')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '094332f9-b4cc-4cf3-9d94-a4d06cd4c6bd')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('094332f9-b4cc-4cf3-9d94-a4d06cd4c6bd')

GO

GO
