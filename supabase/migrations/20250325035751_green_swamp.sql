/*
  # Corregir estructura de la tabla certificates
  
  1. Cambios
    - Recrear la tabla con IDENTITY para el ID
    - Preservar datos existentes
    - Configurar políticas de seguridad
*/

-- Crear tabla temporal para guardar datos existentes
CREATE TEMP TABLE temp_certificates AS 
SELECT * FROM certificates;

-- Eliminar tabla existente
DROP TABLE IF EXISTS certificates CASCADE;

-- Crear nueva tabla con IDENTITY
CREATE TABLE certificates (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
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

-- Restaurar datos (sin incluir el ID para que se genere automáticamente)
INSERT INTO certificates (
    name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
)
SELECT 
    name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
FROM temp_certificates;

-- Habilitar RLS
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- Crear políticas
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

-- Eliminar tabla temporal
DROP TABLE temp_certificates;