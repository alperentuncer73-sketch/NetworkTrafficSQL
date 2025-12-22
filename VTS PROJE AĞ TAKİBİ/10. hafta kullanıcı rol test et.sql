PRINT ' TEST 1: Analist Kullanýcýsý ';
EXECUTE AS USER = 'Test_Analist'; -- Analist kýlýðýna gir

-- 1. okuma testi (baþarýlý olmalý)
SELECT TOP 5 * FROM TrafficLogs; 

-- 2. silme Testi (hata vermeli)
BEGIN TRY
    DELETE FROM TrafficLogs WHERE LogID = 1;
END TRY
BEGIN CATCH
    PRINT 'BAÞARILI: Analist silme yapamadý. Hata mesajý: ' + ERROR_MESSAGE();
END CATCH

REVERT; -- Kendi yetkine geri dön

PRINT ' TEST 2: viewer kullanýcýsý ';
EXECUTE AS USER = 'Test_Viewer'; -- viewer kýlýðýna gir

-- 1. Ýzinli Tablo Testi (Baþarýlý olmalý)
SELECT TOP 5 * FROM SecurityAlerts;

-- 2. Yasaklý Tablo Testi (HATA VERMELÝ!)
BEGIN TRY
    SELECT TOP 5 * FROM TrafficLogs;
END TRY
BEGIN CATCH
    PRINT 'BAÞARILI: viewer yasaklý tabloyu göremedi. Hata mesajý: ' + ERROR_MESSAGE();
END CATCH

REVERT; 
PRINT 'TEST 3: Admin Kullanýcýsý ';
EXECUTE AS USER = 'Test_Admin'; -- admin kýlýðýna gir

-- 1. Okuma Testi (Baþarýlý olmalý)
SELECT COUNT(*) AS Toplam_Log FROM TrafficLogs;

-- 2. silme testi (baþarýlý olmalý)
-- Test için olmayan bir ID silelim ki veri kaybý olmasýn ama yetkiyi görelim
DELETE FROM TrafficLogs WHERE LogID = -1; 
PRINT 'admin silme iþlemini baþarýyla denedi (Hata almadý).';

REVERT;