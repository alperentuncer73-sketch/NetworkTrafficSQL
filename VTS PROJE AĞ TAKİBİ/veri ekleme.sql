USE [Ag takibi proje];
GO
INSERT INTO TrafficProtocols (ProtocolName, DefaultPort) VALUES ('TCP', NULL), ('UDP', NULL), ('HTTP', 80), ('HTTPS', 443), ('DNS', 53);
INSERT INTO DeviceTypes (TypeName) VALUES ('Router'), ('Switch'), ('Modem'), ('Firewall');
INSERT INTO DeviceModels (Manufacturer, ModelName) VALUES ('Cisco', '2900 Series'), ('HP', 'Aruba 3810M'), ('D-Link', 'DIR-868L');
INSERT INTO GeoLocations (CountryName) VALUES ('Turkey'), ('USA'), ('Germany'), ('China');