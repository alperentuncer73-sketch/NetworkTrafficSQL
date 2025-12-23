-- == DATABASE CREATION == --
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TrafficLogDB')
BEGIN
    CREATE DATABASE TrafficLogDB;
END
GO

USE TrafficLogDB;
GO

-- == TABLE CREATION: TrafficLogs == --
DROP TABLE IF EXISTS TrafficLogs;
GO

CREATE TABLE TrafficLogs (

    LogID INT PRIMARY KEY IDENTITY(1,1), 
    EventTimestamp DATETIME2(7) NOT NULL DEFAULT GETDATE(), 

    DeviceID INT NULL, 
    UserID INT NULL,

    SourceIPAddress VARCHAR(45) NOT NULL,
    DestinationIPAddress VARCHAR(45) NOT NULL,
    DestinationPort INT NOT NULL, 
    Protocol VARCHAR(20) NOT NULL,

    DataTransferredMB DECIMAL(18, 4) NULL,
    PacketCount INT NULL, 
    AveragePacketSizeKB INT NULL,
    
    Status VARCHAR(50) NOT NULL,
    SecurityStatus VARCHAR(50) NULL,
    RiskLevel VARCHAR(20) NULL,
    LogType VARCHAR(50) NULL, 
    ApplicationName VARCHAR(50) NULL,

    SourceCountry VARCHAR(50) NULL, 
    DestinationCountry VARCHAR(50) NULL, 

    Notes NVARCHAR(255) NULL,

    -- == DATA INTEGRITY CONSTRAINTS == --
    CONSTRAINT CK_TrafficLogs_PortNumber CHECK (DestinationPort BETWEEN 0 AND 65535),
    CONSTRAINT CK_TrafficLogs_Protocol CHECK (Protocol IN ('TCP', 'UDP', 'HTTP', 'HTTPS', 'ICMP', 'DNS')), 
    CONSTRAINT CK_TrafficLogs_DataTransferred CHECK (DataTransferredMB >= 0),
    CONSTRAINT CK_TrafficLogs_RiskLevel CHECK (RiskLevel IN ('Low', 'Medium', 'High')),
    CONSTRAINT CK_TrafficLogs_Status CHECK (Status IN ('Allowed', 'Blocked'))
);
GO

-- == PERFORMANCE INDEXES == --
CREATE NONCLUSTERED INDEX IX_TrafficLogs_SourceIPAddress ON TrafficLogs(SourceIPAddress);
CREATE NONCLUSTERED INDEX IX_TrafficLogs_EventTimestamp ON TrafficLogs(EventTimestamp);
GO

PRINT 'TrafficLogs Table Setup has been completed';
GO