-- HAFTA 6: Trafik Analizi

USE TrafficLogDB;
GO

-- Cihaz toplam trafik --
SELECT device_id, SUM(data_size) AS toplam_veri_mb
FROM monitoring.traffic_logs
GROUP BY device_id
ORDER BY toplam_veri_mb DESC;
GO

-- En çok trafik yapan 5 cihaz --
SELECT TOP 5 device_id, SUM(data_size) AS toplam_mb, COUNT(*) AS islem_sayisi
FROM monitoring.traffic_logs
GROUP BY device_id ORDER BY toplam_mb DESC;
GO

-- Protokol analizi --
SELECT protocol, COUNT(*) AS islem_sayisi, SUM(data_size) AS toplam_mb
FROM monitoring.traffic_logs
GROUP BY protocol ORDER BY toplam_mb DESC;
GO

-- Durum analizi --
SELECT status, COUNT(*) AS kayit_sayisi, SUM(data_size) AS toplam_mb
FROM monitoring.traffic_logs
GROUP BY status;
GO

-- View oluşturma --
DROP VIEW IF EXISTS monitoring.EnCokTrafikYapanCihaz;
GO

CREATE VIEW monitoring.EnCokTrafikYapanCihaz AS
SELECT TOP 5 device_id, SUM(data_size) AS toplam_mb
FROM monitoring.traffic_logs
GROUP BY device_id ORDER BY toplam_mb DESC;
GO

SELECT * FROM monitoring.EnCokTrafikYapanCihaz;
PRINT 'Hafta 6 tamamlandı.';
GO
