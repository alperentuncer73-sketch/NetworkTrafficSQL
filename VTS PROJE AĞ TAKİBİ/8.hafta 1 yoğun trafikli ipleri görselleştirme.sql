USE [Ag takibi proje];
GO

SELECT TOP 10 -- En yoğun 10 IP yeterlidir
    SourceIPAddress AS IP_Adresi,           -- X ekseni 
    SUM(DataTransferredMB) AS Toplam_Veri_MB -- Y ekseni 
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
