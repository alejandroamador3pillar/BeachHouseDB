CREATE TABLE [dbo].[Users]
(
	[id] VARCHAR(50) NOT NULL PRIMARY KEY, 
    [role] INT NOT NULL DEFAULT 0, 
    [active] BIT NOT NULL DEFAULT 1, 
    [email] NVARCHAR(MAX) NULL, 
    [first_name] CHAR(50) NULL, 
    [last_name] CHAR(50) NULL, 
    [phone] INT NULL
)
