USE [Ag takibi proje];
GO

-- Varsa eski triggerı temizle
DROP TRIGGER IF EXISTS trg_TrafficAnomalyDetector;
GO

CREATE TRIGGER trg_TrafficAnomalyDetector
ON TrafficLogs
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Limitleri belirliyoruz
    DECLARE @LimitHigh FLOAT = 1000;    
    DECLARE @LimitCritical FLOAT = 2000;   

    -- SecurityAlerts tablosunun sütunlarına göre eşleştirme yapıyoruz:
    INSERT INTO SecurityAlerts (
        AlertTimestamp, 
        Severity, 
        AlertType, 
        SourceDeviceIP, 
        TrafficRateMbps, 
        DetailDescription
    )
    SELECT 
        GETDATE(),                                          -- AlertTimestamp
        CASE 
            WHEN i.DataTransferredMB >= @LimitCritical THEN 'Critical' -- Severity 
            ELSE 'High'                                     -- Severity
        END,
        'trafik dalgalanmasý',                                    -- AlertType (Sabit bir tür adı verdik)
        i.SourceIPAddress,                                  -- SourceDeviceIP (Logdan gelen IP)
        i.DataTransferredMB,                                -- TrafficRateMbps (Veri miktarı)
        'Anormal trafik tespiti: ' + CAST(i.DataTransferredMB AS VARCHAR) + ' MB veri transfer edildi.' -- DetailDescription
    FROM 
        inserted i
    WHERE 
        i.DataTransferredMB >= @LimitHigh; -- Sadece 1000 MB üstünü yakala
END;

