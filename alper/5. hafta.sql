USE AgTrafikDB;
GO

-- ===========================================
-- GÜNLÜK RAPORLAR TABLOSU
-- ===========================================
IF OBJECT_ID('GunlukRaporlar', 'U') IS NOT NULL
    DROP TABLE GunlukRaporlar;
GO

CREATE TABLE GunlukRaporlar (
    rapor_id INT IDENTITY(1,1) PRIMARY KEY,
    rapor_tarihi DATE NOT NULL,
    toplam_trafik_mb DECIMAL(15,2) DEFAULT 0,
    toplam_paket INT DEFAULT 0,
    en_yogun_ip VARCHAR(50),
    en_yogun_port INT,
    en_cok_kullanan_kullanici INT NULL,
    ortalama_paket_boyutu INT DEFAULT 0,
    toplam_baglanti INT DEFAULT 0,
    max_trafik_mb DECIMAL(15,2) DEFAULT 0,
    min_trafik_mb DECIMAL(15,2) DEFAULT 0,
    peak_hour INT,
    raporlayan VARCHAR(50) DEFAULT 'Sistem'
);
GO
