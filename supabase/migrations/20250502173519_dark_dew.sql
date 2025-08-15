/*
  # Update Certificate Date Handling
  
  1. Changes
    - Allow direct updates to fecha_certificado
    - Remove automatic date setting on graduation_year changes
    - Keep date formatting function for display
*/

-- Drop existing trigger to allow manual date updates
DROP TRIGGER IF EXISTS set_certificate_date_trigger ON certificates;

-- Drop existing functions
DROP FUNCTION IF EXISTS format_certificate_date(timestamptz) CASCADE;
DROP FUNCTION IF EXISTS get_friday_between_march_10_20(integer) CASCADE;
DROP FUNCTION IF EXISTS set_certificate_date() CASCADE;

-- Create function to format date as DD-MM-YYYY
CREATE FUNCTION format_certificate_date(date_value timestamptz)
RETURNS text AS $$
BEGIN
    RETURN to_char(date_value AT TIME ZONE 'UTC', 'DD-MM-YYYY');
END;
$$ LANGUAGE plpgsql;

-- Add comment to explain fecha_certificado usage
COMMENT ON COLUMN certificates.fecha_certificado IS 'Certificate issue date - can be manually updated';

-- Ensure fecha_certificado is nullable and can be updated
ALTER TABLE certificates
  ALTER COLUMN fecha_certificado DROP NOT NULL,
  ALTER COLUMN fecha_certificado DROP DEFAULT;