/*
  # Fix certificates table structure
  
  1. Changes
    - Recreate table with SERIAL ID
    - Preserve existing data
    - Set up proper indexes and constraints
    - Configure RLS policies
*/

-- Create temporary table
CREATE TEMP TABLE IF NOT EXISTS temp_certificates AS 
SELECT * FROM certificates;

-- Drop existing table
DROP TABLE IF EXISTS certificates CASCADE;

-- Create new table with SERIAL
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

-- Create index for better performance
CREATE INDEX certificates_id_idx ON certificates(id);

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