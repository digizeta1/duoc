/*
  # Update Certificate Year
  
  1. Changes
    - Update graduation_year and fecha_certificado for certificate ID 1746405339
    - Change year from 2013 to 2018
*/

UPDATE certificates 
SET graduation_year = 2018,
    fecha_certificado = '2018-03-14'
WHERE id = 1746405339;