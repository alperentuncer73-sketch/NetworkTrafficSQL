CREATE OR ALTER PROCEDURE sp_IPBazliRapor
    @MinVeriMB DECIMAL(10,2) = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ip_adresi AS KaynakIP,
        COUNT(*) AS BaglantiSayisi,
        SUM(veri_miktari_mb) AS ToplamVeri_MB,
        AVG(veri_miktari_mb) AS OrtalamaVeri_MB,
        STRING_AGG(DISTINCT protokol, ', ') AS KullanilanProtokoller
    FROM TrafikKayitlari
    WHERE veri_miktari_mb >= @MinVeriMB
    GROUP BY ip_adresi
    ORDER BY ToplamVeri_MB DESC;
END;
GO

EXEC sp_IPBazliRapor @MinVeriMB = 100;
GO
