-- HAFTA 7: View Oluşturma

USE TrafficLogDB;
GO

-- Gunluk trafik ozeti
DROP VIEW IF EXISTS monitoring.GunlukTrafikOzet;
GO

CREATE VIEW monitoring.GunlukTrafikOzet AS
SELECT CAST(log_time AS DATE) AS gun, SUM(data_size) AS toplam_veri_mb, COUNT(*) AS baglanti_sayisi
FROM monitoring.traffic_logs
GROUP BY CAST(log_time AS DATE);
GO

-- Cihaz trafik ozeti
DROP VIEW IF EXISTS monitoring.CihazTrafikOzet;
GO

CREATE VIEW monitoring.CihazTrafikOzet AS
SELECT device_id, SUM(data_size) AS toplam_veri_mb, COUNT(*) AS baglanti_sayisi
FROM monitoring.traffic_logs
GROUP BY device_id;
GO

-- Protokol trafik ozeti
DROP VIEW IF EXISTS monitoring.ProtokolTrafikOzet;
GO

CREATE VIEW monitoring.ProtokolTrafikOzet AS
SELECT protocol, COUNT(*) AS toplam_islem, SUM(data_size) AS toplam_mb
FROM monitoring.traffic_logs
GROUP BY protocol;
GO

-- Test
SELECT * FROM monitoring.GunlukTrafikOzet;
SELECT * FROM monitoring.CihazTrafikOzet;
SELECT * FROM monitoring.ProtokolTrafikOzet;
PRINT 'Hafta 7 tamamlandı.';
GO
