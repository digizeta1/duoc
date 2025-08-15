/*
  # Fix Certificates Table Structure
  
  1. Changes
    - Create certificates table with proper structure
    - Set up auto-incrementing ID
    - Import existing data
    - Configure RLS policies
*/

-- Create temporary table
CREATE TEMP TABLE temp_certificates AS 
SELECT * FROM certificates;

-- Drop existing table and sequence
DROP TABLE IF EXISTS certificates CASCADE;
DROP SEQUENCE IF EXISTS certificates_id_seq CASCADE;

-- Create new table with proper structure
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

-- Restore data with original IDs
INSERT INTO certificates (
    id, name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
)
SELECT 
    id::bigint, name, rut, career, graduation_year, whatsapp,
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