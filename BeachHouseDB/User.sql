﻿CREATE TABLE [dbo].[User]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [role] INT NOT NULL DEFAULT 0, 
    [active] BIT NOT NULL DEFAULT 1
)
