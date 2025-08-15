/*
  # Cambiar ID de certificates a UUID
  
  1. Cambios
    - Cambiar el tipo de columna id de SERIAL a UUID
    - Usar gen_random_uuid() para generar IDs automáticamente
    - Mantener las políticas de seguridad existentes
*/

-- Crear tabla temporal
CREATE TEMP TABLE IF NOT EXISTS temp_certificates AS 
SELECT * FROM certificates;

-- Eliminar tabla existente
DROP TABLE IF EXISTS certificates CASCADE;

-- Crear nueva tabla con UUID
CREATE TABLE certificates (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
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

-- Restaurar datos existentes con nuevos UUIDs
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

-- Recrear políticas
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