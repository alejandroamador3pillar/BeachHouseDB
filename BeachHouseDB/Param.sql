CREATE TABLE [dbo].[Param]
(
	[Id] INT NOT NULL , 
    [description] VARCHAR(50) NOT NULL, 
    [value] VARCHAR(50) NOT NULL, 
    [start_date] DATETIME NULL, 
    [end_date] DATETIME NULL, 
    PRIMARY KEY ([Id])
)
