USE [Ag takibi proje];
GO
-- modem loglarýný sisteme yükleyelim

-- otomatik ID bulma (hata almamak için veritabanýndaki mevcut ID'leri çekicez)
DECLARE @DevID INT = (SELECT TOP 1 DeviceID FROM Devices); 
DECLARE @UsrID INT = (SELECT TOP 1 UserID FROM Users);
DECLARE @ProtoTCP INT = (SELECT ProtocolID FROM TrafficProtocols WHERE ProtocolName = 'TCP');
DECLARE @ProtoUDP INT = (SELECT ProtocolID FROM TrafficProtocols WHERE ProtocolName = 'UDP');

-- eðer protokol ID'leri null gelirse varsayýlan 1 ve 2 yapalým (hata önleyici)
SET @ProtoTCP = ISNULL(@ProtoTCP, 1);
SET @ProtoUDP = ISNULL(@ProtoUDP, 2);

-- csv dosyasýndaki verileri buraya simüle edicez
INSERT INTO TrafficLogs (DeviceID, UserID, SourceIPAddress, DestinationIPAddress, DestinationPort, ProtocolID, DataTransferredMB, PacketCount, Status, EventTimestamp)
VALUES 
-- 1. normal trafik (DNS Sorgusu)
(@DevID, @UsrID, '192.168.1.10', '8.8.8.8', 53, @ProtoUDP, 15.5, 100, 'Allowed', '2025-12-22 14:00:01'),

-- 2. YÜKSEK TRAFÝK (1000 MB TAN büyük veri var.)
(@DevID, @UsrID, '192.168.1.111', '157.240.1.1', 443, @ProtoTCP, 1250.0, 15000, 'Allowed', '2025-12-22 14:05:22'),

-- 3. Normal Trafik (Web Gezintisi)
(@DevID, @UsrID, '192.168.1.105', '104.16.132.229', 80, @ProtoTCP, 550.0, 6000, 'Allowed', '2025-12-22 14:10:45'),

-- 4. KRÝTÝK TRAFÝK (trigger testinden >2000 MB  Critical Alert Bekleniyor)
(@DevID, @UsrID, '192.168.1.99', '192.168.1.200', 21, @ProtoTCP, 4500.0, 50000, 'Allowed', '2025-12-22 14:15:30'),

-- 5. Normal Trafik
(@DevID, @UsrID, '192.168.1.20', '1.1.1.1', 53, @ProtoUDP, 10.2, 50, 'Allowed', '2025-12-22 14:20:12'),

-- 6. Sýnýrda Trafik (800 MB - Alarm vermemeli)
(@DevID, @UsrID, '192.168.1.113', '172.217.16.142', 443, @ProtoTCP, 800.5, 9000, 'Allowed', '2025-12-22 14:25:00'),

-- 7. KRÝTÝK TRAFÝK (Yedekleme Sunucusu - Critical Alert)
(@DevID, @UsrID, '192.168.1.111', '10.0.0.5', 445, @ProtoTCP, 2100.0, 25000, 'Allowed', '2025-12-22 14:30:55');



-- yüklediðimiz verilerin sistem tarafýndan yakalanýp yakalanmadýðýný check edelim

SELECT 
    AlertID,
    SourceDeviceIP, 
    TrafficRateMbps, 
    Severity, 
    AlertTimestamp,
    DetailDescription
FROM 
    SecurityAlerts
WHERE 
    AlertTimestamp >= DATEADD(minute, -10, GETDATE()) -- son 10 dakikadaki alarmlar
ORDER BY 
    TrafficRateMbps DESC;