USE [Ag takibi proje];
GO

INSERT INTO TrafficLogs (
    DeviceID, 
    UserID, -- Varsayýlan olarak 1 ve 2 numaralý kullanýcýlarý kullanýyoruz
    SourceIPAddress, 
    DestinationIPAddress, 
    DestinationPort, 
    ProtocolID, 
    DataTransferredMB, 
    PacketCount, 
    Status
)
VALUES 
-- Cihaz 1 (ID: 1) Üzerinden Geçen Trafikler
(1, 1, '192.168.1.105', '8.8.8.8', 53, 5, 550.20, 1000, 'Allowed'),
(1, 2, '192.168.1.106', '142.250.1.1', 443, 2, 1200.50, 15000, 'Allowed'),
(1, 1, '192.168.1.107', '104.16.1.1', 80, 1, 350.00, 4000, 'Allowed'),
(1, 2, '192.168.1.108', '172.217.1.1', 443, 2, 4500.75, 50000, 'Allowed'), -- Yüksek Trafik 1
(1, 1, '192.168.1.109', '192.168.1.200', 21, 1, 25.00, 200, 'Blocked'),

-- Cihaz 2 (ID: 2) Üzerinden Geçen Trafikler
(2, 2, '192.168.1.110', '1.1.1.1', 53, 5, 60.00, 600, 'Allowed'),
(2, 1, '192.168.1.111', '157.240.1.1', 443, 2, 8900.00, 95000, 'Allowed'), -- EN YÜKSEK TRAFÝK (Grafikte Kýrmýzý Olacak)
(2, 2, '192.168.1.112', '10.0.0.5', 22, 3, 120.00, 1500, 'Allowed'),
(2, 1, '192.168.1.113', '192.168.1.50', 3389, 4, 3200.40, 35000, 'Allowed'),
(2, 2, '192.168.1.114', '185.60.216.35', 443, 2, 750.00, 8000, 'Allowed'),

-- Karýþýk Eklemeler (Device ID sadece 1 veya 2)
(1, 1, '192.168.1.115', '204.79.197.200', 80, 1, 15.50, 100, 'Allowed'),
(2, 2, '192.168.1.116', '13.107.42.16', 443, 2, 980.00, 11000, 'Allowed'),
(1, 2, '192.168.1.117', '52.96.164.5', 443, 2, 2100.00, 25000, 'Allowed'),
(2, 1, '192.168.1.118', '192.168.1.99', 445, 1, 5.00, 50, 'Blocked'),
(1, 1, '192.168.1.119', '151.101.1.1', 443, 2, 670.30, 7000, 'Allowed');
GO

PRINT 'Veriler baþarýyla eklendi! Þimdi TOP 10 sorgusunu çalýþtýrabilirsiniz.';