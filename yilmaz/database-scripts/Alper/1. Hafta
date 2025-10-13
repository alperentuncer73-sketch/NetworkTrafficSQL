CREATE TABLE Cihazlar (
    cihaz_id INT IDENTITY(1,1) PRIMARY KEY,
    cihaz_tipi VARCHAR(50) NOT NULL 
        CHECK (cihaz_tipi IN ('Modem','Router','Switch','Access Point','Firewall')),
    cihaz_marka VARCHAR(50) NOT NULL,
    cihaz_model VARCHAR(50) NOT NULL,
    cihaz_ip VARCHAR(50) UNIQUE NOT NULL,
    seri_no VARCHAR(100) UNIQUE,
    lokasyon VARCHAR(100),
    yazilim_versiyon VARCHAR(50),
    donanim_versiyon VARCHAR(50),
    isletim_sistemi VARCHAR(50) DEFAULT 'Embedded Linux',
    durum VARCHAR(20) DEFAULT 'Aktif',        
    kurulum_tarihi DATETIME DEFAULT GETDATE(),
    son_guncelleme DATETIME DEFAULT GETDATE(),
    yonetici VARCHAR(50) DEFAULT 'Admin',
    destek_mail VARCHAR(100),
    garanti_bitis DATE NULL,
    aciklama NVARCHAR(255)
);
CREATE TABLE Kullanici (
    kullanici_id INT IDENTITY(1,1) PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(20),
    departman VARCHAR(50),
    unvan VARCHAR(50) DEFAULT 'User',
    bagli_ip VARCHAR(50),
    mac_adresi VARCHAR(50),
    sifre_hash VARCHAR(255),
    son_giris_tarihi DATETIME,
    kayit_tarihi DATETIME DEFAULT GETDATE(),
    aktif BIT DEFAULT 1,
    rol VARCHAR(50) DEFAULT 'Standart',
    yetki_seviyesi INT DEFAULT 1,
    aciklama NVARCHAR(255)
);
CREATE INDEX idx_kullanici_adsoyad ON Kullanici(ad, soyad);
CREATE INDEX idx_cihaz_tip ON Cihazlar(cihaz_tipi);
