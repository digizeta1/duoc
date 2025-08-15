/*
  # Fix certificates table RLS policies

  1. Security Changes
    - Drop existing policies
    - Add new policies for:
      - Insert: Allow authenticated users to create certificates
      - Select: Allow public access to view certificates
    - Ensure RLS is enabled
*/

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "certificates_insert_policy" ON certificates;
DROP POLICY IF EXISTS "certificates_select_policy" ON certificates;

-- Enable RLS
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- Create new policies
CREATE POLICY "Enable insert access for authenticated users only"
ON certificates
FOR INSERT
TO authenticated
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable read access for all users"
ON certificates
FOR SELECT
TO public
USING (true);