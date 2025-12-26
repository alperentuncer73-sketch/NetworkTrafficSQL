USE AgTrafikDB;
GO

-- ===========================================
-- BÜYÜK VERİ YÜKLEME (PERFORMANS TESTİ)
-- ===========================================

DECLARE @i INT = 1;

WHILE @i <= 100000
BEGIN
    INSERT INTO TrafikKayitlari 
        (cihaz_id, kullanici_id, ip_adresi, hedef_ip, port_no, protokol, veri_miktari_mb, durum)
    VALUES (
        (ABS(CHECKSUM(NEWID())) % 10) + 1,
        (ABS(CHECKSUM(NEWID())) % 20) + 1,
        CONCAT('192.168.1.', (ABS(CHECKSUM(NEWID())) % 255) + 1),
        CONCAT('10.0.0.', (ABS(CHECKSUM(NEWID())) % 255) + 1),
        (ABS(CHECKSUM(NEWID())) % 65535) + 1,
        CASE WHEN RAND() > 0.8 THEN 'UDP' ELSE 'TCP' END,
        (ABS(CHECKSUM(NEWID())) % 10000) / 10.0,
        CASE WHEN RAND() > 0.95 THEN 'Blocked' ELSE 'Allowed' END
    );
    SET @i += 1;
END;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT TOP 10 
    ip_adresi, 
    SUM(veri_miktari_mb) AS ToplamVeri
FROM TrafikKayitlari
GROUP BY ip_adresi
ORDER BY ToplamVeri DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

CREATE INDEX idx_trafik_veri ON TrafikKayitlari(veri_miktari_mb);
CREATE INDEX idx_trafik_protokol ON TrafikKayitlari(protokol);
CREATE INDEX idx_trafik_durum ON TrafikKayitlari(durum);
GO

-- Önce index olmadan
SELECT COUNT(*) 
FROM TrafikKayitlari 
WHERE protokol = 'TCP';
GO

-- Sonra index ekle
CREATE INDEX idx_perf_test ON TrafikKayitlari(protokol);
GO

-- Aynı sorguyu tekrar çalıştır
SELECT COUNT(*) 
FROM TrafikKayitlari 
WHERE protokol = 'TCP';
GO
