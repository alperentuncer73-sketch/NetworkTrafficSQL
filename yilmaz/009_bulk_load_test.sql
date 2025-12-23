-- HAFTA 9: Toplu Veri Yukleme ve Hata Testi
-- Amac: CHECK constraint ve FK hatalarini test etmek

USE TrafficLogDB;
GO

-- Port numarasi CHECK constraint
ALTER TABLE monitoring.traffic_logs
ADD CONSTRAINT CK_PortNumber CHECK (port_no BETWEEN 0 AND 65535);
GO

-- Toplu veri yukleme (50 kayit)
DECLARE @i INT = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO monitoring.traffic_logs (device_id, source_ip, dest_ip, port_no, protocol, data_size, status)
    VALUES (
        (@i % 4) + 1,
        '10.0.0.' + CAST(@i AS VARCHAR),
        '172.16.0.' + CAST(@i AS VARCHAR),
        CASE @i % 3 WHEN 0 THEN 80 WHEN 1 THEN 443 ELSE 53 END,
        CASE @i % 3 WHEN 0 THEN 'HTTP' WHEN 1 THEN 'HTTPS' ELSE 'DNS' END,
        RAND() * 200,
        CASE WHEN @i % 10 = 0 THEN 'Blocked' ELSE 'Allowed' END
    );
    SET @i = @i + 1;
END
GO

-- Kontrol
SELECT COUNT(*) AS toplam_kayit FROM monitoring.traffic_logs;
SELECT DISTINCT protocol FROM monitoring.traffic_logs;
SELECT * FROM monitoring.traffic_logs WHERE data_size < 0;
PRINT 'Hafta 9 tamamlandi.';
GO
