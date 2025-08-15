/*
  # Update Certificate Year and Date
  
  1. Changes
    - Update graduation_year to 2018
    - Update fecha_certificado to March 14, 2018
    - Only affects certificate ID 1746405339
*/

UPDATE certificates 
SET graduation_year = 2018,
    fecha_certificado = '2018-03-14'
WHERE id = 1746405339;