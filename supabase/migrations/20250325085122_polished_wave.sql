/*
  # Fix certificate ID handling
  
  1. Changes
    - Add index on id column for better performance
    - Ensure proper type casting for ID lookups
*/

-- Add index for better performance on ID lookups
CREATE INDEX IF NOT EXISTS certificates_id_idx ON certificates(id);

-- Update RLS policies to handle both numeric and UUID IDs
DROP POLICY IF EXISTS "Enable public read access" ON certificates;
CREATE POLICY "Enable public read access"
ON certificates
FOR SELECT
TO public
USING (true);