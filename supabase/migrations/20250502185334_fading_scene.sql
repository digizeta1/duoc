/*
  # Update Certificate Display Date
  
  1. Changes
    - Update fecha_certificado for certificate ID 1744082757
    - Change display date from 14-03-2025 to 15-03-2025
*/

UPDATE certificates 
SET fecha_certificado = '2025-03-15'
WHERE id = 1744082757;