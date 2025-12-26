USE AgTrafikDB;
GO

-- ===========================================
-- JSON VERİSİNİ OKUMA VE TABLOYA EKLEME
-- ===========================================

DECLARE @json NVARCHAR(MAX);

SET @json = N'
[
  {"cihaz_tipi": "Router", "cihaz_marka": "Huawei", "cihaz_model": "AX3 DualCore", "cihaz_ip": "192.168.2.1", "seri_no": "HUAWEI001", "lokasyon": "Ofis Katı 3", "yazilim_versiyon": "v3.5.2", "donanim_versiyon": "HW2.0", "isletim_sistemi": "HarmonyOS", "durum": "Aktif"},
  {"cihaz_tipi": "Switch", "cihaz_marka": "Cisco", "cihaz_model": "SG500", "cihaz_ip": "10.10.10.10", "seri_no": "CISCO7788", "lokasyon": "Sunucu Odası", "yazilim_versiyon": "v1.9", "donanim_versiyon": "HW1.0", "isletim_sistemi": "Cisco IOS", "durum": "Aktif"},
  {"cihaz_tipi": "Modem", "cihaz_marka": "ZTE", "cihaz_model": "ZXHN H267A", "cihaz_ip": "172.16.0.10", "seri_no": "ZTE998877", "lokasyon": "Laboratuvar", "yazilim_versiyon": "v4.0.1", "donanim_versiyon": "HW3.1", "isletim_sistemi": "Embedded Linux", "durum": "Pasif"}
]
';

INSERT INTO Cihazlar (
    cihaz_tipi, cihaz_marka, cihaz_model, cihaz_ip, seri_no, lokasyon,
    yazilim_versiyon, donanim_versiyon, isletim_sistemi, durum
)
SELECT 
    cihaz_tipi, cihaz_marka, cihaz_model, cihaz_ip, seri_no, lokasyon,
    yazilim_versiyon, donanim_versiyon, isletim_sistemi, durum
FROM OPENJSON(@json)
WITH (
    cihaz_tipi NVARCHAR(50),
    cihaz_marka NVARCHAR(50),
    cihaz_model NVARCHAR(50),
    cihaz_ip NVARCHAR(50),
    seri_no NVARCHAR(100),
    lokasyon NVARCHAR(100),
    yazilim_versiyon NVARCHAR(50),
    donanim_versiyon NVARCHAR(50),
    isletim_sistemi NVARCHAR(50),
    durum NVARCHAR(20)
);
GO

-- ===========================================
-- VERİLERİ KONTROL ET
-- ===========================================
SELECT *
FROM Cihazlar
WHERE cihaz_ip IN ('192.168.2.1', '10.10.10.10', '172.16.0.10');
GO
