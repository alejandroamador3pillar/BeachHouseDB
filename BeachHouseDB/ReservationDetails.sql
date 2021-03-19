CREATE TABLE [dbo].[ReservationDetails]
(
	[Id] BIGINT IDENTITY NOT NULL, 
    [reservation_id] BIGINT NOT NULL, 
    [date] DATE NOT NULL, 
    [rate] BIGINT NULL 
    CONSTRAINT [FK_ReservationDetails_ToMaster] FOREIGN KEY ([reservation_id]) REFERENCES [Reservations]([Id]), 
    CONSTRAINT [PK_ReservationDetails] PRIMARY KEY ([Id], [reservation_id])
)
