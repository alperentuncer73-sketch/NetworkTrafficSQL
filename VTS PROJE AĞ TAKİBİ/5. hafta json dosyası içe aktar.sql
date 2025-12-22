USE [Ag takibi proje];
GO
--Önce, gelen veriyi olduðu gibi (ham haliyle) kabul edecek, kurallarý gevþek bir tablo oluþturalým.
-- Eðer varsa önce eskisini temizle
DROP TABLE IF EXISTS Staging_RawTraffic;

-- Ham veriyi tutacak geçici tablo
CREATE TABLE Staging_RawTraffic (
    StagingID INT IDENTITY(1,1),
    RawDeviceIP VARCHAR(50),      -- CSV/JSON'dan IP gelir (ID gelmez)
    RawDestIP VARCHAR(50),
    RawProtocol VARCHAR(20),      -- 'TCP', 'HTTP' gibi metin gelir
    RawDataSize FLOAT,
    RawStatus VARCHAR(20)
);
GO
--  Gelecek JSON dosyasýný simüle edelim. Burada OPENJSON komutunu kullanarak 
--JSON metnini tablo formatýna çevirip Staging tablosuna atýyoruz.
PRINT '--- JSON Verisi Staging Tablosuna Alýnýyor ---';

DECLARE @json NVARCHAR(MAX);

-- Örnek JSON Verisi ( gelecek dosya bu formatta olacak)
SET @json = '[
    {"source_ip":"192.168.1.1", "dest_ip":"8.8.8.8", "protocol":"DNS", "data_size":1.2, "status":"Allowed"},
    {"source_ip":"192.168.1.10", "dest_ip":"1.1.1.1", "protocol":"HTTPS", "data_size":15.5, "status":"Allowed"},
    {"source_ip":"192.168.1.99", "dest_ip":"10.0.0.5", "protocol":"TCP", "data_size":0.5, "status":"Blocked"}
]';

-- JSON'u parçala ve Staging tablosuna ekle
INSERT INTO Staging_RawTraffic (RawDeviceIP, RawDestIP, RawProtocol, RawDataSize, RawStatus)
SELECT 
    source_ip, dest_ip, protocol, data_size, status
FROM OPENJSON(@json)
WITH (
    source_ip VARCHAR(50),
    dest_ip VARCHAR(50),
    protocol VARCHAR(20),
    data_size FLOAT,
    status VARCHAR(20)
);

-- Kontrol edelim: Staging tablosunda veri var mý?
SELECT * FROM Staging_RawTraffic;
GO
--Þimdi Staging tablosundaki metinleri (DNS, 192.168.1.1) alýp, ana tablolarýmýzdaki 
--ID'lerle (ProtocolID, DeviceID) eþleþtirerek TrafficLogs tablosuna aktaracaðýz.
PRINT '--- Veriler Dönüþtürülüp TrafficLogs Tablosuna Aktarýlýyor ---';

INSERT INTO TrafficLogs (
    DeviceID,           -- ID'yi bulacaðýz
    SourceIPAddress, 
    DestinationIPAddress, 
    DestinationPort,    -- Varsayýlan port atayacaðýz (veya protokolden bulacaðýz)
    ProtocolID,         -- Metni ID'ye çevireceðiz
    DataTransferredMB, 
    Status
)
SELECT 
    D.DeviceID,                     -- 1. Devices tablosundan IP'ye göre ID bulduk
    S.RawDeviceIP,
    S.RawDestIP,
    ISNULL(TP.DefaultPort, 0),      -- 2. Port bilgisini TrafficProtocols tablosundan çektik
    TP.ProtocolID,                  -- 3. 'DNS' yazýsýný ProtocolID (örn: 5) yaptýk
    S.RawDataSize,
    S.RawStatus
FROM 
    Staging_RawTraffic AS S
-- Eþleþtirme (Mapping) Ýþlemleri:
LEFT JOIN Devices AS D ON S.RawDeviceIP = D.DeviceIP
LEFT JOIN TrafficProtocols AS TP ON S.RawProtocol = TP.ProtocolName;

-- Sonucu Görelim
SELECT * FROM TrafficLogs ORDER BY LogID DESC;
GO
--Ýþlem bittikten sonra geçici tabloyu temizleyebiliriz
-- Staging tablosunu boþalt (Sonraki yükleme için hazýrla)
TRUNCATE TABLE Staging_RawTraffic;