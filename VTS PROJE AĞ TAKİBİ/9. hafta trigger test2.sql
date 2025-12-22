-- Test Verisi Ekleme (Bu veri 2500 MB olduðu için Critical uyarısı vermeli)
INSERT INTO TrafficLogs (DeviceID, UserID, SourceIPAddress, DestinationIPAddress, DestinationPort, ProtocolID, DataTransferredMB, PacketCount, Status, EventTimestamp)
VALUES (1, 1, '192.168.1.99', '8.8.8.8', 443, 2, 2500.00, 10000, 'Allowed', GETDATE());


SELECT * FROM SecurityAlerts ORDER BY AlertID DESC;

