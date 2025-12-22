-- Kendi Proje Veritabanýnýzý Kullanýn
USE [Ag takibi proje];
GO

------------------------------------------------------
-- ADIM 1: Test için Ana Tablolara Veri Ekleme
-- (TrafficLogs tablosuna veri ekleyebilmek için
--  bu tablolarda karþýlýk gelen ID'ler olmalýdýr - FK Kuralý)
------------------------------------------------------

PRINT '1. Adým: Devices ve Users tablolarýna test verisi ekleniyor...';

-- Önceki haftadan kalan Katalog verilerini (ModelID=1, TypeID=1) kullanalým
-- NOT: Eðer INSERT INTO DeviceModels/DeviceTypes yapmadýysanýz, önceki hafta kodunu çalýþtýrýn.
INSERT INTO Devices (TypeID, ModelID, DeviceIP, SerialNumber, Location, Status)
VALUES 
(1, 1, '192.168.1.1', 'SN-RTR-001', 'Server Room', 'Active'), -- Bu DeviceID = 1 olacak
(2, 2, '192.168.1.10', 'SN-SW-001', 'Floor 1', 'Active');   -- Bu DeviceID = 2 olacak

INSERT INTO Users (FirstName, LastName, Email, Department, AssignedIP)
VALUES
('Ali', 'Yilmaz', 'ali@sirket.com', 'IT', '192.168.1.100'), -- Bu UserID = 1 olacak
('Buse', 'Kaya', 'buse@sirket.com', 'Sales', '192.168.1.101'), -- Bu UserID = 2 olacak
('Can', 'Demir', 'can@sirket.com', 'Marketing', '192.168.1.102'); -- Bu UserID = 3 olacak
GO


------------------------------------------------------
-- ADIM 2: TrafficLogs Tablosuna Örnek Veri Ekleme (3NF UYUMLU)
-- (ProtocolID'leri TrafficProtocols tablosundan alarak)
------------------------------------------------------

PRINT '2. Adým: TrafficLogs tablosuna 3NF uyumlu veriler ekleniyor...';

INSERT INTO TrafficLogs
    (DeviceID, UserID, SourceIPAddress, DestinationIPAddress, DestinationPort, 
     ProtocolID, DataTransferredMB, Status)
VALUES
(
    1,  -- device_id (Cihaz ID 1)
    2,  -- user_id (Kullanýcý ID 2)
    '192.168.1.101', -- Buse'nin IP'si
    '8.8.8.8', 
    53, 
    (SELECT ProtocolID FROM TrafficProtocols WHERE ProtocolName = 'DNS'), -- 'DNS' metni yerine ID'sini bulup ekliyoruz
    1.45, 
    'Allowed'
),
(
    2,  -- device_id (Cihaz ID 2)
    3,  -- user_id (Kullanýcý ID 3)
    '192.168.1.102', -- Can'ýn IP'si
    '172.217.18.46', 
    443, 
    (SELECT ProtocolID FROM TrafficProtocols WHERE ProtocolName = 'HTTPS'), -- 'HTTPS' ID'sini bulup ekliyoruz
    55.23, 
    'Allowed'
),
(
    1,  -- device_id (Cihaz ID 1)
    1,  -- user_id (Kullanýcý ID 1)
    '192.168.1.100', -- Ali'nin IP'si
    '104.16.249.249', 
    80, 
    (SELECT ProtocolID FROM TrafficProtocols WHERE ProtocolName = 'HTTP'), -- 'HTTP' ID'sini bulup ekliyoruz
    23.75, 
    'Blocked' -- Proje planýndaki gibi 'Blocked'
);
GO


------------------------------------------------------
-- ADIM 3: Basit SELECT Sorgularý ile Test Etme (3NF UYUMLU)
------------------------------------------------------

PRINT '3. Adým: Sistem test ediliyor...';

-- Test 1: Tüm ham kayýtlarý göster (ID'ler görünecek)
PRINT '--- Test 1: Tüm Ham Kayýtlar (TrafficLogs) ---';
SELECT * FROM TrafficLogs;


-- Test 2: Toplam kayýt sayýsýný göster
PRINT '--- Test 2: Toplam Log Kayýt Sayýsý ---';
SELECT COUNT(*) AS ToplamKayitSayisi FROM TrafficLogs;


-- Test 3: Hangi protokolden kaçar adet iþlem yapýlmýþ? (3NF UYUMLU JOIN)
PRINT '--- Test 3: Protokol Bazlý Ýþlem Sayýsý (JOIN ile) ---';
SELECT 
    T.ProtocolName, -- Protokol adýný diðer tablodan (TrafficProtocols) aldýk
    COUNT(L.LogID) AS IslemSayisi
FROM 
    TrafficLogs AS L
JOIN 
    TrafficProtocols AS T ON L.ProtocolID = T.ProtocolID
GROUP BY 
    T.ProtocolName
ORDER BY 
    IslemSayisi DESC;
GO

PRINT '3. Hafta görevi (Test ve Doðrulama) baþarýyla tamamlandý.';
GO