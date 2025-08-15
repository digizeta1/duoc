/*
  # Fix Certificate Date Display
  
  1. Changes
    - Update fecha_certificado for certificate 1744082757
    - Ensure date is stored in proper format
*/

-- Update the certificate date
UPDATE certificates 
SET fecha_certificado = '2025-03-15'::date
WHERE id = 1744082757;