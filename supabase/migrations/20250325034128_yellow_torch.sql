/*
  # Configure auto-incrementing ID for certificates table

  1. Changes
    - Drop existing sequence if exists
    - Create new sequence for certificates
    - Modify id column to be auto-incrementing bigint
    - Set up proper constraints and permissions
    - Reset sequence to proper starting value

  2. Notes
    - Uses IF EXISTS checks for safety
    - Ensures data integrity
    - Sets up proper auto-incrementing functionality
*/

-- Drop existing sequence if it exists
DROP SEQUENCE IF EXISTS certificates_id_seq CASCADE;

-- Create new sequence
CREATE SEQUENCE certificates_id_seq START WITH 1;

-- Modify the id column
ALTER TABLE certificates
  ALTER COLUMN id SET DATA TYPE bigint,
  ALTER COLUMN id SET DEFAULT nextval('certificates_id_seq'),
  ALTER COLUMN id SET NOT NULL;

-- Ensure primary key constraint
ALTER TABLE certificates
  DROP CONSTRAINT IF EXISTS certificates_pkey,
  ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);

-- Set the sequence to start after the highest existing ID
SELECT setval('certificates_id_seq', COALESCE((SELECT MAX(id) FROM certificates), 0) + 1, false);

-- Grant necessary permissions
ALTER SEQUENCE certificates_id_seq OWNED BY certificates.id;