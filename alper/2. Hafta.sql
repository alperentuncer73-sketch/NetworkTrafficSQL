-- ===========================================
-- 2. HAFTA – E-R DİYAGRAMI TEMEL TABLOLARI
-- ===========================================

-- Veritabanı oluşturma
IF DB_ID('AgTrafikDB') IS NULL
    CREATE DATABASE AgTrafikDB;
GO

USE AgTrafikDB;
GO

-- Cihazlar Tablosu
CREATE TABLE Cihazlar (
    cihaz_id INT IDENTITY(1,1) PRIMARY KEY,
    cihaz_tipi VARCHAR(50) NOT NULL 
        CHECK (cihaz_tipi IN ('Modem','Router','Switch','Access Point','Firewall')),
    cihaz_marka VARCHAR(50) NOT NULL,
    cihaz_model VARCHAR(50) NOT NULL,
    cihaz_ip VARCHAR(50) UNIQUE NOT NULL,
    seri_no VARCHAR(100) UNIQUE,
    lokasyon VARCHAR(100),
    durum VARCHAR(20) DEFAULT 'Aktif'
);

-- Kullanıcılar Tablosu
CREATE TABLE Kullanici (
    kullanici_id INT IDENTITY(1,1) PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(20),
    aktif BIT DEFAULT 1
);

-- Trafik Kayıtları Tablosu
CREATE TABLE TrafikKayitlari (
    kayit_id INT IDENTITY(1,1) PRIMARY KEY,
    cihaz_id INT NOT NULL,
    kullanici_id INT,
    ip_adresi VARCHAR(50),
    hedef_ip VARCHAR(50),
    port_no INT CHECK (port_no BETWEEN 1 AND 65535),
    protokol VARCHAR(20),
    veri_miktari_mb DECIMAL(10,2),
    tarih_saat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (cihaz_id) REFERENCES Cihazlar(cihaz_id),
    FOREIGN KEY (kullanici_id) REFERENCES Kullanici(kullanici_id)
);

-- Uyarılar Tablosu
CREATE TABLE Uyarilar (
    uyari_id INT IDENTITY(1,1) PRIMARY KEY,
    cihaz_id INT NOT NULL,
    sebep VARCHAR(255),
    seviye VARCHAR(20) CHECK (seviye IN ('Low','Medium','High','Critical')),
    tarih_saat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (cihaz_id) REFERENCES Cihazlar(cihaz_id)
);

-- Günlük Raporlar Tablosu
CREATE TABLE GunlukRaporlar (
    rapor_id INT IDENTITY(1,1) PRIMARY KEY,
    rapor_tarihi DATE NOT NULL,
    toplam_trafik_mb DECIMAL(15,2),
    en_yogun_ip VARCHAR(50),
    peak_hour INT
);

-- İndeksler
CREATE INDEX idx_cihaz_tip ON Cihazlar(cihaz_tipi);
CREATE INDEX idx_trafik_tarih ON TrafikKayitlari(tarih_saat);
CREATE INDEX idx_uyari_tarih ON Uyarilar(tarih_saat);
