CREATE TABLE Seasons
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [descriptionSeason] VARCHAR(50) NOT NULL, 
	[typeseason] INT NOT NULL, 
    [startdate] DATE NOT NULL, 
    [enddate] DATE NOT NULL,
    [ACTIVE] BIT NOT NULL,
)

