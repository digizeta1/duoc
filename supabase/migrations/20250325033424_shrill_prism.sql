/*
  # Configure auto-incrementing ID for certificates

  1. Changes
    - Drop existing sequence if exists
    - Create new sequence for certificates
    - Modify id column to use bigserial
    - Ensure proper constraints and defaults

  2. Notes
    - Uses bigserial for large number range
    - Sets up auto-incrementing properly
    - Maintains data integrity with NOT NULL constraint
*/

-- Drop existing sequence if it exists
DROP SEQUENCE IF EXISTS certificates_id_seq CASCADE;

-- Create new sequence
CREATE SEQUENCE certificates_id_seq;

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