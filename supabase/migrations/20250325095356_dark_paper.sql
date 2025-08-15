/*
  # Create Certificates Table with Data
  
  1. Changes
    - Create certificates table with proper structure
    - Import all certificate data
    - Set up RLS policies
*/

-- Drop existing table if exists
DROP TABLE IF EXISTS certificates CASCADE;

-- Create certificates table
CREATE TABLE certificates (
    id bigint PRIMARY KEY,
    name text NOT NULL,
    rut text DEFAULT ''::text,
    career text DEFAULT 'No declarada'::text,
    graduation_year integer DEFAULT 0,
    whatsapp text,
    estado text NOT NULL DEFAULT 'En Proceso'::text,
    created_at timestamp with time zone DEFAULT now(),
    qr_url text,
    view_url text
);

-- Create index for better performance
CREATE INDEX certificates_id_idx ON certificates(id);

-- Enable RLS
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable public insert access"
ON certificates
FOR INSERT
TO public
WITH CHECK (true);

CREATE POLICY "Enable public read access"
ON certificates
FOR SELECT
TO public
USING (true);

-- Insert all certificate data
INSERT INTO certificates (id, name, rut, career, created_at, qr_url, view_url, graduation_year, estado, whatsapp) VALUES
(1472003916, 'CRISTIAN PRUEBA', '17566455-6', 'ACTUACIÓN', '2025-03-17 23:46:33.273+00', 'https://certificadoduoc.cl/certificado/1472003916', 'https://certificadoduoc.cl/ValidacionQr?id=1472003916', 2025, 'En Proceso', NULL),
(1472005457, 'Jonathan Alejandro Quintero Yañez', '17510892-0', 'INGENIERÍA EN CONSTRUCCIÓN', '2025-03-15 16:45:39.059+00', 'https://certificadoduoc.cl/certificado/1472005457', 'https://certificadoduoc.cl/ValidacionQr?id=1472005457', 2024, 'En Proceso', NULL),
(1472066976, 'HJKHJKHJKHJHJK', '175664556', 'ACTUACIÓN', '2025-03-18 01:32:17.621+00', 'https://certificadoduoc.cl/certificado/1472066976', 'https://certificadoduoc.cl/ValidacionQr?id=1472066976', 2091, 'En Proceso', NULL),
(1472082408, 'Jorge Alejandro O''compley Belmar', '16240169-6', 'RELACIONES PÚBLICAS MENCIÓN MARKETING', '2025-03-10 18:17:08.902+00', 'https://certificadoduoc.cl/certificado/1472082408', 'https://certificadoduoc.cl/ValidacionQr?id=1472082408', 2010, 'Pagado', NULL),
(1472096917, 'Luis Alberto Hidalgo Ibáñez', '13269593-8', 'INGENIERÍA EN MANTENIMIENTO INDUSTRIAL', '2025-03-13 13:59:50.233+00', 'https://certificadoduoc.cl/certificado/1472096917', 'https://certificadoduoc.cl/ValidacionQr?id=1472096917', 2022, 'Pagado', NULL),
(1472097483, 'Alexis Mario Salgado Sandoval', '18244566-5', 'INGENIERÍA EN ADMINISTRACIÓN MENCIÓN GESTIÓN DE PERSONAS', '2025-03-15 16:47:26.127+00', 'https://certificadoduoc.cl/certificado/1472097483', 'https://certificadoduoc.cl/ValidacionQr?id=1472097483', 2014, 'Pagado', NULL),
(1472133699, 'Giulliano Donato Quiñones Pérez', '13331307-9', 'INGENIERÍA AGRÍCOLA', '2025-03-14 04:27:39.547+00', 'https://certificadoduoc.cl/certificado/1472133699', 'https://certificadoduoc.cl/ValidacionQr?id=1472133699', 2015, 'Pagado', NULL),
(1472144771, 'CRISTIAN DANIEL RETAMAL LIENLAF', '17566455-6', 'ACTUACIÓN', '2025-03-17 23:00:17.526+00', 'https://certificadoduoc.cl/certificado/1472144771', 'https://certificadoduoc.cl/ValidacionQr?id=1472144771', 2025, 'En Proceso', NULL),
(1472154733, 'Gustavo Andrés Pizarro San Martín', '16705906-6', 'TÉCNICO EN GESTIÓN LOGÍSTICA', '2025-03-16 14:50:23.515+00', 'https://certificadoduoc.cl/certificado/1472154733', 'https://certificadoduoc.cl/ValidacionQr?id=1472154733', 2023, 'En Proceso', NULL),
(1472205755, 'Patricio Naveas Holst', '10909479-k', 'INGENIERÍA EN MAQUINARIA Y VEHÍCULOS PESADOS', '2025-03-16 22:32:08.13+00', 'https://certificadoduoc.cl/certificado/1472205755', 'https://certificadoduoc.cl/ValidacionQr?id=1472205755', 2025, 'En Proceso', NULL),
(1472211535, 'Luis Antonio Gallardo Moreno', '6453088-7', 'TÉCNICO EN PREVENCIÓN DE RIESGOS', '2025-03-16 23:14:13.065+00', 'https://certificadoduoc.cl/certificado/1472211535', 'https://certificadoduoc.cl/ValidacionQr?id=1472211535', 1996, 'En Proceso', NULL),
(1472224408, 'Marcelo Antonio Báez Montoya', '11655822-k', 'INGENIERÍA EN INFORMÁTICA', '2025-03-14 21:26:22.465+00', 'https://certificadoduoc.cl/certificado/1472224408', 'https://certificadoduoc.cl/ValidacionQr?id=1472224408', 2018, 'Pagado', NULL),
(1472268103, 'Sebastián Ariel Sepúlveda Belmar', '16319042-7', 'TÉCNICO EN ADMINISTRACIÓN DE EMPRESAS', '2025-03-12 15:33:34.907+00', 'https://certificadoduoc.cl/certificado/1472268103', 'https://certificadoduoc.cl/ValidacionQr?id=1472268103', 2014, 'Pagado', NULL),
(1472268861, 'Diego Maximiliano Bravo Acuña', '18440115-0', 'INGENIERÍA EN ADMINISTRACIÓN MENCIÓN FINANZAS', '2025-03-17 16:32:37.415+00', 'https://certificadoduoc.cl/certificado/1472268861', 'https://certificadoduoc.cl/ValidacionQr?id=1472268861', 2016, 'En Proceso', NULL),
(1472343396, 'Rubén Omar Moreno Muñoz', '17426970-k', 'INGENIERÍA EN CONSTRUCCIÓN', '2025-03-16 15:04:44.392+00', 'https://certificadoduoc.cl/certificado/1472343396', 'https://certificadoduoc.cl/ValidacionQr?id=1472343396', 2025, 'En Proceso', NULL),
(1472348881, 'CRISTIAN RETAMAL LIENLAF', '17566455-6', 'ACTUACIÓN', '2025-03-17 23:47:48.89+00', 'https://certificadoduoc.cl/certificado/1472348881', 'https://certificadoduoc.cl/ValidacionQr?id=1472348881', 2025, 'En Proceso', NULL),
(1472354927, 'Salomon Andres Inarejo Rivera', '14364152-k', 'TÉCNICO EN LOGÍSTICA', '2025-03-10 16:21:35.944+00', 'https://certificadoduoc.cl/certificado/1472354927', 'https://certificadoduoc.cl/ValidacionQr?id=1472354927', 2024, 'Pagado', NULL),
(1472379629, 'Luis Fernando Calquin Vergara', '19422292-0', 'INGENIERÍA EN ELECTRICIDAD Y AUTOMATIZACIÓN INDUSTRIAL', '2025-03-12 22:50:08.831+00', 'https://certificadoduoc.cl/certificado/1472379629', 'https://certificadoduoc.cl/ValidacionQr?id=1472379629', 2020, 'Pagado', NULL),
(1472446439, 'PRUEBA PRUEBA PRUEBA', '175656765', 'ADMINISTRACIÓN EN TURISMO Y HOSPITALIDAD MENCIÓN ADMINISTRACIÓN HOTELERA', '2025-03-18 00:22:47.163+00', 'https://certificadoduoc.cl/certificado/1472446439', 'https://certificadoduoc.cl/ValidacionQr?id=1472446439', 2017, 'En Proceso', NULL),
(1472449250, 'CRISTIAN ROJAS ROJAS', '175664556', 'ACTUACIÓN', '2025-03-18 00:02:37.21+00', 'https://certificadoduoc.cl/certificado/1472449250', 'https://certificadoduoc.cl/ValidacionQr?id=1472449250', 2009, 'En Proceso', NULL),
(1472521670, 'Roberto Alejandro Espinoza Rivera', '13958291-8', 'INGENIERÍA EN MANTENIMIENTO INDUSTRIAL', '2025-03-13 16:52:08.797+00', 'https://certificadoduoc.cl/certificado/1472521670', 'https://certificadoduoc.cl/ValidacionQr?id=1472521670', 2022, 'En Proceso', NULL),
(1472524359, 'CRISTIAN DANIEL RETAMAL LIENLAF', '17566455-6', 'ADMINISTRACIÓN PÚBLICA', '2025-03-17 22:14:05.741+00', 'https://certificadoduoc.cl/certificado/1472524359', 'https://certificadoduoc.cl/ValidacionQr?id=1472524359', 2014, 'En Proceso', NULL),
(1472536240, 'JUAN YAÑEZ', '175664556', 'ADMINISTRACIÓN DE EMPRESAS', '2025-03-18 01:30:41.82+00', 'https://certificadoduoc.cl/certificado/1472536240', 'https://certificadoduoc.cl/ValidacionQr?id=1472536240', 2010, 'En Proceso', NULL),
(1472565866, 'Luis Antonio Gallardo Moreno', '6453088-7', 'INGENIERÍA EN PREVENCIÓN DE RIESGOS', '2025-03-12 23:12:04.232+00', 'https://certificadoduoc.cl/certificado/1472565866', 'https://certificadoduoc.cl/ValidacionQr?id=1472565866', 2000, 'Pagado', NULL),
(1472634752, 'CRISTIAN DANIEL RETAMAL LIENLAF', '17566455-6', 'TÉCNICO AGRÍCOLA', '2025-03-17 21:42:50.426+00', 'https://certificadoduoc.cl/certificado/1472634752', 'https://certificadoduoc.cl/ValidacionQr?id=1472634752', 2014, 'En Proceso', NULL),
(1472648504, 'Luis Serrano', '26384552-8', 'INGENIERÍA EN ADMINISTRACIÓN MENCIÓN INNOVACIÓN Y EMPRENDIMIENTO', '2025-03-17 05:24:52.758+00', 'https://certificadoduoc.cl/certificado/1472648504', 'https://certificadoduoc.cl/ValidacionQr?id=1472648504', 2010, 'En Proceso', NULL),
(1472667464, 'Luis Antonio Gallardo Moreno', '6453088-7', 'INGENIERÍA EN GESTIÓN EN CENTROS EDUCATIVOS', '2025-03-14 02:04:22.9+00', 'https://certificadoduoc.cl/certificado/1472667464', 'https://certificadoduoc.cl/ValidacionQr?id=1472667464', 1998, 'Pagado', NULL),
(1472680464, 'Boriz Ibar Calibar Melgarejo', '16926733-2', 'INGENIERÍA EN ELECTRICIDAD Y AUTOMATIZACIÓN INDUSTRIAL', '2025-03-15 17:56:41.934+00', 'https://certificadoduoc.cl/certificado/1472680464', 'https://certificadoduoc.cl/ValidacionQr?id=1472680464', 2025, 'En Proceso', NULL),
(1472701604, 'HJJHFHFHJ', '12325435354', 'ADMINISTRACIÓN EN TURISMO Y HOSPITALIDAD MENCIÓN GESTIÓN PARA EL ECOTURISMO', '2025-03-18 01:40:09.013+00', 'https://certificadoduoc.cl/certificado/1472701604', 'https://certificadoduoc.cl/ValidacionQr?id=1472701604', 2335, 'En Proceso', NULL),
(1472703013, 'CARLOS GIULIANO LARCO ROJAS', '11889965-2', 'INGENIERÍA EN ELECTRICIDAD Y AUTOMATIZACIÓN INDUSTRIAL', '2025-03-17 22:21:34.157+00', 'https://certificadoduoc.cl/certificado/1472703013', 'https://certificadoduoc.cl/ValidacionQr?id=1472703013', 1996, 'En Proceso', NULL),
(1472726385, 'Hugo Antonio Avendaño Reyes', '10408861-9', 'INGENIERÍA EN ELECTRICIDAD Y AUTOMATIZACIÓN INDUSTRIAL', '2025-03-13 22:36:57.467+00', 'https://certificadoduoc.cl/certificado/1472726385', 'https://certificadoduoc.cl/ValidacionQr?id=1472726385', 2024, 'En Proceso', NULL),
(1472732479, 'Mauricio Osvaldo Matus Lizana', '17226411-5', 'INGENIERÍA EN REDES Y TELECOMUNICACIONES', '2025-03-10 19:10:31.476+00', 'https://certificadoduoc.cl/certificado/1472732479', 'https://certificadoduoc.cl/ValidacionQr?id=1472732479', 2024, 'En Proceso', NULL),
(1472786172, 'CRISTIAN RETAMAL', '17566455-6', 'ADMINISTRACIÓN DE EMPRESAS', '2025-03-17 23:30:21.783+00', 'https://certificadoduoc.cl/certificado/1472786172', 'https://certificadoduoc.cl/ValidacionQr?id=1472786172', 2676, 'En Proceso', NULL),
(1472821773, 'Mauricio Raul Alejandro Castillo Flores', '15886360-k', 'INGENIERÍA INDUSTRIAL', '2025-03-14 04:39:52.758+00', 'https://certificadoduoc.cl/certificado/1472821773', 'https://certificadoduoc.cl/ValidacionQr?id=1472821773', 2023, 'En Proceso', NULL),
(1472840909, 'CRISTIAN ROJAS ROJAS ROJAS', '17566455-6', 'ADMINISTRACIÓN DE EMPRESAS', '2025-03-17 23:03:37.194+00', 'https://certificadoduoc.cl/certificado/1472840909', 'https://certificadoduoc.cl/ValidacionQr?id=1472840909', 2025, 'En Proceso', NULL),
(1472873892, 'GHGHJGJG', '13.986.158-2', 'DESARROLLO Y DISEÑO WEB', '2025-03-18 01:44:34.217+00', 'https://certificadoduoc.cl/certificado/1472873892', 'https://certificadoduoc.cl/ValidacionQr?id=1472873892', 2654, 'En Proceso', '96564566456'),
(1472903435, 'FRANCISCO JAVIER INZULZA PÉREZ', '17566645567', 'COMERCIO EXTERIOR', '2025-03-18 02:07:50.906+00', 'https://certificadoduoc.cl/certificado/1472903435', 'https://certificadoduoc.cl/ValidacionQr?id=1472903435', 2785, 'En Proceso', '967564564'),
(1472910830, 'Héctor Andrés Aguayo Chandia', '8206941-0', 'TÉCNICO EN RELACIONES PÚBLICAS', '2025-03-14 04:09:12.627+00', 'https://certificadoduoc.cl/certificado/1472910830', 'https://certificadoduoc.cl/ValidacionQr?id=1472910830', 2009, 'Pagado', NULL),
(1472924623, 'HGFHGFGHFGH', '178675675', 'ADMINISTRACIÓN EN TURISMO Y HOSPITALIDAD MENCIÓN GESTIÓN PARA EL ECOTURISMO', '2025-03-18 01:38:14.063+00', 'https://certificadoduoc.cl/certificado/1472924623', 'https://certificadoduoc.cl/ValidacionQr?id=1472924623', 2186, 'En Proceso', NULL),
(1472926345, 'Daniel Antonio Morales Bustos', '18858110-2', 'TÉCNICO EN CONSTRUCCIÓN', '2025-03-12 05:15:30.489+00', 'https://certificadoduoc.cl/certificado/1472926345', 'https://certificadoduoc.cl/ValidacionQr?id=1472926345', 2024, 'En Proceso', NULL),
(1472933729, 'CRISTIAN ROJAS', '17566455-6', 'DESARROLLO Y DISEÑO WEB', '2025-03-17 20:52:36.531+00', 'https://certificadoduoc.cl/certificado/1472933729', 'https://certificadoduoc.cl/ValidacionQr?id=1472933729', 2014, 'En Proceso', NULL),
(1472943202, 'PRUEBA PRUEBA', '174576756', 'ACTUACIÓN', '2025-03-17 23:51:06.506+00', 'https://certificadoduoc.cl/certificado/1472943202', 'https://certificadoduoc.cl/ValidacionQr?id=1472943202', 2025, 'En Proceso', NULL),
(1472956802, 'Karina De Las Mercedes Amaya Hera', '26399459-0', 'ADMINISTRACIÓN DE EMPRESAS', '2025-03-10 16:25:52.322+00', 'https://certificadoduoc.cl/certificado/1472956802', 'https://certificadoduoc.cl/ValidacionQr?id=1472956802', 2018, 'Pagado', NULL),
(1472959313, 'Jonathan Albert Iturrieta Villagran', '16391106-k', 'INGENIERÍA EN MANTENIMIENTO INDUSTRIAL', '2025-03-13 14:26:57.483+00', 'https://certificadoduoc.cl/certificado/1472959313', 'https://certificadoduoc.cl/ValidacionQr?id=1472959313', 2010, 'Pagado', NULL),
(1756262104, 'CARLOS ALBERTO LEIVA VIDAL', '16389007-0', 'INGENIERÍA EN OPERACIÓN Y SUPERVISIÓN DE PROCESOS MINEROS', '2025-03-08 01:43:56.5+00', 'https://certificadoduoc.cl/certificado/1756262104', 'https://certificadoduoc.cl/ValidacionQr?id=1756262104', NULL, 'En Proceso', NULL),
(3611904904, 'LUIS ERWIN MANQUEL PAVEZ', '12564263-2', 'TÉCNICO EN ELECTRICIDAD Y AUTOMATIZACIÓN INDUSTRIAL', '2025-03-07 22:47:55.635+00', 'https://certificadoduoc.cl/certificado/3611904904', 'https://certificadoduoc.cl/ValidacionQr?id=3611904904', NULL, 'Pagado', NULL),
(3616572122, 'LUIS ALFREDO VALENZUELA SEPÚLVEDA', '16704209-0', 'TÉCNICO EN MANTENIMIENTO ELECTROMECÁNICO', '2025-03-08 00:12:15.168+00', 'https://certificadoduoc.cl/certificado/3616572122', 'https://certificadoduoc.cl/ValidacionQr?id=3616572122', NULL, 'En Proceso', NULL),
(7135360529, 'OSCAR RODRIGO VARGAS PEÑA', '12641423-4', 'INGENIERÍA EN ADMINISTRACIÓN MENCIÓN INNOVACIÓN Y EMPRENDIMIENTO', '2025-03-08 02:00:26.082+00', 'https://certificadoduoc.cl/certificado/7135360529', 'https://certificadoduoc.cl/ValidacionQr?id=7135360529', NULL, 'Pagado', NULL),
(7984953814, 'CARLOS ALBERTO LEIVA VIDAL', '16389007-0', 'INGENIERÍA EN MANTENIMIENTO INDUSTRIAL', '2025-03-08 01:45:43.222+00', 'https://certificadoduoc.cl/certificado/7984953814', 'https://certificadoduoc.cl/ValidacionQr?id=7984953814', NULL, 'En Proceso', NULL);