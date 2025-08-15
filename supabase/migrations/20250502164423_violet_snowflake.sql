/*
  # Update Certificate Creation Date
  
  1. Changes
    - Update creation date for certificate ID 1744082757 to March 15, 2025
    - Only affects this specific record
    - Maintains all other certificate data
*/

UPDATE certificates 
SET created_at = '2025-03-15 00:00:00+00'
WHERE id = 1744082757;