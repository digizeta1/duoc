-- Update specific certificate to show correct date
UPDATE certificates 
SET fecha_certificado = '2023-03-08'
WHERE id = 1746193857;

-- Add comment to explain fecha_certificado usage
COMMENT ON COLUMN certificates.fecha_certificado IS 'Certificate issue date - can be manually updated';

-- Ensure the column allows manual updates
ALTER TABLE certificates
  ALTER COLUMN fecha_certificado DROP NOT NULL,
  ALTER COLUMN fecha_certificado DROP DEFAULT;