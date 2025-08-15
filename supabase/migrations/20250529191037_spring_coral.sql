/*
  # Add SEDE column to certificates table
  
  1. Changes
    - Add SEDE column with default value
    - Update existing certificates with default sede
*/

-- Add SEDE column if it doesn't exist
ALTER TABLE certificates 
ADD COLUMN IF NOT EXISTS sede text DEFAULT 'SEDE ANTONIO VARAS';

-- Set default value for existing certificates
UPDATE certificates 
SET sede = 'SEDE ANTONIO VARAS'
WHERE sede IS NULL;