/*
  # Update RUT case from uppercase K to lowercase k
  
  1. Changes
    - Update RUT 17150953-K to 17150953-k
    - Only affects this specific record
*/

UPDATE certificates 
SET rut = '17150953-k'
WHERE rut = '17150953-K';