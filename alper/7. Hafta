USE AgTrafikDB;
GO

-- ===========================================
-- UYARI TABLOSUNU DOLDURACAK TRIGGER
-- ===========================================
CREATE OR ALTER TRIGGER trg_TrafikKayit_UyariEkle
ON TrafikKayitlari
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Uyarilar (
        cihaz_id,
        ip_adresi,
        protokol,
        sebep,
        seviye,
        kategori,
        log_kaynagi,
        algilayan_sistem,
        oneri
    )
    SELECT 
        i.cihaz_id,
        i.ip_adresi,
        i.protokol,
        CASE 
            WHEN i.veri_miktari_mb > 500 THEN 'Yüksek trafik miktarı algılandı'
            WHEN i.protokol IN ('FTP', 'DNS') THEN 'Şüpheli protokol tespit edildi'
            WHEN i.durum = 'Blocked' THEN 'Engellenmiş bağlantı kaydı'
            ELSE 'Genel izleme olayı'
        END,
        CASE 
            WHEN i.veri_miktari_mb > 1000 THEN 'Critical'
            WHEN i.veri_miktari_mb > 500 THEN 'High'
            WHEN i.protokol IN ('FTP', 'DNS') THEN 'Medium'
            ELSE 'Low'
        END,
        'Trafik Analizi',
        'Trigger System',
        'SQL Trigger v1.0',
        'Yönetici tarafından kontrol edilmesi önerilir'
    FROM inserted i
    WHERE i.veri_miktari_mb > 500
       OR i.protokol IN ('FTP','DNS')
       OR i.durum = 'Blocked';
END;
GO

-- Normal bir kayıt (Uyarı oluşturmaz)
INSERT INTO TrafikKayitlari 
(cihaz_id, kullanici_id, ip_adresi, hedef_ip, port_no, protokol, veri_miktari_mb, durum)
VALUES 
(1, 2, '192.168.1.10', '8.8.8.8', 80, 'HTTP', 120.5, 'Allowed');

-- Yüksek trafik kaydı (Uyarı oluşturur)
INSERT INTO TrafikKayitlari 
(cihaz_id, kullanici_id, ip_adresi, hedef_ip, port_no, protokol, veri_miktari_mb, durum)
VALUES 
(1, 2, '192.168.1.11', '8.8.4.4', 443, 'TCP', 1200.5, 'Allowed');

-- Şüpheli protokol (Uyarı oluşturur)
INSERT INTO TrafikKayitlari 
(cihaz_id, kullanici_id, ip_adresi, hedef_ip, port_no, protokol, veri_miktari_mb, durum)
VALUES 
(2, 1, '10.0.0.5', '8.8.8.8', 21, 'FTP', 60.0, 'Allowed');
GO
