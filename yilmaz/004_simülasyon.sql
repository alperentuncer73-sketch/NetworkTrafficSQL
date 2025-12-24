-- HAFTA 4: Veri Simulasyonu

USE TrafficLogDB;
GO

-- Cihaz verileri --
INSERT INTO network.devices (device_name, device_type, ip_address, location, status)
VALUES 
    ('Modem01', 'Modem', '192.168.1.1', 'Sunucu Odası', 'Active'),
    ('Router01', 'Router', '192.168.1.2', 'Kat 1', 'Active'),
    ('Switch01', 'Switch', '192.168.1.3', 'Kat 2', 'Active'),
    ('Firewall01', 'Firewall', '192.168.1.4', 'Sunucu Odası', 'Active'),
    ('AccessPoint01', 'Access Point', '192.168.1.5', 'Kat 3', 'Passive');
GO

-- Kullanici verileri --
INSERT INTO network.users (user_name, email, department)
VALUES 
    ('Abdullah Yılmaz', 'yilamz@sirket.com', 'IT'),
    ('Umut Can Kuş', 'umut@sirket.com', 'Muhasebe'),
    ('Ali Alper', 'ali@sirket.com', 'Satış');
GO

-- trafik verileri --
INSERT INTO monitoring.traffic_logs (device_id, source_ip, dest_ip, port_no, protocol, data_size, status)
VALUES
    (1, '192.168.1.10', '172.217.18.46', 443, 'HTTPS', 50.25, 'Allowed'),
    (2, '192.168.1.11', '8.8.8.8', 53, 'DNS', 2.45, 'Allowed'),
    (1, '192.168.1.10', '104.16.249.249', 80, 'HTTP', 30.70, 'Blocked'),
    (3, '192.168.1.15', '142.250.190.78', 443, 'HTTPS', 15.80, 'Allowed'),
    (2, '192.168.1.20', '1.1.1.1', 53, 'DNS', 1.20, 'Allowed');
GO

-- Otomatik veri üretme (10 tane)--
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    INSERT INTO monitoring.traffic_logs (device_id, source_ip, dest_ip, port_no, protocol, data_size, status)
    VALUES ((@i % 4) + 1, '192.168.1.' + CAST(@i + 100 AS VARCHAR), '8.8.8.' + CAST(@i AS VARCHAR), 
            80, 'HTTP', RAND() * 100, 'Allowed');
    SET @i = @i + 1;
END
GO

-- Uyarı--
INSERT INTO monitoring.alerts (device_id, message, level)
VALUES 
    (1, 'Yüksek trafik', 'High'),
    (2, 'Bağlantı zaman aşımı', 'Medium'),
    (3, 'Port taraması algılandı', 'Critical'),
    (1, 'Normal aktivite', 'Low');
GO

-- Son Kontrol --
SELECT 'Devices' AS Tablo, COUNT(*) AS Kayit FROM network.devices
UNION ALL SELECT 'Users', COUNT(*) FROM network.users
UNION ALL SELECT 'TrafficLogs', COUNT(*) FROM monitoring.traffic_logs
UNION ALL SELECT 'Alerts', COUNT(*) FROM monitoring.alerts;
GO

PRINT 'Hafta 4 tamamlandı.';
GO
