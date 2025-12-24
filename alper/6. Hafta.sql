-- ===========================================
-- GÜNLÜK RAPOR OLUŞTURMA (ÖRNEK)
-- ===========================================

INSERT INTO GunlukRaporlar (
    rapor_tarihi,
    toplam_trafik_mb,
    toplam_paket,
    en_yogun_ip,
    en_yogun_port,
    ortalama_paket_boyutu,
    toplam_baglanti,
    max_trafik_mb,
    min_trafik_mb,
    peak_hour,
    raporlayan
)
SELECT
    CAST(GETDATE() AS DATE) AS rapor_tarihi,
    SUM(veri_miktari_mb) AS toplam_trafik_mb,
    SUM(paket_sayisi) AS toplam_paket,
    TOP_IP.kaynak_ip AS en_yogun_ip,
    TOP_PORT.port_no AS en_yogun_port,
    AVG(paket_boyutu_avg) AS ortalama_paket_boyutu,
    COUNT(*) AS toplam_baglanti,
    MAX(veri_miktari_mb) AS max_trafik_mb,
    MIN(veri_miktari_mb) AS min_trafik_mb,
    DATEPART(HOUR, MAX(tarih_saat)) AS peak_hour,
    'Ali Alper' AS raporlayan
FROM TrafikKayitlari
CROSS APPLY (
    SELECT TOP 1 kaynak_ip
    FROM TrafikKayitlari
    GROUP BY kaynak_ip
    ORDER BY SUM(veri_miktari_mb) DESC
) AS TOP_IP
CROSS APPLY (
    SELECT TOP 1 port_no
    FROM TrafikKayitlari
    GROUP BY port_no
    ORDER BY COUNT(*) DESC
) AS TOP_PORT;
GO
