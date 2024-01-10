USE [weatherdb];
GO

-- Create DataModels table
CREATE TABLE [dbo].[DataModels] (
    [Id] INT IDENTITY(1,1) NOT NULL,
    [FullPowerMode] BIT NULL,
    [ActivePowerControl] BIT NULL,
    [FirmwareVersion] INT NULL,
    [Temperature] INT NULL,
    [Humidity] INT NULL,
    [Version] INT NULL,
    [MessageType] NVARCHAR(MAX) NULL,
    [Occupancy] BIT NULL,
    [StateChanged] INT NULL,
    CONSTRAINT [PK_DataModels] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];




-- Create PayloadDataModels table
CREATE TABLE [dbo].[PayloadDataModels] (
    [Id] INT IDENTITY(1,1) NOT NULL,
    [DeviceId] NVARCHAR(MAX) NOT NULL,
    [DeviceType] NVARCHAR(MAX) NOT NULL,
    [DeviceName] NVARCHAR(MAX) NOT NULL,
    [GroupId] NVARCHAR(MAX) NOT NULL,
    [DataType] NVARCHAR(MAX) NOT NULL,
    [DataId] INT NOT NULL,
    [Timestamp] BIGINT NOT NULL,
    CONSTRAINT [PK_PayloadDataModels] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


-- Add foreign key constraint to reference DataModels table
ALTER TABLE [dbo].[PayloadDataModels] 
WITH CHECK ADD CONSTRAINT [FK_PayloadDataModels_DataModels_DataId] 
FOREIGN KEY ([DataId]) REFERENCES [dbo].[DataModels] ([Id]);


-- Enable check constraint for foreign key
ALTER TABLE [dbo].[PayloadDataModels] CHECK CONSTRAINT [FK_PayloadDataModels_DataModels_DataId];



-- Insert dummy data into DataModels table
INSERT INTO [dbo].[DataModels] 
    ([FullPowerMode], [ActivePowerControl], [FirmwareVersion], [Temperature], [Humidity], [Version], [MessageType], [Occupancy], [StateChanged])
VALUES
    (0, 0, 1, 21, 53, NULL, NULL, NULL, NULL),
    (NULL, NULL, NULL, NULL, NULL, 3, 'periodic', 0, NULL);

-- Insert dummy data into PayloadDataModels table
INSERT INTO [dbo].[PayloadDataModels] 
    ([DeviceId], [DeviceType], [DeviceName], [GroupId], [DataType], [DataId], [Timestamp])
VALUES
    ('ibm-878A66', 'computer1.0.0', 'VN1-1-3', '847b3b2f1b05dc4', 'DATA', SCOPE_IDENTITY(), 1629369697),
    ('ibm-00976A', 'computer1.0.0', 'VN1-1-4', '49548881c4d2bea9', 'DATA', SCOPE_IDENTITY(), 1629629040);




-- Insert additional dummy data into DataModels table
INSERT INTO [dbo].[DataModels] 
    ([FullPowerMode], [ActivePowerControl], [FirmwareVersion], [Temperature], [Humidity], [Version], [MessageType], [Occupancy], [StateChanged])
VALUES
    (1, 1, 2, 25, 60, NULL, NULL, NULL, NULL),
    (NULL, NULL, NULL, NULL, NULL, 4, 'event', 1, 1),
    (0, 1, 3, 19, 45, NULL, NULL, NULL, NULL);

-- Insert additional dummy data into PayloadDataModels table
INSERT INTO [dbo].[PayloadDataModels] 
    ([DeviceId], [DeviceType], [DeviceName], [GroupId], [DataType], [DataId], [Timestamp])
VALUES
    ('ibm-765B23', 'sensor2.0.0', 'VN2-2-1', '3ac41e1b7f9a8d1', 'DATA', SCOPE_IDENTITY(), 1630123456),
    ('ibm-110CDE', 'actuator1.5.0', 'VN3-1-5', 'b7ef85a48d2c7a4', 'DATA', SCOPE_IDENTITY(), 1630245678),
    ('ibm-XYZ123', 'sensor1.2.0', 'VN1-2-3', 'f6e59d4b1c8a1b3', 'DATA', SCOPE_IDENTITY(), 1630367890);



-- Insert additional dummy data into DataModels table
INSERT INTO [dbo].[DataModels] 
    ([FullPowerMode], [ActivePowerControl], [FirmwareVersion], [Temperature], [Humidity], [Version], [MessageType], [Occupancy], [StateChanged])
VALUES
    (1, 0, 4, 22, 55, NULL, NULL, NULL, NULL),
    (0, 1, 2, 18, 40, NULL, NULL, NULL, NULL);

-- Insert additional dummy data into PayloadDataModels table
INSERT INTO [dbo].[PayloadDataModels] 
    ([DeviceId], [DeviceType], [DeviceName], [GroupId], [DataType], [DataId], [Timestamp])
VALUES
    ('ibm-ABC456', 'actuator2.1.0', 'VN4-1-2', 'a1b2c3d4e5f6', 'DATA', SCOPE_IDENTITY(), 1630489123),
    ('ibm-XYZ789', 'sensor1.1.1', 'VN5-2-4', '9876543210abcde', 'DATA', SCOPE_IDENTITY(), 1630612345);




-- Verify the inserted data in DataModels table
SELECT * FROM [dbo].[DataModels];

-- Verify the inserted data in PayloadDataModels table
SELECT * FROM [dbo].[PayloadDataModels];



-- Select combined data from both tables
SELECT
    PD.[Id] AS PayloadId,
    PD.[DeviceId],
    PD.[DeviceType],
    PD.[DeviceName],
    PD.[GroupId],
    PD.[DataType],
    PD.[Timestamp],
    DM.[Id] AS DataId,
    DM.[FullPowerMode],
    DM.[ActivePowerControl],
    DM.[FirmwareVersion],
    DM.[Temperature],
    DM.[Humidity],
    DM.[Version],
    DM.[MessageType],
    DM.[Occupancy],
    DM.[StateChanged]
FROM
    [dbo].[PayloadDataModels] PD
JOIN
    [dbo].[DataModels] DM ON PD.[DataId] = DM.[Id];
