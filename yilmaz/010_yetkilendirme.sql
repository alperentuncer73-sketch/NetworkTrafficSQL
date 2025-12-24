-- HAFTA 10: Rol Bazlı Yetkilendirme

USE TrafficLogDB;
GO

-- Rolleri oluşturma --
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Role_Admin')
    CREATE ROLE Role_Admin;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Role_Analist')
    CREATE ROLE Role_Analist;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Role_Viewer')
    CREATE ROLE Role_Viewer;
GO

-- Admin: Tam yetki --
GRANT CONTROL ON SCHEMA::monitoring TO Role_Admin;
GRANT CONTROL ON SCHEMA::network TO Role_Admin;
GO

-- Analist: Sadece SELECT yetkisi --
GRANT SELECT ON monitoring.traffic_logs TO Role_Analist;
GRANT SELECT ON monitoring.alerts TO Role_Analist;
GRANT SELECT ON network.devices TO Role_Analist;
GO

-- Viewer: Kısıtlı yetki --
GRANT SELECT ON monitoring.alerts TO Role_Viewer;
GO

-- Son Kontrol --
SELECT name, type_desc FROM sys.database_principals WHERE type = 'R' AND name LIKE 'Role_%';
PRINT 'Hafta 10 tamamlandı.';
GO

