/*
  # Restore certificates table to previous working version
  
  1. Changes
    - Recreate certificates table with original structure
    - Restore existing data
    - Set up proper security policies
*/

-- Create temporary table
CREATE TEMP TABLE IF NOT EXISTS temp_certificates AS 
SELECT * FROM certificates;

-- Drop existing table
DROP TABLE IF EXISTS certificates CASCADE;

-- Create new table with UUID
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

-- Restore data
INSERT INTO certificates (
    name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
)
SELECT 
    name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
FROM temp_certificates;

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

-- Drop temporary table
DROP TABLE temp_certificates;