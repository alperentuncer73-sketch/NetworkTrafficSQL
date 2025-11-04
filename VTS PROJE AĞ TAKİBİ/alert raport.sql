-- GÜVENLÝK UYARILARI TABLOSU: Anormal veya eþik deðeri aþan olaylarý tutar.
CREATE TABLE SecurityAlerts (
    AlertID INT PRIMARY KEY IDENTITY(1,1), -- Birincil Anahtar
    AlertTimestamp DATETIME NOT NULL,      -- Uyarýnýn tetiklendiði kesin zaman
    Severity VARCHAR(10) NOT NULL,         -- Uyarýnýn ciddiyeti (örn: 'CRITICAL', 'HIGH', 'MEDIUM')
    AlertType VARCHAR(50) NOT NULL,        -- Uyarý türü (örn: 'HighTrafficAnomaly', 'PortScanAttempt')
    SourceDeviceIP VARCHAR(15) NOT NULL,   -- Uyarýya neden olan cihazýn IP adresi
    TrafficRateMbps DECIMAL(10, 2),        -- Uyarý anýndaki trafik hýzý (Mbps)
    DetailDescription NVARCHAR(255)        -- Uyarýyla ilgili kýsa açýklama veya eþik deðeri
);