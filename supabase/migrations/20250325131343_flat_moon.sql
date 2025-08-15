/*
  # Add graduation_year column to certificates table

  1. Changes
    - Add graduation_year column as integer with default value 0
    - Use IF NOT EXISTS check to prevent errors
*/

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'certificates' AND column_name = 'graduation_year'
  ) THEN
    ALTER TABLE certificates ADD COLUMN graduation_year integer DEFAULT 0;
  END IF;
END $$;