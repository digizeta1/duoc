/*
  # Add Missing Certificates
  
  1. Changes
    - Insert new certificates from Excel data that aren't in the database
    - Preserve existing certificates
    - Maintain data integrity
*/

-- Insert new certificates that don't exist yet
INSERT INTO certificates (
    id, name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
)
VALUES 
    (1742815592, 'JUAN FRANCISC GARCIA PARAM', '15379129-5', 'INGENIERÍA EN MAQUINARIA PESADA Y VEHÍCULOS AUTOMOTRICES', 2006, '999746629', 'En Proceso', '2025-03-24 11:26:32.792139+00', 'https://certificadoduoc.cl/certificado/1742815592', 'https://certificadoduoc.cl/ValidacionQr?id=1742815592'),
    (1742814086, 'HAROLD MITCHELL AGLONY PERCHERON', '16147195-K', 'DIBUJO Y MODELAMIENTO ARQUITECTÓNICO Y ESTRUCTURAL', 2016, '956326675', 'En Proceso', '2025-03-24 11:01:26.957434+00', 'https://certificadoduoc.cl/certificado/1742814086', 'https://certificadoduoc.cl/ValidacionQr?id=1742814086'),
    (1742781065, 'CARLOS ADOLFO GÓMEZ GÓMEZ', '17483719-8', 'INGENIERO CONSTRUCTOR', 2024, '973380181', 'Pagado', '2025-03-24 01:51:06.03016+00', 'https://certificadoduoc.cl/certificado/1742781065', 'https://certificadoduoc.cl/ValidacionQr?id=1742781065'),
    (1742694502, 'EMILIO ANTONIO HERNANDEZ ZAMORANO', '9865936-6', 'TÉCNICO EN REDES Y TELECOMUNICACIONES', 2020, '955193655', 'Recordatorio 2', '2025-03-23 01:48:22.252555+00', 'https://certificadoduoc.cl/certificado/1742694502', 'https://certificadoduoc.cl/ValidacionQr?id=1742694502'),
    (1742682111, 'LUIS ROBERTO NAVEAS HOLST', '8216922-9', 'INGENIERÍA EN ADMINISTRACIÓN MENCIÓN FINANZAS', 2000, '991952297', 'Recordatorio 2', '2025-03-22 22:21:51.764445+00', 'https://certificadoduoc.cl/certificado/1742682111', 'https://certificadoduoc.cl/ValidacionQr?id=1742682111'),
    (1742656930, 'IGNACIO CARLOS ALMENDRA CHACON', '15658822-3', 'INGENIERÍA EN CONSTRUCCIÓN', 2012, '922479998', 'Recordatorio 2', '2025-03-22 15:22:09.907464+00', 'https://certificadoduoc.cl/certificado/1742656930', 'https://certificadoduoc.cl/ValidacionQr?id=1742656930'),
    (1742518008, 'LUIS ELMODAM SEGURA RIFFO', '17887022-k', 'INGENIERÍA EN INFORMÁTICA', 2018, '968500056', 'Recordatorio 4', '2025-03-21 00:46:48.63793+00', 'https://certificadoduoc.cl/certificado/1742518008', 'https://certificadoduoc.cl/ValidacionQr?id=1742518008'),
    (1742512002, 'ANIBAL ALEJANDRO TORRES PIRUL', '10046688-0', 'INGENIERÍA EN MECÁNICA AUTOMOTRIZ Y AUTOTRÓNICA', 2003, '926271084', 'Pagado', '2025-03-20 23:06:41.672333+00', 'https://certificadoduoc.cl/certificado/1742512002', 'https://certificadoduoc.cl/ValidacionQr?id=1742512002'),
    (1742511088, 'MAURICIO OSVALDO MATUS LIZANA', '17226411-5', 'INGENIERÍA EN REDES Y TELECOMUNICACIONES', 2025, '974950593', 'Pagado', '2025-03-20 22:51:27.578057+00', 'https://certificadoduoc.cl/certificado/1742511088', 'https://certificadoduoc.cl/ValidacionQr?id=1742511088'),
    (1742503660, 'DAVID ALEJANDRO CERDA LIZAMA', '16335282-6', 'INGENIERÍA EN CONSTRUCCIÓN', 2018, '986327708', 'Recordatorio 4', '2025-03-20 20:47:40.479319+00', 'https://certificadoduoc.cl/certificado/1742503660', 'https://certificadoduoc.cl/ValidacionQr?id=1742503660'),
    (1742483870, 'CLAUDIO ALARCÓN MENARES', '17951706-K', 'ANALISTA PROGRAMADOR', 2025, '922549455', 'Recordatorio 4', '2025-03-20 15:17:51.358095+00', 'https://certificadoduoc.cl/certificado/1742483870', 'https://certificadoduoc.cl/ValidacionQr?id=1742483870'),
    (1742418094, 'HUGO ENRIQUE URBINA CHAVEZ', '15900618-2', 'TÉCNICO EN CONSTRUCCIÓN', 2018, '945487810', 'Recordatorio 4', '2025-03-19 21:01:34.949874+00', 'https://certificadoduoc.cl/certificado/1742418094', 'https://certificadoduoc.cl/ValidacionQr?id=1742418094'),
    (1742412619, 'CRISTOBAL FRANCISCO TAPIA VERDEJO', '20845488-9', 'INGENIERÍA EN MAQUINARIA Y VEHÍCULOS PESADOS', 2024, '976543830', 'Pagado', '2025-03-19 19:30:20.775441+00', 'https://certificadoduoc.cl/certificado/1742412619', 'https://certificadoduoc.cl/ValidacionQr?id=1742412619'),
    (1742397024, 'LUIS ROBERTO NAVEAS HOLST', '8216922-9', 'CONTADOR AUDITOR', 1994, '991952297', 'Pagado', '2025-03-19 15:10:25.558858+00', 'https://certificadoduoc.cl/certificado/1742397024', 'https://certificadoduoc.cl/ValidacionQr?id=1742397024')
ON CONFLICT (id) DO NOTHING;