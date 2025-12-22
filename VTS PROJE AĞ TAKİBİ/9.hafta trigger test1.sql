USE [Ag takibi proje];
GO


-- Sisteme 3500 MB'lýk (Kritik Seviye) bir veri giriþi yapýyoruz
INSERT INTO TrafficLogs (
    DeviceID, UserID, SourceIPAddress, DestinationIPAddress, 
    DestinationPort, ProtocolID, DataTransferredMB, PacketCount, Status, EventTimestamp
)
VALUES (
    1, 1, '192.168.1.99', '8.8.8.8', 
    443, 2, 3500.00, 50000, 'Allowed', GETDATE()
);



-- triggerýn çalýþýp kayýt oluþturup oluþturmadýðýný test edelim
SELECT 
    AlertTimestamp, 
    Severity, 
    SourceDeviceIP, 
    TrafficRateMbps, 
    DetailDescription 
FROM 
    SecurityAlerts 
ORDER BY 
    AlertID DESC;