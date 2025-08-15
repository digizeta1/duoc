/*
  # Fix certificates table RLS policies

  1. Security Changes
    - Drop existing policies
    - Add new policies for:
      - Insert: Allow authenticated users to create certificates
      - Select: Allow public access to view certificates
*/

-- Drop existing policies if they exist
DO $$ 
BEGIN
  DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON certificates;
  DROP POLICY IF EXISTS "Enable read access for all users" ON certificates;
  DROP POLICY IF EXISTS "Authenticated users can create certificates" ON certificates;
  DROP POLICY IF EXISTS "Certificates are viewable by everyone" ON certificates;
END $$;

-- Enable RLS
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- Policy for inserting certificates (authenticated users only)
CREATE POLICY "certificates_insert_policy"
ON certificates
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Policy for viewing certificates (public access)
CREATE POLICY "certificates_select_policy"
ON certificates
FOR SELECT
TO public
USING (true);