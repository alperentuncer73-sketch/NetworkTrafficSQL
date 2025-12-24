USE AgTrafikDB;
GO

-- ===========================================
-- IP BAZLI RAPOR GÖRÜNÜMÜ
-- ===========================================
CREATE OR ALTER VIEW vw_IPBazliRapor
AS
SELECT
    ip_adresi AS KaynakIP,
    COUNT(*) AS BaglantiSayisi,
    SUM(veri_miktari_mb) AS ToplamVeri_MB,
    AVG(veri_miktari_mb) AS OrtalamaVeri_MB,
    MAX(veri_miktari_mb) AS EnYuksekVeri_MB,
    MIN(veri_miktari_mb) AS EnDusukVeri_MB,
    COUNT(DISTINCT hedef_ip) AS FarkliHedefSayisi,
    STRING_AGG(DISTINCT protokol, ', ') AS KullanilanProtokoller
FROM TrafikKayitlari
GROUP BY ip_adresi;
GO

SELECT TOP 10 * 
FROM vw_IPBazliRapor
ORDER BY ToplamVeri_MB DESC;
GO
