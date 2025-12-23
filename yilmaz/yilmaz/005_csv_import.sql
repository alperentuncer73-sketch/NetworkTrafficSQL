-- HAFTA 5: CSV Import Islemleri
-- Amac: BULK INSERT ile dis kaynak verisi aktarimi

USE TrafficLogDB;
GO

-- BULK INSERT komutu (dosya yolunu degistirin)
/*
BULK INSERT monitoring.traffic_logs
FROM 'C:\veriler\trafik.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
*/

-- CSV yerine manuel test verisi
INSERT INTO monitoring.traffic_logs (device_id, source_ip, dest_ip, port_no, protocol, data_size, status)
VALUES
    (1, '192.168.1.50', '8.8.8.8', 53, 'DNS', 2.45, 'Allowed'),
    (2, '192.168.1.51', '142.250.190.78', 443, 'HTTPS', 55.60, 'Allowed'),
    (3, '192.168.1.52', '104.16.132.229', 80, 'HTTP', 12.30, 'Blocked'),
    (1, '192.168.1.53', '1.1.1.1', 53, 'DNS', 3.20, 'Allowed'),
    (2, '192.168.1.54', '172.217.18.46', 443, 'HTTPS', 78.90, 'Allowed');
GO

-- Kontrol
SELECT TOP 10 * FROM monitoring.traffic_logs ORDER BY log_id DESC;
SELECT COUNT(*) AS toplam_kayit FROM monitoring.traffic_logs;
PRINT 'Hafta 5 tamamlandi.';
GO
