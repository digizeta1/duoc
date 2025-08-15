/*
  # Add RLS policies for certificates table

  1. Security Changes
    - Enable RLS on certificates table
    - Add policies for:
      - Insert: Allow authenticated users to create certificates
      - Select: Allow everyone to view certificates
*/

-- Enable RLS
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- Policy for inserting certificates (authenticated users only)
CREATE POLICY "Enable insert for authenticated users only"
ON certificates
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Policy for viewing certificates (public access)
CREATE POLICY "Enable read access for all users"
ON certificates
FOR SELECT
TO public
USING (true);