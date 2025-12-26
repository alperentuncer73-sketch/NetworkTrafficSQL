-- ===========================================
-- 4. HAFTA – TEST İÇİN ÖRNEK CİHAZ VERİLERİ EKLEME
-- ===========================================

USE AgTrafikDB;
GO

-- ===============================
-- 1️⃣ VAR OLAN VERİLERİ KONTROL ET
-- ===============================
SELECT * FROM Cihazlar;
GO

-- ===============================
-- 2️⃣ YENİ TEST CİHAZLARI EKLE
-- ===============================
INSERT INTO Cihazlar (
    cihaz_tipi, cihaz_marka, cihaz_model, cihaz_ip, seri_no, lokasyon, 
    yazilim_versiyon, donanim_versiyon, isletim_sistemi, durum, yonetici, destek_mail, garanti_bitis, aciklama
)
VALUES
('Modem', 'Zyxel', 'VMG3312', '172.16.1.1', 'ZXL123456', 'Ofis Katı 2', 'v2.0.3', 'HW2.1', 'Linux', 'Aktif', 'Ali Alper', 'support@zyxel.com', '2026-05-15', 'Ana modem cihazı'),
('Router', 'Asus', 'RT-AX58U', '172.16.1.2', 'ASU987654', 'Ofis Katı 1', 'v3.0.1', 'HW1.5', 'AsusWRT', 'Aktif', 'Ali Alper', 'support@asus.com', '2025-12-01', 'Kablosuz router'),
('Switch', 'Netgear', 'GS308', '10.1.1.1', 'NET554433', 'Server Odası', 'v1.1', 'HW1.0', 'NetOS', 'Pasif', 'Ali Alper', 'help@netgear.com', '2027-03-11', '8 port switch'),
('Firewall', 'Fortigate', 'FG-60E', '10.10.0.1', 'FG600E123', 'Güvenlik Bölümü', 'v7.0', 'HW3.0', 'FortiOS', 'Aktif', 'Ali Alper', 'security@fortinet.com', '2028-01-10', 'Ana güvenlik duvarı'),
('Access Point', 'Ubiquiti', 'UAP-AC-Lite', '192.168.10.5', 'UAP123987', 'Laboratuvar', 'v6.0', 'HW2.3', 'UniFiOS', 'Aktif', 'Ali Alper', 'support@ubnt.com', '2026-11-20', 'Kablosuz erişim noktası');
GO

-- ===============================
-- 3️⃣ TEST AMAÇLI SORGULAR
-- ===============================

-- 3.1) Tüm cihazları listele
SELECT cihaz_id, cihaz_tipi, cihaz_marka, cihaz_model, cihaz_ip, durum, lokasyon
FROM Cihazlar;

-- 3.2) Sadece aktif cihazları getir
SELECT *
FROM Cihazlar
WHERE durum = 'Aktif';

-- 3.3) Garanti süresi bitmek üzere olan cihazları bul
SELECT cihaz_marka, cihaz_model, garanti_bitis
FROM Cihazlar
WHERE garanti_bitis < DATEADD(YEAR, 1, GETDATE());

-- 3.4) Aynı yöneticideki cihazları listele
SELECT yonetici, COUNT(*) AS ToplamCihaz
FROM Cihazlar
GROUP BY yonetici;

-- 3.5) Marka bazlı toplam cihaz sayısı
SELECT cihaz_marka, COUNT(*) AS Adet
FROM Cihazlar
GROUP BY cihaz_marka
ORDER BY Adet DESC;
GO
