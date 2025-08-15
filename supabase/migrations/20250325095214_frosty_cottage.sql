/*
  # Create Certificates Table
  
  1. Changes
    - Create certificates table with proper structure
    - Import existing certificate data
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

-- Insert certificate data
INSERT INTO certificates (id, name, rut, career, created_at, qr_url, view_url, graduation_year, estado, whatsapp) VALUES
(1472003916, 'CRISTIAN PRUEBA', '17566455-6', 'ACTUACIÓN', '2025-03-17 23:46:33.273+00', 'https://certificadoduoc.cl/certificado/1472003916', 'https://certificadoduoc.cl/ValidacionQr?id=1472003916', 2025, 'En Proceso', NULL);

-- You can continue inserting the rest of the data here...