-- HAFTA 8: Görselleşştirme Hazırlığı

USE TrafficLogDB;
GO

-- Cihaz bazli toplam trafik (Bar Chart icin)
SELECT device_id, SUM(data_size) AS toplam_trafik_mb
FROM monitoring.traffic_logs
GROUP BY device_id ORDER BY toplam_trafik_mb DESC;
GO

-- Protokol dagilimi (Pie Chart icin)
SELECT protocol, SUM(data_size) AS toplam_mb, COUNT(*) AS islem_sayisi
FROM monitoring.traffic_logs
GROUP BY protocol ORDER BY toplam_mb DESC;
GO

-- Gorsellesstirme icin View
DROP VIEW IF EXISTS monitoring.GrafikVerisi;
GO

CREATE VIEW monitoring.GrafikVerisi AS
SELECT d.device_name, d.device_type, SUM(t.data_size) AS toplam_trafik_mb, COUNT(*) AS baglanti_sayisi
FROM monitoring.traffic_logs t
INNER JOIN network.devices d ON t.device_id = d.device_id
GROUP BY d.device_name, d.device_type;
GO

SELECT * FROM monitoring.GrafikVerisi ORDER BY toplam_trafik_mb DESC;
PRINT 'Hafta 8 tamamlandı.';
GO
