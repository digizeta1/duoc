/*
  # Update Certificate Table Policies
  
  1. Changes
    - Drop all existing policies
    - Recreate policies with proper names
    - Ensure RLS is enabled
  
  2. Security
    - Public read access
    - Public insert access
*/

-- Drop ALL existing policies to avoid conflicts
DO $$ 
BEGIN
    -- Drop all policies from the certificates table
    EXECUTE (
        SELECT string_agg(
            format('DROP POLICY IF EXISTS %I ON certificates', policyname),
            '; '
        )
        FROM pg_policies 
        WHERE tablename = 'certificates'
    );
END $$;

-- Enable RLS
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- Create new policies with unique names
CREATE POLICY "certificates_public_insert_20250307"
ON certificates
FOR INSERT
TO public
WITH CHECK (true);

CREATE POLICY "certificates_public_read_20250307"
ON certificates
FOR SELECT
TO public
USING (true);