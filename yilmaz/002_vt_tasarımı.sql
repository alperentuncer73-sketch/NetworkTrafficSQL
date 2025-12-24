-- HAFTA 2: Veritabanı Tasarımı --
USE TrafficLogDB;
GO 

DROP TABLE IF EXISTS Alerts;
DROP TABLE IF EXISTS TrafficLogs;
DROP TABLE IF EXISTS Devices;

-- 1. DEVICES tablosu oluşturuldu --
GO 
CREATE TABLE Devices (
    device_id INT PRIMARY KEY IDENTITY(1, 1),
    device_name VARCHAR(50) NOT NULL,
    device_type VARCHAR(30) NOT NULL,
    ip_address VARCHAR(50) NOT NULL,
    location VARCHAR(100) NULL,
    status VARCHAR(20) DEFAULT 'Active'
    );

-- 2. TRAFFIC_LOGS tablosu oluşturuldu --
GO 
CREATE TABLE TrafficLogs (
    log_id INT PRIMARY KEY IDENTITY(1, 1),
    device_id INT NOT NULL,
    source_ip VARCHAR(50) NOT NULL,
    dest_ip VARCHAR(50) NOT NULL,
    port_no INT NOT NULL,
    protocol VARCHAR(20) NOT NULL,
    data_size DECIMAL(10, 2) NULL,
    status VARCHAR(20) NOT NULL,
    log_time DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TrafficLogs_Devices FOREIGN KEY (device_id) REFERENCES Devices(device_id)
    );

-- 3. ALERTS tablosu oluşturuldu --
GO 
CREATE TABLE Alerts (
    alert_id INT PRIMARY KEY IDENTITY(1, 1),
    device_id INT NOT NULL,
    message VARCHAR(255) NOT NULL,
    level VARCHAR(20) NOT NULL,
    time_detected DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Alerts_Devices FOREIGN KEY (device_id) REFERENCES Devices(device_id)
    );

 -- Son Kontrol --
GO
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
PRINT 'Hafta 2 tamamlandı.';
GO