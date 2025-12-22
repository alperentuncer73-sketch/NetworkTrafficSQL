
SELECT 
    U.FirstName + ' ' + U.LastName AS Kullanici,
    U.Department AS Departman,
    D.DeviceIP AS Cihaz_IP,
    DM.ModelName AS Cihaz_Modeli
FROM Users U
JOIN Devices D ON U.AssignedIP = D.DeviceIP
JOIN DeviceModels DM ON D.ModelID = DM.ModelID
WHERE U.AssignedIP = '192.168.1.111';
USE [Ag takibi proje];
GO

SELECT 
    U.FirstName + ' ' + U.LastName AS Calisan_Bilgisi,
    U.Department AS Departman,
    T.DestinationIPAddress AS Gidilen_Hedef_IP,
    SUM(T.DataTransferredMB) AS Oraya_Gonderilen_Toplam_MB
FROM TrafficLogs T
JOIN Users U ON T.SourceIPAddress = U.AssignedIP -- Çalýþaný bulmak için Kaynak IPye bakýyoruz
WHERE T.DestinationIPAddress = '157.240.1.1' -- Hedef IP (turuncu sütun)
GROUP BY U.FirstName, U.LastName, U.Department, T.DestinationIPAddress;