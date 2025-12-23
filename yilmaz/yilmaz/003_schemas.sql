-- HAFTA 3: Schema Olusturma
-- Amac: network ve monitoring semalarini olusturmak

USE TrafficLogDB;
GO

-- Semalari olustur
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'network')
    EXEC('CREATE SCHEMA network');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'monitoring')
    EXEC('CREATE SCHEMA monitoring');
GO

-- network.devices
DROP TABLE IF EXISTS network.devices;
GO

CREATE TABLE network.devices (
    device_id INT PRIMARY KEY IDENTITY(1,1),
    device_name VARCHAR(50) NOT NULL,
    device_type VARCHAR(30) NOT NULL,
    ip_address VARCHAR(50) NOT NULL,
    location VARCHAR(100) NULL,
    status VARCHAR(20) DEFAULT 'Active'
);
GO

-- network.users
DROP TABLE IF EXISTS network.users;
GO

CREATE TABLE network.users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    user_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NULL,
    department VARCHAR(50) NULL,
    created_date DATETIME DEFAULT GETDATE()
);
GO

-- monitoring.traffic_logs
DROP TABLE IF EXISTS monitoring.traffic_logs;
GO

CREATE TABLE monitoring.traffic_logs (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    device_id INT NOT NULL,
    source_ip VARCHAR(50) NOT NULL,
    dest_ip VARCHAR(50) NOT NULL,
    port_no INT NOT NULL,
    protocol VARCHAR(20) NOT NULL,
    data_size DECIMAL(10,2) NULL,
    status VARCHAR(20) NOT NULL,
    log_time DATETIME DEFAULT GETDATE()
);
GO

-- monitoring.alerts
DROP TABLE IF EXISTS monitoring.alerts;
GO

CREATE TABLE monitoring.alerts (
    alert_id INT PRIMARY KEY IDENTITY(1,1),
    device_id INT NOT NULL,
    message VARCHAR(255) NOT NULL,
    level VARCHAR(20) NOT NULL,
    time_detected DATETIME DEFAULT GETDATE()
);
GO

-- Kontrol
SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA IN ('network', 'monitoring');
PRINT 'Hafta 3 tamamlandi.';
GO
