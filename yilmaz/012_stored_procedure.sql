-- HAFTA 12: Aylık Rapor Stored Procedure

USE TrafficLogDB;
GO

DROP PROCEDURE IF EXISTS sp_AylikRapor;
GO

CREATE PROCEDURE sp_AylikRapor
    @ay INT,
    @yil INT
AS
BEGIN
    SET NOCOUNT ON;
    
    --özet--
    SELECT COUNT(*) AS toplam_baglanti, SUM(data_size) AS toplam_mb, AVG(data_size) AS ortalama_mb
    FROM monitoring.traffic_logs
    WHERE MONTH(log_time) = @ay AND YEAR(log_time) = @yil;
    
    -- En çok trafik yapan 5 tane cihaz --
    SELECT TOP 5 device_id, SUM(data_size) AS toplam_mb, COUNT(*) AS baglanti_sayisi
    FROM monitoring.traffic_logs
    WHERE MONTH(log_time) = @ay AND YEAR(log_time) = @yil
    GROUP BY device_id ORDER BY toplam_mb DESC;
    
    -- Protokol dağılımları --
    SELECT protocol, COUNT(*) AS islem_sayisi, SUM(data_size) AS toplam_mb
    FROM monitoring.traffic_logs
    WHERE MONTH(log_time) = @ay AND YEAR(log_time) = @yil
    GROUP BY protocol;
    
    -- Engellenenler --
    SELECT COUNT(*) AS engellenen_sayi
    FROM monitoring.traffic_logs
    WHERE MONTH(log_time) = @ay AND YEAR(log_time) = @yil AND status = 'Blocked';
END
GO

-- Son Kontrol --
EXEC sp_AylikRapor @ay = 12, @yil = 2025;
PRINT 'Hafta 12 tamamlandı.';
GO
