/*
  # Add fecha_certificado column to certificates table
  
  1. Changes
    - Add fecha_certificado column as timestamp with time zone
    - Populate fecha_certificado for existing certificates
    - Set default value for new certificates
*/

-- Add fecha_certificado column
ALTER TABLE certificates 
ADD COLUMN IF NOT EXISTS fecha_certificado timestamp with time zone;

-- Update existing certificates to set fecha_certificado based on their creation date
UPDATE certificates
SET fecha_certificado = created_at
WHERE fecha_certificado IS NULL;

-- Set default value for new certificates
ALTER TABLE certificates
ALTER COLUMN fecha_certificado SET DEFAULT now();

-- Update specific certificate with March 15 date
UPDATE certificates 
SET fecha_certificado = '2025-03-15 00:00:00+00'
WHERE id = 1744082757;