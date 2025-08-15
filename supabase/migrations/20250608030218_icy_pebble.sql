/*
  # Make RUT field editable in certificates table
  
  1. Changes
    - Add UPDATE policy to allow editing of certificate records
    - Enable public update access for certificates table
    - Allow modification of all certificate fields including RUT
  
  2. Security
    - Maintain existing RLS policies
    - Add new policy for updates
*/

-- Add UPDATE policy to allow editing certificates
CREATE POLICY "Enable public update access"
ON certificates
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);