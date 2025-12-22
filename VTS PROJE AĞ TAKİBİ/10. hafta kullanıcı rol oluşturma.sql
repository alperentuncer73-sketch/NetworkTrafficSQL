USE [Ag takibi proje];
GO

--Rolleri Oluþturma
CREATE ROLE Role_Admin;    -- Her þeyi yapar
CREATE ROLE Role_Analist;  -- Sadece okur (SELECT)
CREATE ROLE Role_Viewer;   -- Sadece kýsýtlý raporlarý görür

-- Yetkileri Daðýtma (GRANT iþlemleri)
-- Admin tüm tablolara tam yetki
GRANT CONTROL ON DATABASE::[Ag takibi proje] TO Role_Admin;

-- Analist  loglarý ve uyarýlarý okuyabilsin ama silemesin
GRANT SELECT ON TrafficLogs TO Role_Analist;
GRANT SELECT ON SecurityAlerts TO Role_Analist;

-- Viewer sadece uyarýlarý görebilir loglarý göremez
GRANT SELECT ON SecurityAlerts TO Role_Viewer;


PRINT 'rol ve yetkileri oluþturduk';
USE [Ag takibi proje];
GO

-- Test kullanýcýlarýný (Login ve User) oluþturma

CREATE LOGIN Test_Admin WITH PASSWORD = '12345', CHECK_POLICY = OFF;
CREATE USER Test_Admin FOR LOGIN Test_Admin;

CREATE LOGIN Test_Analist WITH PASSWORD = '12345', CHECK_POLICY = OFF;
CREATE USER Test_Analist FOR LOGIN Test_Analist;

CREATE LOGIN Test_Viewer WITH PASSWORD = '12345', CHECK_POLICY = OFF;
CREATE USER Test_Viewer FOR LOGIN Test_Viewer;

-- 2. Kullanýcýlarý Rollere Ekle (Member Add)
ALTER ROLE Role_Admin ADD MEMBER Test_Admin;
ALTER ROLE Role_Analist ADD MEMBER Test_Analist;
ALTER ROLE Role_Viewer ADD MEMBER Test_Viewer;

PRINT 'test kullanýcýlarý oluþtuduk ve rollere atadýk';