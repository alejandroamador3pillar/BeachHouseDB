CREATE TABLE [dbo].[Reservations]
(
	[Id] BIGINT NOT NULL PRIMARY KEY, 
    [date] DATETIME NOT NULL, 
    [user_id] BIGINT NOT NULL, 
    [location_id] BIGINT NOT NULL, 
    [active] BIT NOT NULL, 
    CONSTRAINT [FK_Users_ToReservation] FOREIGN KEY ([user_id]) REFERENCES [Users]([Id]), 
    CONSTRAINT [FK_Location_ToReservation] FOREIGN KEY ([location_id]) REFERENCES [Locations]([Id])
)
