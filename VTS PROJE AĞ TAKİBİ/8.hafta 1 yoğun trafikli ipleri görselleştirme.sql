USE [Ag takibi proje];
GO

SELECT TOP 10 -- En yoðun 10 IP yeterlidir
    SourceIPAddress AS IP_Adresi,           -- X Ekseni Olacak
    SUM(DataTransferredMB) AS Toplam_Veri_MB -- Y Ekseni Olacak
FROM 
    TrafficLogs
GROUP BY 
    SourceIPAddress
ORDER BY 
    Toplam_Veri_MB DESC;


    SELECT TOP 10
    DestinationIPAddress AS IP_Adresi,
    SUM(DataTransferredMB) AS Toplam_Veri_MB
FROM 
    TrafficLogs
GROUP BY 
    DestinationIPAddress
ORDER BY 
    Toplam_Veri_MB DESC;