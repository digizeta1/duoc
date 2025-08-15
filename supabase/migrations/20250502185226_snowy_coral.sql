/*
  # Update Certificate Date
  
  1. Changes
    - Update date for certificate ID 1744082757
    - Change from 14-03-2025 to 15-03-2025
    - Only affects this specific record
*/

UPDATE certificates 
SET created_at = '2025-03-15 00:00:00+00'
WHERE id = 1744082757;