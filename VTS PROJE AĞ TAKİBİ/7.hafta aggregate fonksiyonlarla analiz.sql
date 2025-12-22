USE [Ag takibi proje];
GO


-- 1. Her cihaza ait toplam trafik miktarýný bulma
-- GROUP BY ile cihaz bazlý gruplama yapýcaz
------------------------------------------------------
PRINT ' Analiz 1: Cihaz bazlý trafik özeti ';

SELECT 
    D.DeviceIP,
    DM.Manufacturer AS Marka,   
    DM.ModelName AS Model,      
    COUNT(T.LogID) AS Toplam_Baglanti_Sayisi,
    SUM(T.DataTransferredMB) AS Toplam_Trafik_MB
FROM 
    TrafficLogs AS T
JOIN 
    Devices AS D ON T.DeviceID = D.DeviceID
JOIN 
    DeviceModels AS DM ON D.ModelID = DM.ModelID
GROUP BY 
    D.DeviceIP, DM.Manufacturer, DM.ModelName 
ORDER BY 
    Toplam_Trafik_MB DESC;
GO

-- 2. kullanýcýlara göre trafik analizi yapma
-- Hangi departman veya kiþinin aðý yorduðunu bulabilme

PRINT ' Analiz 2: Kullanýcý performans raporu ';

SELECT 
    U.FirstName + ' ' + U.LastName AS AdSoyad, 
    U.Department AS Departman,
    SUM(T.DataTransferredMB) AS Toplam_Kullanim_MB,
    AVG(T.DataTransferredMB) AS Ortalama_Islem_Boyutu_MB -- Ortalama iþlem hacmi
FROM 
    TrafficLogs AS T
JOIN 
    Users AS U ON T.UserID = U.UserID
GROUP BY 
    U.FirstName, U.LastName, U.Department
ORDER BY 
    Toplam_Kullanim_MB DESC;
GO


-- 3. günlük ortalama trafik raporu
--  tarihe göre gruplama
------------------------------------------------------
PRINT ' Analiz 3: günlük trafik ';

SELECT 
    CAST(T.EventTimestamp AS DATE) AS Gun, -- Saati atýp sadece tarihi aldýk
    COUNT(T.LogID) AS Gunluk_Islem_Sayisi,
    SUM(T.DataTransferredMB) AS Gunluk_Toplam_Trafik_MB
FROM 
    TrafficLogs AS T
GROUP BY 
    CAST(T.EventTimestamp AS DATE)
ORDER BY 
    Gun DESC;
GO


-- 4. en yüksek ve en düþük trafik deðerlerini bulma
-- Sistemdeki anormallikleri tespit edebiliriz
------------------------------------------------------
PRINT ' Analiz 4: min-max analizi';

SELECT 
    MAX(DataTransferredMB) AS En_Yuksek_Tekil_Islem_MB,
    MIN(DataTransferredMB) AS En_Dusuk_Tekil_Islem_MB,
    AVG(DataTransferredMB) AS Genel_Ortalama_MB,
    SUM(DataTransferredMB) AS Sistemin_Toplam_Hacmi_MB
FROM 
    TrafficLogs;
GO