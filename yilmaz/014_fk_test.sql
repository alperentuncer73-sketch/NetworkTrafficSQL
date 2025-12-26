-- HAFTA 13: FK Ilişki Kontrolü

USE TrafficLogDB;
GO

-- FK iliskilerini görme --
SELECT fk.name AS fk_adi, tp.name AS parent_tablo, tr.name AS referans_tablo
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id;
GO

-- FK ekleme --
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_TrafficLogs_Devices_Schema')
BEGIN
    ALTER TABLE monitoring.traffic_logs
    ADD CONSTRAINT FK_TrafficLogs_Devices_Schema FOREIGN KEY (device_id) REFERENCES network.devices(device_id);
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Alerts_Devices_Schema')
BEGIN
    ALTER TABLE monitoring.alerts
    ADD CONSTRAINT FK_Alerts_Devices_Schema FOREIGN KEY (device_id) REFERENCES network.devices(device_id);
END
GO

-- Veri bütünlüğü testi -- 
BEGIN TRY
    INSERT INTO monitoring.traffic_logs (device_id, source_ip, dest_ip, port_no, protocol, data_size, status)
    VALUES (9999, '1.1.1.1', '2.2.2.2', 80, 'HTTP', 10, 'Allowed');
    PRINT 'HATA: FK calişmadı!';
END TRY
BEGIN CATCH
    PRINT 'OK: FK hatasi alındi.';
END CATCH
GO

-- Yetim kayıt tessti --
SELECT COUNT(*) AS yetim_trafik FROM monitoring.traffic_logs t
LEFT JOIN network.devices d ON t.device_id = d.device_id WHERE d.device_id IS NULL;

SELECT COUNT(*) AS yetim_uyari FROM monitoring.alerts a
LEFT JOIN network.devices d ON a.device_id = d.device_id WHERE d.device_id IS NULL;

PRINT 'Hafta 13 tamamlandı.';
GO
