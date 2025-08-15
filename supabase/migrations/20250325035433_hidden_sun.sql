/*
  # Fix certificate ID sequence and constraints

  1. Changes
    - Drop and recreate sequence with proper settings
    - Reset table structure with correct ID handling
    - Restore existing data
    - Set up proper constraints and policies

  2. Security
    - Maintain existing RLS policies
    - Grant necessary sequence permissions
*/

-- Create temporary table to store existing data
CREATE TEMP TABLE temp_certificates AS 
SELECT * FROM certificates WHERE id IS NOT NULL;

-- Drop existing table and sequence
DROP TABLE IF EXISTS certificates CASCADE;
DROP SEQUENCE IF EXISTS certificates_id_seq CASCADE;

-- Create new sequence
CREATE SEQUENCE certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Create new table with proper structure
CREATE TABLE certificates (
    id bigint NOT NULL DEFAULT nextval('certificates_id_seq') PRIMARY KEY,
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

-- Restore data from temporary table, letting the sequence handle IDs
INSERT INTO certificates (
    name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
)
SELECT 
    name, rut, career, graduation_year, whatsapp,
    estado, created_at, qr_url, view_url
FROM temp_certificates;

-- Set sequence to proper value
SELECT setval('certificates_id_seq', COALESCE((SELECT MAX(id) FROM certificates), 0) + 1, false);

-- Set proper sequence ownership
ALTER SEQUENCE certificates_id_seq OWNED BY certificates.id;

-- Grant necessary permissions
GRANT USAGE, SELECT ON SEQUENCE certificates_id_seq TO public;

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