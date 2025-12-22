USE master;
GO
--sp_send_dbmail prosedürünü kullanarak veritabanýndaki kritik uyarýlarý 
-- otomatik olarak HTML formatýna çeviren ve yöneticiye mail atan sistem prototipini oluþturucaz
-- 1. geliþmiþ ayarlarý göster
sp_configure 'show advanced options', 1;
RECONFIGURE;

-- 2. Database Mail özelliðini aç
sp_configure 'Database Mail XPs', 1;
RECONFIGURE;

PRINT 'Database Mail özelliði baþarýyla aktif edildi!';
-- Eðer daha önce oluþturmuþsak hata vermemesi için temizlik
IF EXISTS (SELECT * FROM msdb.dbo.sysmail_profile WHERE name = 'AgTakip_Mail_Profili')
BEGIN
    EXEC msdb.dbo.sysmail_delete_profile_sp @profile_name = 'AgTakip_Mail_Profili';
END

IF EXISTS (SELECT * FROM msdb.dbo.sysmail_account WHERE name = 'AgTakip_Gmail_Hesabi')
BEGIN
    EXEC msdb.dbo.sysmail_delete_account_sp @account_name = 'AgTakip_Gmail_Hesabi';
END
GO

-- 1. mail hesabý oluþturma 
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'AgTakip_Gmail_Hesabi',
    @email_address = 'umut@gmail.com', -- Gönderici adresi
    @display_name = 'Að Güvenlik Sistemi',
    @mailserver_name = 'smtp.gmail.com',
    @port = 587,
    @enable_ssl = 1,
    @username = 'umut@gmail.com',
    @password = 'xxyyzzaabbcc'; -- Gmail Uygulama Þifresi 

-- 2. profil oluþturma
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'AgTakip_Mail_Profili',
    @description = 'Að takibi rapor gönderim profili';

-- 3. hesabý profile ekleme
EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'AgTakip_Mail_Profili',
    @account_name = 'AgTakip_Gmail_Hesabi',
    @sequence_number = 1;

PRINT 'Mail profili ve hesap ayarlarý yapýldý.';
