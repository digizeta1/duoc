/*
  # Update Certificate Date
  
  1. Changes
    - Update created_at date for certificate ID 1744082757
    - Only affects this specific record
    - Sets date to March 15, 2025
*/

UPDATE certificates 
SET created_at = '2025-03-15 00:00:00+00'
WHERE id = 1744082757;