CREATE TABLE [dbo].[Params]
(
	[Id] INT NOT NULL , 
    [description] VARCHAR(50) NOT NULL, 
    [value] VARCHAR(MAX) NOT NULL, 
    [start_date] DATETIME NULL, 
    [end_date] DATETIME NULL, 
    [updated_by] VARCHAR(50) NOT NULL, 
    [last_modified] DATETIME NOT NULL, 
    PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_Params_ToUser] FOREIGN KEY (updated_by) REFERENCES Users(id)
)
