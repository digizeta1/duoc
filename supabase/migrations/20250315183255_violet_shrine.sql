/*
  # Add estado column to certificates table

  1. Changes
    - Add `estado` column to certificates table with default value 'En Proceso'
    - Make the column NOT NULL to ensure every certificate has a status
    - Set default value to 'En Proceso' for all new certificates

  2. Notes
    - Uses IF NOT EXISTS check to prevent errors if column already exists
    - Maintains data integrity by providing a default value
*/

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'certificates' AND column_name = 'estado'
  ) THEN
    ALTER TABLE certificates ADD COLUMN estado text NOT NULL DEFAULT 'En Proceso';
  END IF;
END $$;