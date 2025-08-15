/*
  # Add Custom Display Date for Certificates
  
  1. Changes
    - Add display_date column for custom date text
    - Set specific display date for certificate #1744082757
    - Maintain existing data
*/

-- Add display_date column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'certificates' AND column_name = 'display_date'
  ) THEN
    ALTER TABLE certificates ADD COLUMN display_date text;
  END IF;
END $$;

-- Update specific certificate to use custom display date
UPDATE certificates 
SET display_date = '15-03-2025'
WHERE id = 1744082757;