USE [Ag takibi proje];
GO

DECLARE @xml NVARCHAR(MAX);
DECLARE @body NVARCHAR(MAX);

-- veriyi HTML tablo satırlarına çevirme (XML PATH yöntemi)
SET @xml = CAST(( 
    SELECT 
        AlertID AS 'td', '',
        Severity AS 'td', '',
        SourceDeviceIP AS 'td', '',
        TrafficRateMbps AS 'td', '',
        DetailDescription AS 'td'
    FROM SecurityAlerts
    WHERE AlertTimestamp > DATEADD(DAY, -7, GETDATE()) -- Son 7 gün
    ORDER BY AlertID DESC
    FOR XML PATH('tr'), ELEMENTS 
) AS NVARCHAR(MAX));

-- 2. HTML iskeletini oluþturma
SET @body = 
    '<html>
    <head>
        <style>
            table { border-collapse: collapse; width: 100%; font-family: Arial; }
            th { background-color: #4CAF50; color: white; padding: 8px; }
            td { border: 1px solid #ddd; padding: 8px; }
            tr:nth-child(even) { background-color: #f2f2f2; }
        </style>
    </head>
    <body>
        <h2>?? Haftalýk Að Güvenlik Raporu</h2>
        <p>Aþaðýda sistem tarafýndan tespit edilen kritik trafik uyarýlarý listelenmiþtir:</p>
        <table>
            <tr>
                <th>Alarm ID</th>
                <th>Seviye</th>
                <th>Kaynak IP</th>
                <th>Trafik (MB)</th>
                <th>Açýklama</th>
            </tr>' 
            + @xml + 
        '</table>
        <p><i>Bu mesaj SQL Server Otomasyon Sistemi tarafýndan gönderilmiþtir.</i></p>
    </body>
    </html>';

-- 3. Maili Gönder (sp_send_dbmail)
--  @recipients kısmına kendi mailimizi yazarak test edebiliriz
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'AgTakip_Mail_Profili',
    @recipients = 'yonetici@sirket.com', 
    @subject = '?? Kritik Að Raporu - Otomatik Bildirim',
    @body = @body,
    @body_format = 'HTML';

PRINT 'Rapor oluþturuldu ve mail kuyruðuna eklendi!';

SELECT 
    sent_date,
    recipients,
    subject,
    sent_status -- Burasý 'sent' veya 'unsent' yazar
FROM msdb.dbo.sysmail_mailitems

ORDER BY sent_date DESC;
