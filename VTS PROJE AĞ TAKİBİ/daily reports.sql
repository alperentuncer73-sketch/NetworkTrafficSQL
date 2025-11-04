-- GÜNLÜK RAPORLAR TABLOSU: Total trafik, en yoðun saat gibi özet verileri tutar.
CREATE TABLE DailyReports (
    ReportID INT PRIMARY KEY IDENTITY(1,1), -- Birincil Anahtar, otomatik artan ID
    ReportDate DATE NOT NULL UNIQUE,       -- Raporun ait olduðu gün (Tekrar eden gün kaydýný engeller)
    TotalTrafficGB DECIMAL(12, 2) NOT NULL, -- O günkü toplam trafiðin GB cinsinden boyutu
    BusiestHour INT,                       -- O günün en yoðun saati (0-23 arasý)
    MostActiveDeviceIP VARCHAR(15),        -- En çok trafik yapan cihazýn IP adresi
    TopProtocol VARCHAR(50),               -- En çok kullanýlan protokol (örn: HTTP, HTTPS)
    TotalAlerts INT DEFAULT 0              -- O gün üretilen toplam uyarý sayýsý (SecurityAlerts tablosuna bakmadan özet bilgi)
);