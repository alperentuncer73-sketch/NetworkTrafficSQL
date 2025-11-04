

------------------------------------------------------
-- 1. KATALOG (REFERANS) TABLOLARI (3NF için gerekli)
-- (Bu tablolar, tekrar eden metin verilerini tutarak normalizasyonu saðlar)
------------------------------------------------------

-- Cihaz Tipleri (cihaz_tipi bilgisini tutar)
CREATE TABLE DeviceTypes (
    TypeID SMALLINT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50) NOT NULL UNIQUE, 
    CHECK (TypeName IN ('Modem','Router','Switch','Access Point','Firewall')) 
);

-- Cihaz Modelleri (cihaz_marka ve cihaz_model bilgisini tutar, tekrarý engeller)
CREATE TABLE DeviceModels (
    ModelID INT PRIMARY KEY IDENTITY(1,1),
    Manufacturer VARCHAR(50) NOT NULL, -- Marka
    ModelName VARCHAR(50) NOT NULL,    -- Model
    UNIQUE (Manufacturer, ModelName) 
);

-- Protokol Tipleri (TrafficLogs için Protocol bilgisini tutar)
CREATE TABLE TrafficProtocols (
    ProtocolID TINYINT PRIMARY KEY IDENTITY(1,1),
    ProtocolName VARCHAR(20) NOT NULL UNIQUE, 
    DefaultPort INT NULL
);

-- Güvenlik Risk Seviyeleri (RiskLevel bilgisini tutar)
CREATE TABLE SecurityRiskLevels (
    RiskLevelID TINYINT PRIMARY KEY, -- 1=Low, 2=Medium, 3=High, 4=Critical
    RiskLevelName VARCHAR(20) NOT NULL UNIQUE
);

-- Coðrafi Konumlar (SourceCountry/DestinationCountry bilgisini tutar)
CREATE TABLE GeoLocations (
    CountryID SMALLINT PRIMARY KEY IDENTITY(1,1),
    CountryName VARCHAR(50) NOT NULL UNIQUE
);


------------------------------------------------------
-- 2. ANA VERÝ TABLOLARI (Normalleþtirilmiþ Tablolar)
------------------------------------------------------

-- KULLANICILAR TABLOSU (Users)
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    Department VARCHAR(50),
    Title VARCHAR(50) DEFAULT 'User',
    AssignedIP VARCHAR(50), 
    MACAddress VARCHAR(50),
    PasswordHash VARCHAR(255),
    LastLoginDate DATETIME,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    Role VARCHAR(50) DEFAULT 'Standard',
    PermissionLevel INT DEFAULT 1, 
    Notes NVARCHAR(255)
);

-- CÝHAZLAR TABLOSU (Devices)
CREATE TABLE Devices (
    DeviceID INT PRIMARY KEY IDENTITY(1,1),
    
    -- Foreign Keys (FK) ile normalleþtirildi
    TypeID SMALLINT NOT NULL,          -- FK to DeviceTypes (Tip için)
    ModelID INT NOT NULL,              -- FK to DeviceModels (Marka/Model için)
    
    DeviceIP VARCHAR(50) UNIQUE NOT NULL,
    SerialNumber VARCHAR(100) UNIQUE,
    Location VARCHAR(100),
    SoftwareVersion VARCHAR(50),
    HardwareVersion VARCHAR(50),
    OperatingSystem VARCHAR(50) DEFAULT 'Embedded Linux',
    Status VARCHAR(20) DEFAULT 'Active',
    InstallationDate DATETIME DEFAULT GETDATE(),
    LastUpdate DATETIME DEFAULT GETDATE(),
    Manager VARCHAR(50) DEFAULT 'Admin',
    SupportEmail VARCHAR(100),
    WarrantyExpirationDate DATE NULL,
    Notes NVARCHAR(255)
);

