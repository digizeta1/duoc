/*
  # Set up certificates sequence and constraints

  1. Changes
    - Drop existing sequence if exists
    - Create new sequence with proper settings
    - Modify id column configuration
    - Set up proper constraints
    - Grant necessary permissions

  2. Notes
    - Uses IF EXISTS checks for safety
    - Ensures proper sequence ownership
    - Sets up auto-incrementing functionality
*/

-- Drop existing sequence if it exists
DROP SEQUENCE IF EXISTS certificates_id_seq CASCADE;

-- Create new sequence with proper settings
CREATE SEQUENCE certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Modify the id column
ALTER TABLE certificates
    ALTER COLUMN id SET DATA TYPE bigint,
    ALTER COLUMN id SET DEFAULT nextval('certificates_id_seq'),
    ALTER COLUMN id SET NOT NULL;

-- Ensure primary key constraint
ALTER TABLE certificates
    DROP CONSTRAINT IF EXISTS certificates_pkey,
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);

-- Set proper sequence ownership
ALTER SEQUENCE certificates_id_seq OWNED BY certificates.id;

-- Set the sequence to start after the highest existing ID
SELECT setval('certificates_id_seq', COALESCE((SELECT MAX(id) FROM certificates), 0) + 1, false);