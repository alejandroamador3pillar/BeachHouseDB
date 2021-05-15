CREATE TABLE [dbo].[Reservations]
(
	[Id] BIGINT IDENTITY NOT NULL PRIMARY KEY, 
    [date] DATETIME NOT NULL, 
    [user_id] VARCHAR(50) NOT NULL, 
    [location_id] BIGINT NOT NULL, 
    [active] BIT NOT NULL, 
    [notified] BIT NULL, 
    [created_by] VARCHAR(50) NULL, 
    CONSTRAINT [FK_Users_ToReservation] FOREIGN KEY ([user_id]) REFERENCES [Users]([Id]), 
    CONSTRAINT [FK_Users_ToReservation2] FOREIGN KEY ([created_by]) REFERENCES [Users]([Id]), 
    CONSTRAINT [FK_Location_ToReservation] FOREIGN KEY ([location_id]) REFERENCES [Locations]([Id])

)