-- TRAFÝK KAYITLARI TABLOSU (TrafficLogs)
CREATE TABLE TrafficLogs (
    LogID BIGINT PRIMARY KEY IDENTITY(1,1),
    EventTimestamp DATETIME2(7) NOT NULL DEFAULT GETDATE(),
    
    -- Foreign Keys (FK)
    DeviceID INT NULL,                    -- FK to Devices 
    UserID INT NULL,                      -- FK to Users 
    ProtocolID TINYINT NOT NULL,          -- FK to TrafficProtocols 
    RiskLevelID TINYINT NULL,             -- FK to SecurityRiskLevels 
    SourceCountryID SMALLINT NULL,        -- FK to GeoLocations 
    DestinationCountryID SMALLINT NULL,   -- FK to GeoLocations 

    SourceIPAddress VARCHAR(45) NOT NULL,
    DestinationIPAddress VARCHAR(45) NOT NULL,
    DestinationPort INT NOT NULL,
    
    DataTransferredMB DECIMAL(18, 4) NULL,
    PacketCount BIGINT NULL,
    Status VARCHAR(50) NOT NULL
);


------------------------------------------------------
-- 3. FOREIGN KEY (Yabancý Anahtar) ÝLÝÞKÝLERÝ
-- (Tüm tablolar arasýndaki iliþkileri kurar)
------------------------------------------------------

-- Devices (Cihazlar) Tablosunun Ýliþkileri
ALTER TABLE Devices
ADD CONSTRAINT FK_Devices_TypeID FOREIGN KEY (TypeID) REFERENCES DeviceTypes(TypeID),
    CONSTRAINT FK_Devices_ModelID FOREIGN KEY (ModelID) REFERENCES DeviceModels(ModelID);

-- TrafficLogs (Trafik Kayýtlarý) Tablosunun Ýliþkileri
ALTER TABLE TrafficLogs
ADD CONSTRAINT FK_Logs_DeviceID FOREIGN KEY (DeviceID) REFERENCES Devices(DeviceID),
    CONSTRAINT FK_Logs_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Logs_ProtocolID FOREIGN KEY (ProtocolID) REFERENCES TrafficProtocols(ProtocolID),
    CONSTRAINT FK_Logs_RiskLevelID FOREIGN KEY (RiskLevelID) REFERENCES SecurityRiskLevels(RiskLevelID),
    CONSTRAINT FK_Logs_SourceCountryID FOREIGN KEY (SourceCountryID) REFERENCES GeoLocations(CountryID),
    CONSTRAINT FK_Logs_DestinationCountryID FOREIGN KEY (DestinationCountryID) REFERENCES GeoLocations(CountryID);

------------------------------------------------------
-- 4. BAÞLANGIÇ VERÝLERÝNÝ EKLEME (Analiz için gerekli)
------------------------------------------------------

--INSERT INTO TrafficProtocols (ProtocolName, DefaultPort) VALUES ('TCP', NULL), ('UDP', NULL), ('HTTP', 80), ('HTTPS', 443), ('DNS', 53);
--INSERT INTO DeviceTypes (TypeName) VALUES ('Router'), ('Switch'), ('Modem'), ('Firewall');
--INSERT INTO DeviceModels (Manufacturer, ModelName) VALUES ('Cisco', '2900 Series'), ('HP', 'Aruba 3810M'), ('D-Link', 'DIR-868L');
--INSERT INTO GeoLocations (CountryName) VALUES ('Turkey'), ('USA'), ('Germany'), ('China');

------------------------------------------------------
-- 5. PERFORMANS ÝNDEKSLERÝ
------------------------------------------------------
--Bu kodlar, veritabaný sorgularýný çok daha hýzlý hale getirmek için ÝNDEKS (INDEX) oluþturur.
CREATE NONCLUSTERED INDEX IX_TrafficLogs_SourceIPAddress ON TrafficLogs(SourceIPAddress);
--TrafficLogs tablosunda SourceIPAddress (Kaynak IP Adresi) sütununa göre yapýlan aramalarý (örneðin, WHERE SourceIPAddress = '...') aþýrý hýzlandýrýr.

CREATE NONCLUSTERED INDEX IX_TrafficLogs_EventTimestamp ON TrafficLogs(EventTimestamp);
--TrafficLogs tablosunda EventTimestamp (Zaman Damgasý) sütununa göre yapýlan aramalarý hýzlandýrýr.
CREATE INDEX IDX_Users_Name ON Users(FirstName, LastName);
GO

PRINT '2. Hafta Normalizasyon ve Þema Kurulumu Baþarýyla Tamamlandý.';
GO