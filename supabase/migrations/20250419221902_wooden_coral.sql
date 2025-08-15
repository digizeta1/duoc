/*
  # Update Specific Certificate Date
  
  1. Changes
    - Update graduation date for certificate ID 1744082757
    - Only affects this specific record
    - No other changes to any other records
*/

-- Update specific certificate graduation date
UPDATE certificates 
SET graduation_year = 2025
WHERE id = 1744082757;