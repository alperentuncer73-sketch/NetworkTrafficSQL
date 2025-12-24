-- HAFTA 11: Toplu Veri Simülasyonu

USE TrafficLogDB;
GO

-- 1000 tane kayıt oluşturma--
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO monitoring.traffic_logs (device_id, source_ip, dest_ip, port_no, protocol, data_size, status, log_time)
    VALUES (
        (@i % 4) + 1,
        '192.168.' + CAST(@i % 255 AS VARCHAR) + '.' + CAST(@i % 100 AS VARCHAR),
        '10.0.' + CAST(@i % 255 AS VARCHAR) + '.' + CAST(@i % 100 AS VARCHAR),
        CASE @i % 5 WHEN 0 THEN 80 WHEN 1 THEN 443 WHEN 2 THEN 53 WHEN 3 THEN 21 ELSE 22 END,
        CASE @i % 5 WHEN 0 THEN 'HTTP' WHEN 1 THEN 'HTTPS' WHEN 2 THEN 'DNS' WHEN 3 THEN 'FTP' ELSE 'SSH' END,
        RAND(CHECKSUM(NEWID())) * 500,
        CASE WHEN @i % 20 = 0 THEN 'Blocked' ELSE 'Allowed' END,
        DATEADD(MINUTE, -@i, GETDATE())
    );
    SET @i = @i + 1;
END
GO

-- Performans --
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TrafficLogs_SourceIP')
    CREATE NONCLUSTERED INDEX IX_TrafficLogs_SourceIP ON monitoring.traffic_logs(source_ip);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TrafficLogs_LogTime')
    CREATE NONCLUSTERED INDEX IX_TrafficLogs_LogTime ON monitoring.traffic_logs(log_time);
GO

-- Son Kontrol --
SELECT COUNT(*) AS toplam_kayit FROM monitoring.traffic_logs;
SELECT SUM(data_size) AS toplam_mb, AVG(data_size) AS ortalama_mb FROM monitoring.traffic_logs;
PRINT 'Hafta 11 tamamlandı.';
GO
