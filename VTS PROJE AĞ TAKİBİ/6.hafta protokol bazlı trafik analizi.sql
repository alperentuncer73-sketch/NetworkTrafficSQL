USE [Ag takibi proje];
GO


--  Protokol bazýnda toplam trafik miktarýný hesaplama
-- (JOIN kullanarak ID'leri isme çeviriyoruz)

PRINT 'Rapor 1: Protokol Bazlý Toplam Trafik ';

SELECT
    P.ProtocolName AS Protokol,               -- Ýsim TrafficProtocols'dan gelir
    COUNT(T.LogID) AS Baglanti_Sayisi,        -- Kaç kez kullanýlmýþ?
    SUM(T.DataTransferredMB) AS Toplam_Trafik_MB -- Toplam veri boyutu
FROM 
    TrafficLogs AS T
JOIN 
    TrafficProtocols AS P ON T.ProtocolID = P.ProtocolID
GROUP BY 
    P.ProtocolName
ORDER BY 
    Toplam_Trafik_MB DESC;
GO


--  En çok kullanýlan protokolü bulucaz
-- (TOP 1 ile þampiyonu seçiyoruz)

PRINT ' Rapor 2: En Çok Trafik Harcayan Protokol (Þampiyon) ';

SELECT TOP 1
    P.ProtocolName AS Protokol,
    SUM(T.DataTransferredMB) AS Toplam_Trafik_MB
FROM 
    TrafficLogs AS T
JOIN 
    TrafficProtocols AS P ON T.ProtocolID = P.ProtocolID
GROUP BY 
    P.ProtocolName
ORDER BY 
    Toplam_Trafik_MB DESC;
GO

-- 3. Protokollere göre ortalama paket boyutunu hesapla
-- (AVG fonksiyonu ile analiz)

PRINT ' Rapor 3: Protokol Performans Ortalamalarý ';

SELECT
    P.ProtocolName AS Protokol,
    AVG(T.DataTransferredMB) AS Ortalama_Veri_MB, -- Baðlantý baþýna ortalama boyut
    AVG(T.PacketCount) AS Ortalama_Paket_Sayisi   -- Baðlantý baþýna ortalama paket
FROM 
    TrafficLogs AS T
JOIN 
    TrafficProtocols AS P ON T.ProtocolID = P.ProtocolID
GROUP BY 
    P.ProtocolName;
GO


-- Filtreleme örneði TCP kayýtlarý için bakalým


PRINT ' Rapor 4: Sadece TCP Protokolüne Ait Loglar ';

SELECT 
    T.LogID,
    T.EventTimestamp,
    T.SourceIPAddress,
    T.DestinationIPAddress,
    P.ProtocolName,    -- 'TCP' olduðunu buradan görüyoruz
    T.Status
FROM 
    TrafficLogs AS T
JOIN 
    TrafficProtocols AS P ON T.ProtocolID = P.ProtocolID
WHERE 
    P.ProtocolName = 'TCP' 
ORDER BY 
    T.EventTimestamp DESC;
GO