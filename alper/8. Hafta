USE AgTrafikDB;
GO

-- ===========================================
-- ROLLERİ OLUŞTUR
-- ===========================================

-- 1. Yönetici Rolü
CREATE ROLE AdminRole;
-- 2. Analiz Rolü
CREATE ROLE AnalystRole;
-- 3. Görüntüleyici Rolü
CREATE ROLE ViewerRole;
GO

-- ===========================================
-- ADMIN ROLE YETKİLERİ
-- ===========================================
GRANT SELECT, INSERT, UPDATE, DELETE ON Cihazlar TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Kullanici TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON TrafikKayitlari TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Uyarilar TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON GunlukRaporlar TO AdminRole;
GO

-- ===========================================
-- ANALYST ROLE YETKİLERİ
-- ===========================================
GRANT SELECT ON TrafikKayitlari TO AnalystRole;
GRANT SELECT ON GunlukRaporlar TO AnalystRole;
GRANT SELECT ON Uyarilar TO AnalystRole;
GRANT EXECUTE TO AnalystRole;
GO

-- ===========================================
-- VIEWER ROLE YETKİLERİ
-- ===========================================
GRANT SELECT ON TrafikKayitlari TO ViewerRole;
GRANT SELECT ON GunlukRaporlar TO ViewerRole;
GO

-- ===========================================
-- KULLANICI OLUŞTURMA VE ROL ATAMA
-- ===========================================

-- 1. Admin kullanıcı
CREATE LOGIN AdminUser WITH PASSWORD = 'Admin123!';
CREATE USER AdminUser FOR LOGIN AdminUser;
ALTER ROLE AdminRole ADD MEMBER AdminUser;
GO

-- 2. Analyst kullanıcı
CREATE LOGIN AnalystUser WITH PASSWORD = 'Analyst123!';
CREATE USER AnalystUser FOR LOGIN AnalystUser;
ALTER ROLE AnalystRole ADD MEMBER AnalystUser;
GO

-- 3. Viewer kullanıcı
CREATE LOGIN ViewerUser WITH PASSWORD = 'Viewer123!';
CREATE USER ViewerUser FOR LOGIN ViewerUser;
ALTER ROLE ViewerRole ADD MEMBER ViewerUser;
GO
