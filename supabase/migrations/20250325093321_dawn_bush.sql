/*
  # Restaurar IDs numéricos secuenciales
  
  1. Cambios
    - Recrear la tabla con SERIAL para IDs numéricos secuenciales
    - Preservar datos existentes
    - Mantener las políticas de seguridad
*/

-- Crear tabla temporal
CREATE TEMP TABLE IF NOT EXISTS temp_certificates AS 
SELECT * FROM certificates;

-- Eliminar tabla existente
DROP TABLE IF EXISTS certificates CASCADE;

-- Crear nueva tabla con SERIAL
CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
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

-- Crear índice para mejor rendimiento
CREATE INDEX certificates_id_idx ON certificates(id);

-- Restaurar datos con IDs secuenciales
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
DROP POLICY IF EXISTS "Enable public insert access" ON certificates;
DROP POLICY IF EXISTS "Enable public read access" ON certificates;

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